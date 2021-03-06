package co.phaz.n64_dev_cart

import chisel3._

class N64DevCartMain() extends Module {
    val io = IO(new Bundle {
        val n64adi = Input(UInt(16.W))
        val n64readn = Input(Bool())
        val n64ale_l = Input(Bool())
        val n64ale_h = Input(Bool())
        val n64ado = Output(UInt(16.W))
        val romAddr = Output(UInt(32.W))
        val romData = Input(UInt(16.W))
    })
    val prevAleH = RegInit(true.B) 
    val prevAleL = RegInit(true.B) 
    val prevReadN = RegInit(true.B) 
    val addr = RegInit(0.U(32.W))
    when (!io.n64ale_h && prevAleH) { // ALE_H falling edge
        addr := (addr & "hffff".U) | ((io.n64adi & "hffff".U) << 16)
    }.elsewhen (!io.n64ale_l && prevAleL) { // ALEL falling edge
        addr := (addr & "hffff0000".U) | (io.n64adi & "hffff".U)
    }.elsewhen (io.n64readn && !prevReadN) { // read rising edge
        addr := addr + 2.U
    }

    io.romAddr := addr;
    io.n64ado := io.romData

    prevAleH := io.n64ale_h
    prevAleL := io.n64ale_l
    prevReadN := io.n64readn
}



    // } else {
    //     val memory = Mem((1 << 18), UInt(16.W))
    //     loadMemoryFromFile(memory, "/Users/ed/n64/dx-explo/explode/rom.hex.txt")
    //     val addr = RegInit(0.U(32.W))
    //     when (!io.n64aleh && !RegNext(!io.n64aleh)) { // ALEH falling edge
    //         addr := (addr & "hffff".U) | ((io.n64adi & "hffff".U) << 16)
    //     }.elsewhen (!io.n64alel && !RegNext(!io.n64alel)) { // ALEL falling edge
    //         addr := (addr & "hffff0000".U) | (io.n64adi & "hffff".U)
    //     }.elsewhen (io.n64readn && RegNext(!io.n64readn)) { // read rising edge
    //         addr := addr + 2.U
    //     }
    //     io.n64ado := memory(addr >> 1)
    // }
    // val memory = if (useTestData) { VecInit(2.U(16.W), 3.U(16.W), 5.U(16.W), 7.U(16.W), 11.U(16.W),
    //         13.U(16.W), 17.U(16.W), 19.U(16.W), 23.U(16.W), 29.U(16.W), 31.U(16.W),
    //         37.U(16.W), 41.U(16.W), 43.U(16.W), 47.U(16.W), 53.U(16.W), 59.U(16.W),
    //         61.U(16.W), 67.U(16.W), 71.U(16.W), 73.U(16.W), 79.U(16.W), 83.U(16.W),
    //         89.U(16.W), 97.U(16.W)) } else { Mem((1 << 18), UInt(16.W)) }
    // if (useTestData) { loadMemoryFromFile(memory, "/Users/ed/n64/dx-explo/explode/rom.hex.txt") }
    // // } else {
    // //     val memory = Mem((1 << 18), UInt(16.W))
    // //     loadMemoryFromFile(memory, "/Users/ed/n64/dx-explo/explode/rom.hex.txt")
    // //     memory
    // // }
    // // val memory = VecInit(1.U(16.W), 2.U(16.W), 3.U(16.W), 4.U(16.W))
    // val addr = RegInit(0.U(32.W))
    // when (!io.n64aleh && !RegNext(!io.n64aleh)) { // ALEH falling edge
    //     addr := (addr & "hffff".U) | ((io.n64adi & "hffff".U) << 16)
    // }.elsewhen (!io.n64alel && !RegNext(!io.n64alel)) { // ALEL falling edge
    //     addr := (addr & "hffff0000".U) | (io.n64adi & "hffff".U)
    // }.elsewhen (io.n64readn && RegNext(!io.n64readn)) { // read rising edge
    //     addr := addr + 2.U
    // }
    // io.n64ado := memory(addr >> 1)
// }
