package co.phaz.n64_dev_cart

import chisel3._
import chisel3.iotesters.PeekPokeTester
import chisel3.util.log2Ceil
import java.util.Random
import scala.math.pow

package N64DevCartMainTesters {

    // Test stuff
    class ReadWords(dut: N64DevCartMain) extends PeekPokeTester(dut) {
        // Set initial state
        poke(dut.io.n64adi, 0.U(16.W))
        poke(dut.io.n64readn, true.B)
        poke(dut.io.n64alel, true.B)
        poke(dut.io.n64aleh, true.B)

        // Check initial output
        expect(dut.io.n64ado, 2.U(16.W))

        // Change address to 8 (which should contain 0x11)
        poke(dut.io.n64adi, 0.U(16.W))
        poke(dut.io.n64aleh, false.B)
        step(1)
        poke(dut.io.n64adi, 8.U(16.W))
        poke(dut.io.n64alel, false.B)
        step(1)
        poke(dut.io.n64readn, false.B)
        step(1)
        expect(dut.io.n64ado, 11.U(16.W))

        // Pulse the read line to increment the address (which should contain 13, then 17, then 19)
        poke(dut.io.n64readn, true.B)
        step(1)
        poke(dut.io.n64readn, false.B)
        step(1)
        expect(dut.io.n64ado, 13.U(16.W))
        poke(dut.io.n64readn, true.B)
        step(1)
        poke(dut.io.n64readn, false.B)
        step(1)
        expect(dut.io.n64ado, 17.U(16.W))
        poke(dut.io.n64readn, true.B)
        step(1)
        poke(dut.io.n64readn, false.B)
        step(1)
        expect(dut.io.n64ado, 19.U(16.W))
    }
}

    // poke(dut.io.swapBuffers, 0.U(1.W))
    // val random = new Random()

    // // Write to a location and then immediately read from it.
    // // Does this more times than NUM_PIXELS to ensure some locations
    // // get overwritten, to test that values can be changed once set.
    // 0 to (WriteAndReadData.NUM_PIXELS * 2) foreach { i => {
    //   val addr = random.nextInt(pow(2, 32).toInt)
    //   val data = random.nextInt(pow(2, 32).toInt)
    //   poke(dut.io.readEnable, 0.U(1.W))
    //   poke(dut.io.writeEnable, 1.U(1.W))
    //   poke(dut.io.address, addr.U(32.W))
    //   poke(dut.io.writeData, data.U(32.W))
    //   step(WriteAndReadData.SRAM_DELAY)
    //   poke(dut.io.writeEnable, 0.U(1.W))
    //   poke(dut.io.readEnable, 1.U(1.W))
    //   step(WriteAndReadData.SRAM_DELAY)
    //   expect(dut.io.readData, data.U(32.W))
    // }}

    // Write to 100 locations and then read from them in order
    // poke(dut.io.readEnable, 0.U(1.W))
    // poke(dut.io.writeEnable, 1.U(1.W))
    // 0 to (WriteAndReadData.NUM_PIXELS - 1) foreach { i => {
    //   poke(dut.io.address, i.U(32.W))
    //   poke(dut.io.writeData, i.U(32.W))
    //   step(WriteAndReadData.SRAM_DELAY)
    // }}
    // poke(dut.io.writeEnable, 0.U(1.W))
    // poke(dut.io.readEnable, 1.U(1.W))
    // 0 to (WriteAndReadData.NUM_PIXELS - 1) foreach { i => {
    //   poke(dut.io.address, i.U(32.W))
    //   step(WriteAndReadData.SRAM_DELAY)
    //   expect(dut.io.readData, i.U(32.W))
    // }}


//   object WriteAndReadData {
//     val NUM_PIXELS = 64
//     val SRAM_DELAY = 50
//   }
  // Test writing and then reading from the memory
//   class ClearsBackBuffer(dut: DepthBuffer) extends PeekPokeTester(dut) {
//     poke(dut.io.swapBuffers, 0.U(1.W))
//     val random = new Random()

//     // Fill up the memory
//     poke(dut.io.readEnable, 0.U(1.W))
//     poke(dut.io.writeEnable, 1.U(1.W))
//     0 to (WriteAndReadData.NUM_PIXELS - 1) foreach { i => {
//       poke(dut.io.address, i.U(32.W))
//       poke(dut.io.writeData, "h_FFFF_FFFF".U(32.W))
//       step(WriteAndReadData.SRAM_DELAY)
//     }}

//     // Give module time to clear memory, then verify that doneClearing is asserted
//     poke(dut.io.swapBuffers, 1.U(1.W))
//     step(1)
//     poke(dut.io.swapBuffers, 0.U(1.W))
//     step(WriteAndReadData.NUM_PIXELS * 5)
//     expect(dut.io.doneClearing, 1.U(1.W))

//     // Verify that memory was cleared
//     poke(dut.io.writeEnable, 0.U(1.W))
//     poke(dut.io.readEnable, 1.U(1.W))
//     0 to (WriteAndReadData.NUM_PIXELS - 2) foreach { i => {
//       poke(dut.io.address, i.U(32.W))
//       step(WriteAndReadData.SRAM_DELAY)
//       expect(dut.io.readData, 0.U(32.W))
//     }}
//   }

//   object ClearsBackBuffer {
//     val NUM_PIXELS = 64
//     val SRAM_DELAY = 50
//   }
      // println(peek(dut.io.address).toString(16))
      // println(peek(dut.io.readData).toString(16))



