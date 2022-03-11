package co.phaz.n64_dev_cart

import chisel3._

// This provides a nice write port and burst-read port wrapper to a SDRAM
// Write port is one word at a time.
// Read port allows you to pulse the 'next' pin to go to the next word.
// When the 'rd' pin is unasserted again, this resets the process and
// you have to send the base address again.
// Internally, when 'rd' is asserted, this will start filling a buffer
// with data from the row (up to 256 words worth). When 'rd' is
// deasserted, it stops.

// Writing:
// 1. Put address and data on writeport buses, assert 'wr'
// 2. If 'refreshing' not set (see below), controller latches them in.
// 3. Controller sets internal 'writing' reg
// 4. Controller activates bank and row.
// 5. Controller does write operation.
// 6. Controller "precharges" (de-activates) bank and row (fuck whoever came up with that term!)
// 7. Controller asserts 'ack'
// 8. Deassert 'wr'
// 9. Controller deasserts 'ack'
// 10. Controller unsets internal 'writing' reg

// Reading:
// 1. Put base address on readport, assert 'rd'
// 2. If 'refreshing' not set (see below) AND 'writing' not set (see above), controller latches it in
// 3. Controller activates bank and row
// 4. Controller starts a block read
// 5. Controller reads each word from the block in a loop into a buffer, checking the 'rd' input
// 5a. (Meanwhile, we can read from the buffer by pulsing 'next' which increments the buffer index that's
//   being output on the readport's data lines.)
// 6. When 'rd' goes low, or we've read 256 words from the row, it stops this loop,
//    interrupts block read if it's in progress, precharges row.
// 7. If 'rd' is low, controller continues, otherwise waits for it to do so
// 8. Controller resets buffer index
 
// Refreshing:
// 1. Every clock cycle, the controller increments a counter.
// 2. If the counter is > N
// 3. Controller sets the internal 'refreshing' reg
// 4. Controller tells SDRAM to refresh itself
// 5. Waits for return trigger or counts clock cycles or whatever to pass time
// 6. Controller unsets internal 'refreshing' reg

class MisterSdram32MBController() extends Module {
    val io = IO(new Bundle {
        val sdram_dq_in = Input(UInt(16.W))
        val sdram_dq_out = Output(UInt(16.W))
        val sdram_a_out = Output(UInt(13.W))
        val sdram_we = Output(Bool())
        val sdram_cas = Output(Bool())
        val sdram_ras = Output(Bool())
        val sdram_cs1 = Output(Bool())
        val sdram_ba = Output(UInt(2.W))
        val sdram_clk = Output(Bool())

        val writeport_wr = Input(Bool())
        val writeport_addr = Input(UInt(32.W))
        val writeport_data = Input(UInt(16.W))
        val writeport_ack = Output(Bool())

        val readport_rd = Input(Bool())
        val readport_addr = Input(UInt(32.W))
        val readport_data = Output(UInt(16.W))
        val readport_next = Input(Bool())
    })
    val refreshState = RegInit(0.U(4.W))
    val writeState = RegInit(0.U(4.W))
    val readState = RegInit(0.U(4.W))
    val refreshCounter = RegInit(0.W(32.W))
    val sdramClk = RegInit(false.B)
    val waitCounter = RegInit(0.U(4.W))
    def outputNOP { io.sdram_we := true.B; io.sdram_cas := true.B ; io.sdram_ras := true.B }
    def outputRefresh { io.sdram_we := true.B; io.sdram_cas := false.B ; io.sdram_ras := false.B }
    def outputBankActivate { io.sdram_we := true.B; io.sdram_cas := true.B ; io.sdram_ras := false.B }
    sdramClk := ~sdramClk
    io.sdram_clk := sdramClk
    io.sdram_ba := 0 // Just use one bank for now
    when (sdramClk) {
        when (refreshState != 0) {
            when (refreshState == 1) {
                // Bippity-boppity, give him the zoppity
                outputRefresh
                refreshState := 2
                waitCounter := 0
            }.elsewhen (refreshState == 2) {
                when (waitCounter > 5) { // TODO: Tweak this value? (60ns, so what's that? 3 50mhz cycles?) (50mhz/(1/(60ns)))
                    refreshState := 0 // Back to idle
                    outputRefresh
                }.otherwise {
                    outputNOP
                    waitCounter := waitCounter + 1
                }
            }
        }.elsewhen (writeState != 0) {
            when (writeState == 1) { // Bank activate
                outputBankActivate
                writeState := 2
                waitCounter := 0
            }.elsewhen (writeState == 2) {
                //
            }
            // TODO: Do writing stuff
        }.elsewhen (readState != 0) {
            // TODO: Do reading stuff
        }.elsewhen (refreshCounter > 300.U) { // TODO: Tweak this value? (8192 times each 64ms, so that's what? every 390 50mhz cycles?) (50mhz/(1/((64ms)/8192)))
            // Idle and need to do a refresh, so start it
            refreshState := 1
            refreshCounter := 0
        }.elsewhen (io.writeport_wr) {
            // User is starting a write on the write port...
            writeState := 1
        }.elsewhen (io.readport_rd) {
            // User is starting a read on the read port...
            writeState := 1
        }.otherwise {
            // Idle, wait for refresh...
            refreshCounter := refreshCounter + 1;
        }
    }
}
