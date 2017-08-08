// swift-tools-version:4.0

import PackageDescription

#if swift(>=4.0)

let package = Package(
	name: "syncprint",
	products: [
    .library(name: "syncprint", type: .static, targets: ["syncprint"]),
  ],
	dependencies: [
    .package(url: "https://github.com/glessard/swift-atomics.git", from: "3.0.0"),
  ],
  targets: [
    .target(name: "syncprint", dependencies: ["Atomics"], path: "Sources"),
    .testTarget(name: "syncprintTests", dependencies: ["syncprint"])
  ]
)

#else

let package = Package(
  name: "syncprint",
  dependencies: [
    .Package(url: "https://github.com/glessard/swift-atomics.git", majorVersion: 3),
  ]
)

#endif
