scalaVersion := "2.12.8"
scalacOptions := Seq("-Xsource:2.11")
resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases")
)
libraryDependencies +=
	"edu.berkeley.cs" %% "chisel3" % "3.2.+"
libraryDependencies +=
	"edu.berkeley.cs" %% "chisel-iotesters" % "1.3-SNAPSHOT"
// libraryDependencies +=
// 	"edu.berkeley.cs" %% "hardfloat" % "1.3-SNAPSHOT"
// libraryDependencies +=
// 	"edu.berkeley.cs" %% "chisel3" % "3.5.1"
// libraryDependencies +=
// 	"edu.berkeley.cs" %% "chisel-iotesters" % "2.5.1"
