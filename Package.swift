// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImagePickerModule",
    platforms: [.iOS(SupportedPlatform.IOSVersion.v14)],
    products: [
        .library(
            name: "ImagePickerModule",
            targets: ["ImagePickerModule"]
        ),
    ],
    targets: [
        .target(name: "ImagePickerModule"),
        .testTarget(
            name: "ImagePickerModuleTests",
            dependencies: ["ImagePickerModule"]
        ),
    ]
)
