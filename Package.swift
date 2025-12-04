// swift-tools-version:5.9
//
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Swift 5.9 is available from Xcode 15.0.

import PackageDescription

let package = Package(
  name: "ApolloCodegen_Legacy",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(name: "ApolloCodegenLib_Legacy", targets: ["ApolloCodegenLib_Legacy"]),
    .library(name: "CodegenCLI_Legacy", targets: ["CodegenCLI_Legacy"]),
    .executable(name: "apollo-ios-cli-legacy", targets: ["apollo-ios-cli-legacy"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/mattt/InflectorKit",
      .upToNextMajor(from: "1.0.0")),
    .package(
      url: "https://github.com/apple/swift-collections",
      .upToNextMajor(from: "1.1.0")),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git", 
      .upToNextMajor(from: "1.3.0")),
  ],
  targets: [
    .target(
      name: "ApolloCodegenLib_Legacy",
      dependencies: [
        "GraphQLCompiler_Legacy",
        "IR_Legacy",
        "TemplateString_Legacy",
        .product(name: "InflectorKit", package: "InflectorKit"),
        .product(name: "OrderedCollections", package: "swift-collections")
      ],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
    .target(
      name: "GraphQLCompiler_Legacy",
      dependencies: [
        "TemplateString_Legacy",
        .product(name: "OrderedCollections", package: "swift-collections")
      ],
      exclude: [
        "JavaScript"
      ],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
    .target(
      name: "IR_Legacy",
      dependencies: [
        "GraphQLCompiler_Legacy",
        "TemplateString_Legacy",
        "Utilities_Legacy",
        .product(name: "OrderedCollections", package: "swift-collections")
      ],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
    .target(
      name: "TemplateString_Legacy",
      dependencies: [],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
    .target(
      name: "Utilities_Legacy",
      dependencies: [],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
    .executableTarget(
      name: "apollo-ios-cli-legacy",
      dependencies: [
        "CodegenCLI_Legacy",
      ],
      exclude: [
        "README.md",
      ],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
    .target(
      name: "CodegenCLI_Legacy",
      dependencies: [
        "ApolloCodegenLib_Legacy",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
    ),
  ]
)
