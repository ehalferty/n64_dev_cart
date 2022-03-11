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
        val sdram_a = Output(UInt(13.W))
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
        val readport_ack = Output(Bool())
    })
    val const_nopSlots = 5.U // TODO: Tweak this value? (60ns, so what's that? 3 50mhz cycles?) (50mhz/(1/(60ns)))
    val const_refreshAt = 300.U // TODO: Tweak this value? (8192 times each 64ms,
                                // so that's what? every 390 50mhz cycles?) (50mhz/(1/((64ms)/8192)))
    val startupState = RegInit(1.U(4.W))
    val refreshState = RegInit(0.U(4.W))
    val writeState = RegInit(0.U(4.W))
    val readState = RegInit(0.U(4.W))
    val refreshCounter = RegInit(0.U(32.W))
    val sdramClk = RegInit(false.B)
    val waitCounter = RegInit(0.U(4.W))
    val latchedAddr = RegInit(0.U(32.W))
    val latchedData = RegInit(0.U(16.W))
    def outputNOP { io.sdram_we := true.B; io.sdram_cas := true.B ; io.sdram_ras := true.B }
    def outputRefresh { io.sdram_we := true.B; io.sdram_cas := false.B ; io.sdram_ras := false.B }
    def outputBankActivate {
        io.sdram_we := true.B; io.sdram_cas := true.B ; io.sdram_ras := false.B
        io.sdram_ba := latchedAddr(24, 23)
        io.sdram_a := latchedAddr(22, 13)
    }
    def outputRead {
        io.sdram_we := true.B; io.sdram_cas := false.B ; io.sdram_ras := true.B
        io.sdram_ba := latchedAddr(24, 23)
        io.sdram_a := "h400".U + latchedAddr(9, 0)
    }
    def outputWrite {
        io.sdram_we := false.B; io.sdram_cas := false.B ; io.sdram_ras := true.B
        io.sdram_a := latchedAddr(9, 0)
        io.sdram_dq_out := latchedData
    }
    def outputPrechargeAll {
        io.sdram_we := false.B; io.sdram_cas := true.B ; io.sdram_ras := false.B
        io.sdram_a := "h400".U // Set A10
    }
    // Do stuff on the cadence of the SDRAM clock
    when (sdramClk === true.B) {
        when (startupState =/= 0.U) {
            // ================== STARTUP ==================
            // TODO: Do startup stuff
        }.elsewhen (refreshState =/= 0.U) {
            // ================== REFRESH ==================
            when (refreshState === 1.U) {
                outputRefresh
                refreshState := 2.U
                waitCounter := 0.U
            }.elsewhen (refreshState === 2.U) { // NOP slots after refresh
                outputNOP
                when (waitCounter > const_nopSlots) { refreshState := 0.U }.otherwise { waitCounter := waitCounter + 1.U }
            }
        }.elsewhen (writeState =/= 0.U) {


            // ================== WRITE ==================
            when (writeState === 1.U) { // Bank activate
                outputBankActivate
                writeState := 2.U
                waitCounter := 0.U
            }.elsewhen (writeState === 2.U) { // NOP slots after activate
                outputNOP
                when (waitCounter > const_nopSlots) { writeState := 3.U }.otherwise { waitCounter := waitCounter + 1.U }
            }.elsewhen (writeState === 3.U) { // Do write
                outputWrite
                writeState := 4.U
                waitCounter := 0.U
            }.elsewhen (writeState === 4.U) { // NOP slots after write
                outputNOP
                when (waitCounter > const_nopSlots) { writeState := 5.U }.otherwise { waitCounter := waitCounter + 1.U }
            }.elsewhen (writeState === 5.U) { // Do prechargeAll
                outputPrechargeAll
                writeState := 6.U
            }.elsewhen (writeState === 6.U) { // NOP slots after prechargeAll
                outputNOP
                when (waitCounter > const_nopSlots) { writeState := 7.U }.otherwise { waitCounter := waitCounter + 1.U }
            }.otherwise { // Assert writeport_ack, wait for writeport_wr to be deasserted
                when (io.writeport_wr === false.B) { writeState := 0.U }.otherwise {
                    outputNOP
                    io.writeport_ack := true.B
                }
            }



        }.elsewhen (readState =/= 0.U) {
            // ================== READ ==================
            when (readState === 1.U) { // Bank activate
                outputBankActivate
                readState := 2.U
                waitCounter := 0.U
            }.elsewhen (readState === 2.U) { // NOP slots after activate
                outputNOP
                when (waitCounter > const_nopSlots) { readState := 3.U }.otherwise { waitCounter := waitCounter + 1.U }
            }.elsewhen (readState === 3.U) { // Do read
                outputRead
                readState := 4.U
                waitCounter := 0.U
            }.elsewhen (readState === 4.U) { // NOP slots after read (also grab the result here)
                outputNOP
                when (waitCounter > const_nopSlots) { readState := 5.U }.otherwise { waitCounter := waitCounter + 1.U }
            }.elsewhen (readState === 5.U) { // Do prechargeAll
                outputPrechargeAll
                readState := 6.U
            }.elsewhen (readState === 6.U) { // NOP slots after prechargeAll
                outputNOP
                when (waitCounter > const_nopSlots) { readState := 7.U }.otherwise { waitCounter := waitCounter + 1.U }
            }.otherwise { // Assert readport_ack, wait for readport_rd to be deasserted
                when (io.readport_rd === false.B) { readState := 0.U }.otherwise {
                    outputNOP
                    io.readport_ack := true.B
                }
            }
            // TODO: Do reading stuff
        }.elsewhen (refreshCounter > const_refreshAt) {
            // ================== START REFRESH ==================
            // Idle and need to do a refresh, so start it
            refreshState := 1.U
            refreshCounter := 0.U
        }.elsewhen (io.writeport_wr === true.B) {
            // ================== START WRITE ==================
            // User is starting a write on the write port...
            latchedAddr := io.writeport_addr
            latchedData := io.writeport_data
            writeState := 1.U
        }.elsewhen (io.readport_rd === true.B) {
            // ================== START READ ==================
            // User is starting a read on the read port...
            latchedAddr := io.writeport_addr
            readState := 1.U
        }.otherwise {
            // ================== IDLE ==================
            // Idle, wait for refresh...
            refreshCounter := refreshCounter + 1.U;
        }
    }

    // Divide chisel clock by 2 to get SDRAM clock
    sdramClk := ~sdramClk
    io.sdram_clk := sdramClk
    // Default values
    io.sdram_dq_out := 0.U
    io.sdram_a := 0.U
    io.sdram_we := true.B
    io.sdram_cas := true.B
    io.sdram_ras := true.B
    io.sdram_cs1 := false.B
    io.sdram_ba := 0.U
    // io.sdram_clk := false.B
    io.writeport_ack := false.B
    io.readport_data := 0.U
    io.readport_ack := false.B
}
