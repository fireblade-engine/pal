# Fireblade PAL (Platform Abstraction Layer)

[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![macOS](https://github.com/fireblade-engine/pal/actions/workflows/ci-macos.yml/badge.svg)](https://github.com/fireblade-engine/pal/actions/workflows/ci-macos.yml)
[![Linux](https://github.com/fireblade-engine/pal/actions/workflows/ci-linux.yml/badge.svg)](https://github.com/fireblade-engine/pal/actions/workflows/ci-linux.yml)

A lightweight platform abstraction layer in Swift. It is developed and maintained as part of the Fireblade Game Engine project.

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your local machine and provide a code example.

### 📋 Prerequisites

* [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager)
* [Swiftlint](https://github.com/realm/SwiftLint) for linting - (optional)

### 💻 Installing

Fireblade PAL is available for all platforms that support [Swift 5.3](https://swift.org/) and higher and the [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager).

Extend the following lines in your `Package.swift` file or use it to create a new project.

```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/fireblade-engine/pal.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["FirebladePAL"])
    ]
)

```


## 💁 How to contribute

If you want to contribute please see the [CONTRIBUTION GUIDE](CONTRIBUTING.md) first. 

To start your project contribution run these in your command line:

1. `git clone git@github.com:fireblade-engine/pal.git fireblade-pal`
2. `cd fireblade-pal`
3. `make setupEnvironment`

Before commiting code please ensure to run:

- `make pre-push`

This project is currently maintained by [Christian Treffs](https://github.com/ctreffs).   
See also the list of [contributors](https://github.com/fireblade-engine/pal/contributors) who participated in this project.

## 🔏 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
