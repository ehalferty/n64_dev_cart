;buildInfoPackage: chisel3, version: 3.2.8, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit N64DevCartMain : 
  module N64DevCartMain : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip n64adi : UInt<16>, flip n64readn : UInt<1>, flip n64ale_l : UInt<1>, flip n64ale_h : UInt<1>, n64ado : UInt<16>, romAddr : UInt<32>, flip romData : UInt<16>}
    
    reg prevAleH : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[N64DevCartMain.scala 15:27]
    reg prevAleL : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[N64DevCartMain.scala 16:27]
    reg prevReadN : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[N64DevCartMain.scala 17:28]
    reg addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[N64DevCartMain.scala 18:23]
    node _T = eq(io.n64ale_h, UInt<1>("h00")) @[N64DevCartMain.scala 19:11]
    node _T_1 = and(_T, prevAleH) @[N64DevCartMain.scala 19:24]
    when _T_1 : @[N64DevCartMain.scala 19:37]
      node _T_2 = and(addr, UInt<16>("h0ffff")) @[N64DevCartMain.scala 20:23]
      node _T_3 = and(io.n64adi, UInt<16>("h0ffff")) @[N64DevCartMain.scala 20:50]
      node _T_4 = shl(_T_3, 16) @[N64DevCartMain.scala 20:63]
      node _T_5 = or(_T_2, _T_4) @[N64DevCartMain.scala 20:36]
      addr <= _T_5 @[N64DevCartMain.scala 20:14]
      skip @[N64DevCartMain.scala 19:37]
    else : @[N64DevCartMain.scala 21:43]
      node _T_6 = eq(io.n64ale_l, UInt<1>("h00")) @[N64DevCartMain.scala 21:17]
      node _T_7 = and(_T_6, prevAleL) @[N64DevCartMain.scala 21:30]
      when _T_7 : @[N64DevCartMain.scala 21:43]
        node _T_8 = and(addr, UInt<32>("h0ffff0000")) @[N64DevCartMain.scala 22:23]
        node _T_9 = and(io.n64adi, UInt<16>("h0ffff")) @[N64DevCartMain.scala 22:53]
        node _T_10 = or(_T_8, _T_9) @[N64DevCartMain.scala 22:40]
        addr <= _T_10 @[N64DevCartMain.scala 22:14]
        skip @[N64DevCartMain.scala 21:43]
      else : @[N64DevCartMain.scala 23:44]
        node _T_11 = eq(prevReadN, UInt<1>("h00")) @[N64DevCartMain.scala 23:32]
        node _T_12 = and(io.n64readn, _T_11) @[N64DevCartMain.scala 23:29]
        when _T_12 : @[N64DevCartMain.scala 23:44]
          node _T_13 = add(addr, UInt<2>("h02")) @[N64DevCartMain.scala 24:22]
          node _T_14 = tail(_T_13, 1) @[N64DevCartMain.scala 24:22]
          addr <= _T_14 @[N64DevCartMain.scala 24:14]
          skip @[N64DevCartMain.scala 23:44]
    io.romAddr <= addr @[N64DevCartMain.scala 27:16]
    io.n64ado <= io.romData @[N64DevCartMain.scala 28:15]
    prevAleH <= io.n64ale_h @[N64DevCartMain.scala 30:14]
    prevAleL <= io.n64ale_l @[N64DevCartMain.scala 31:14]
    prevReadN <= io.n64readn @[N64DevCartMain.scala 32:15]
    
