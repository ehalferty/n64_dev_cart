package co.phaz.n64_dev_cart

object Main extends App {
  chisel3.Driver.execute("-td chisel_output".split(" +"), () => new N64DevCartMain())
}
