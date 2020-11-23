// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGenStrings",
	platforms: [
		.macOS(.v10_12)
	],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "SwiftGenStrings",
            targets: ["SwiftGenStrings"]
		),
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0")
	],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftGenStrings",
			dependencies: [
                "SwiftGenStringsCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
		),
		.target(
			name: "SwiftGenStringsCore",
			dependencies: []
		),
        .testTarget(
            name: "SwiftGenStringsTests",
            dependencies: ["SwiftGenStringsCore"],
			resources: [
				.process("testReportErrorOnSwiftUnicodeCodePoint.txt"),
				.process("testUnescapesDoublyEscapedUnicodeCodePoints.txt")
			]
		),
    ]
)
