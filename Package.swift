// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "CodeMirror",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
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
        )
    ]
)
