// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ContentGenerator",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ContentGenerator",
            targets: ["ContentGenerator"])
    ],
    targets: [
        .target(
            name: "ContentGenerator",
            dependencies: []
        )
    ]
)
