package co.phaz.n64_dev_cart

import chisel3._
import chisel3.iotesters.PeekPokeTester
import org.scalatest.{FlatSpec, Matchers}

class N64DevCartMainSpec extends FlatSpec with Matchers {
  behavior of "N64DevCartMain"

  it should "do stuff" in {
    chisel3.iotesters.Driver.execute(
      Array("--fint-write-vcd", "--backend-name", "firrtl"),
      () => new N64DevCartMain(),
    ) { c =>
      new N64DevCartMainTesters.ReadWords(c)
    } should be(true)
  }

  it should "blah" in {
    5 should equal (5)
  }
}

//   it should "clear back buffer" in {
//     val numPixels = DepthBufferTesters.ClearsBackBuffer.NUM_PIXELS
//     chisel3.iotesters.Driver.execute(
//       Array("--fint-write-vcd", "--backend-name", "firrtl"),
//       () => new DepthBuffer(numPixels),
//     ) { c =>
//       new DepthBufferTesters.ClearsBackBuffer(c)
//     } should be(true)
//   }
