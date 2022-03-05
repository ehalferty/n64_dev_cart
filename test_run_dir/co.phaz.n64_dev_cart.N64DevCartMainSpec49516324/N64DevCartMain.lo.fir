circuit N64DevCartMain :
  module N64DevCartMain :
    input clock : Clock
    input reset : UInt<1>
    input io_n64adi : UInt<16>
    input io_n64readn : UInt<1>
    input io_n64alel : UInt<1>
    input io_n64aleh : UInt<1>
    output io_n64ado : UInt<16>
  
    reg addr : UInt<32>, clock with :
      reset => (UInt<1>("h0"), addr) @[N64DevCartMain.scala 18:23]
    node _T = eq(io_n64aleh, UInt<1>("h0")) @[N64DevCartMain.scala 19:11]
    node _T_1 = eq(io_n64aleh, UInt<1>("h0")) @[N64DevCartMain.scala 19:35]
    reg _T_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), _T_2) @[N64DevCartMain.scala 19:34]
    node _T_3 = eq(_T_2, UInt<1>("h0")) @[N64DevCartMain.scala 19:26]
    node _T_4 = and(_T, _T_3) @[N64DevCartMain.scala 19:23]
    node _T_5 = and(addr, UInt<16>("hffff")) @[N64DevCartMain.scala 20:23]
    node _T_6 = and(io_n64adi, UInt<16>("hffff")) @[N64DevCartMain.scala 20:50]
    node _T_7 = shl(_T_6, 16) @[N64DevCartMain.scala 20:63]
    node _T_8 = or(_T_5, _T_7) @[N64DevCartMain.scala 20:36]
    node _T_9 = eq(io_n64alel, UInt<1>("h0")) @[N64DevCartMain.scala 21:17]
    node _T_10 = eq(io_n64alel, UInt<1>("h0")) @[N64DevCartMain.scala 21:41]
    reg _T_11 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), _T_11) @[N64DevCartMain.scala 21:40]
    node _T_12 = eq(_T_11, UInt<1>("h0")) @[N64DevCartMain.scala 21:32]
    node _T_13 = and(_T_9, _T_12) @[N64DevCartMain.scala 21:29]
    node _T_14 = and(addr, UInt<32>("hffff0000")) @[N64DevCartMain.scala 22:23]
    node _T_15 = and(io_n64adi, UInt<16>("hffff")) @[N64DevCartMain.scala 22:53]
    node _T_16 = or(_T_14, _T_15) @[N64DevCartMain.scala 22:40]
    node _T_17 = eq(io_n64readn, UInt<1>("h0")) @[N64DevCartMain.scala 23:40]
    reg _T_18 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), _T_18) @[N64DevCartMain.scala 23:39]
    node _T_19 = and(io_n64readn, _T_18) @[N64DevCartMain.scala 23:29]
    node _T_20 = add(addr, UInt<2>("h2")) @[N64DevCartMain.scala 24:22]
    node _T_21 = tail(_T_20, 1) @[N64DevCartMain.scala 24:22]
    node _GEN_0 = mux(_T_19, _T_21, addr) @[N64DevCartMain.scala 23:55]
    node _GEN_1 = mux(_T_13, _T_16, _GEN_0) @[N64DevCartMain.scala 21:55]
    node _GEN_2 = mux(_T_4, _T_8, _GEN_1) @[N64DevCartMain.scala 19:49]
    node _T_22 = shr(addr, 1) @[N64DevCartMain.scala 26:30]
    node _T_23 = bits(_T_22, 1, 0)
    node memory_0 = pad(UInt<1>("h1"), 3) @[N64DevCartMain.scala 15:25 N64DevCartMain.scala 15:25]
    node _GEN_3 = validif(eq(UInt<1>("h0"), _T_23), memory_0) @[N64DevCartMain.scala 26:15]
    node memory_1 = pad(UInt<2>("h2"), 3) @[N64DevCartMain.scala 15:25 N64DevCartMain.scala 15:25]
    node _GEN_4 = mux(eq(UInt<1>("h1"), _T_23), memory_1, _GEN_3) @[N64DevCartMain.scala 26:15]
    node memory_2 = pad(UInt<2>("h3"), 3) @[N64DevCartMain.scala 15:25 N64DevCartMain.scala 15:25]
    node _GEN_5 = mux(eq(UInt<2>("h2"), _T_23), memory_2, _GEN_4) @[N64DevCartMain.scala 26:15]
    node memory_3 = UInt<3>("h4") @[N64DevCartMain.scala 15:25 N64DevCartMain.scala 15:25]
    node _GEN_6 = mux(eq(UInt<2>("h3"), _T_23), memory_3, _GEN_5) @[N64DevCartMain.scala 26:15]
    node _memory_T_23 = _GEN_6 @[N64DevCartMain.scala 26:15 N64DevCartMain.scala 26:15 N64DevCartMain.scala 26:15 N64DevCartMain.scala 26:15 N64DevCartMain.scala 26:15]
    io_n64ado <= _memory_T_23 @[N64DevCartMain.scala 26:15]
    addr <= mux(reset, UInt<32>("h0"), _GEN_2) @[N64DevCartMain.scala 20:14 N64DevCartMain.scala 22:14 N64DevCartMain.scala 24:14]
    _T_2 <= _T_1 @[N64DevCartMain.scala 19:34]
    _T_11 <= _T_10 @[N64DevCartMain.scala 21:40]
    _T_18 <= _T_17 @[N64DevCartMain.scala 23:39]
