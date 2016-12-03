import PackageDescription

let package = Package(
	name: "syncprint",
	dependencies: [
    .Package(url: "https://github.com/glessard/swift-atomics.git", majorVersion: 2),
  ]
)
