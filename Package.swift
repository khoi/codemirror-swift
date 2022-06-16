// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "CodeMirror",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
    ],
    products: [

        .library(
            name: "CodeMirror",
            targets: ["CodeMirror"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CodeMirror",
            dependencies: [],
            exclude: [
                "src/node_modules",
                "src/editor.js",
                "src/rollup.config.js",
                "src/package.json",
                "src/package-lock.json",
            ],
            resources: [
                .copy("src/build")
            ]
        ),
        .testTarget(
            name: "CodeMirrorTests",
            dependencies: ["CodeMirror"]
        ),
    ]
)
