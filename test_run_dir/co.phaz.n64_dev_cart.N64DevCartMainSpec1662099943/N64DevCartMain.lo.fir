circuit N64DevCartMain :
  module N64DevCartMain :
    input clock : Clock
    input reset : UInt<1>
    input io_n64adi : UInt<16>
    input io_n64readn : UInt<1>
    input io_n64alel : UInt<1>
    input io_n64aleh : UInt<1>
    output io_n64ado : UInt<16>
  
    mem memory : @[N64DevCartMain.scala 15:21]
      data-type => UInt<16>
      depth => 262144
      read-latency => 0
      write-latency => 1
      reader => _T_24
      read-under-write => undefined
    reg addr : UInt<32>, clock with :
      reset => (UInt<1>("h0"), addr) @[N64DevCartMain.scala 17:23]
    node _T = eq(io_n64aleh, UInt<1>("h0")) @[N64DevCartMain.scala 18:11]
    node _T_1 = eq(io_n64aleh, UInt<1>("h0")) @[N64DevCartMain.scala 18:35]
    reg _T_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), _T_2) @[N64DevCartMain.scala 18:34]
    node _T_3 = eq(_T_2, UInt<1>("h0")) @[N64DevCartMain.scala 18:26]
    node _T_4 = and(_T, _T_3) @[N64DevCartMain.scala 18:23]
    node _T_5 = and(addr, UInt<16>("hffff")) @[N64DevCartMain.scala 19:23]
    node _T_6 = and(io_n64adi, UInt<16>("hffff")) @[N64DevCartMain.scala 19:50]
    node _T_7 = shl(_T_6, 16) @[N64DevCartMain.scala 19:63]
    node _T_8 = or(_T_5, _T_7) @[N64DevCartMain.scala 19:36]
    node _T_9 = eq(io_n64alel, UInt<1>("h0")) @[N64DevCartMain.scala 20:17]
    node _T_10 = eq(io_n64alel, UInt<1>("h0")) @[N64DevCartMain.scala 20:41]
    reg _T_11 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), _T_11) @[N64DevCartMain.scala 20:40]
    node _T_12 = eq(_T_11, UInt<1>("h0")) @[N64DevCartMain.scala 20:32]
    node _T_13 = and(_T_9, _T_12) @[N64DevCartMain.scala 20:29]
    node _T_14 = and(addr, UInt<32>("hffff0000")) @[N64DevCartMain.scala 21:23]
    node _T_15 = and(io_n64adi, UInt<16>("hffff")) @[N64DevCartMain.scala 21:53]
    node _T_16 = or(_T_14, _T_15) @[N64DevCartMain.scala 21:40]
    node _T_17 = eq(io_n64readn, UInt<1>("h0")) @[N64DevCartMain.scala 22:40]
    reg _T_18 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), _T_18) @[N64DevCartMain.scala 22:39]
    node _T_19 = and(io_n64readn, _T_18) @[N64DevCartMain.scala 22:29]
    node _T_20 = add(addr, UInt<2>("h2")) @[N64DevCartMain.scala 23:22]
    node _T_21 = tail(_T_20, 1) @[N64DevCartMain.scala 23:22]
    node _GEN_0 = mux(_T_19, _T_21, addr) @[N64DevCartMain.scala 22:55]
    node _GEN_1 = mux(_T_13, _T_16, _GEN_0) @[N64DevCartMain.scala 20:55]
    node _GEN_2 = mux(_T_4, _T_8, _GEN_1) @[N64DevCartMain.scala 18:49]
    node _T_22 = shr(addr, 1) @[N64DevCartMain.scala 25:30]
    node _T_23 = bits(_T_22, 17, 0) @[N64DevCartMain.scala 25:24]
    io_n64ado <= memory._T_24.data @[N64DevCartMain.scala 25:15]
    memory._T_24.addr <= _T_23 @[N64DevCartMain.scala 25:24]
    memory._T_24.en <= UInt<1>("h1") @[N64DevCartMain.scala 15:21 N64DevCartMain.scala 25:24]
    memory._T_24.clk <= clock @[N64DevCartMain.scala 25:24]
    addr <= mux(reset, UInt<32>("h0"), _GEN_2) @[N64DevCartMain.scala 19:14 N64DevCartMain.scala 21:14 N64DevCartMain.scala 23:14]
    _T_2 <= _T_1 @[N64DevCartMain.scala 18:34]
    _T_11 <= _T_10 @[N64DevCartMain.scala 20:40]
    _T_18 <= _T_17 @[N64DevCartMain.scala 22:39]
