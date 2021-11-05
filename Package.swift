import Foundation
// swift-tools-version:5.3
import PackageDescription

enum Env: String, CaseIterable {
    /// Make SDL platform available.
    case FRB_ENABLE_PLATFORM_SDL

    /// Make Apple platforms available
    case FRB_ENABLE_PLATFORM_APPL

    /// Make Metal graphics API available.
    case FRB_ENABLE_GRAPHICS_METAL

    /// Make Vulkan graphics API available.
    case FRB_ENABLE_GRAPHICS_VULKAN

    /// Make OpenGL graphics API available.
    case FRB_ENABLE_GRAPHICS_OPENGL
}

/// Defines for available platform abstractions
let platformDefines: [SwiftSetting] = {
    var settings: [SwiftSetting] = []

    // FRB_PLATFORM_SDL
    if Env.get(bool: .FRB_ENABLE_PLATFORM_SDL, orElse: true) {
        settings.append(.define("FRB_PLATFORM_SDL"))
    }

    // FRB_PLATFORM_APPL
    let isApplePlatform: Bool
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        isApplePlatform = false /* disabled for now */
    #else
        isApplePlatform = false
    #endif
    if Env.get(bool: .FRB_ENABLE_PLATFORM_APPL, orElse: isApplePlatform) {
        settings.append(.define("FRB_PLATFORM_APPL"))
        #if os(macOS)
            settings.append(.define("FRB_PLATFORM_APPL_MACOS"))
        #elseif os(iOS) || os(tvOS)
            settings.append(.define("FRB_PLATFORM_APPL_IOS"))
        #endif
    }

    return settings
}()

/// Defines for available rendering APIs
let renderingAPIDefines: [SwiftSetting] = {
    var swiftSettings: [SwiftSetting] = []

    // FRB_GRAPHICS_METAL
    let isMetalDefaultEnabled: Bool
    #if canImport(Metal)
        isMetalDefaultEnabled = true
    #else
        isMetalDefaultEnabled = false
    #endif
    if Env.get(bool: .FRB_ENABLE_GRAPHICS_METAL, orElse: isMetalDefaultEnabled) {
        swiftSettings.append(.define("FRB_GRAPHICS_METAL"))
    }

    // FRB_GRAPHICS_VULKAN
    let isVulkanDefaultEnabled: Bool
    #if os(Linux) || os(macOS)
        isVulkanDefaultEnabled = true
    #else
        isVulkanDefaultEnabled = false
    #endif
    if Env.get(bool: .FRB_ENABLE_GRAPHICS_VULKAN, orElse: isVulkanDefaultEnabled) {
        swiftSettings.append(.define("FRB_GRAPHICS_VULKAN"))
    }

    // FRB_GRAPHICS_OPENGL
    let isOpenGLDefaultEnabled: Bool = true
    if Env.get(bool: .FRB_ENABLE_GRAPHICS_OPENGL, orElse: isOpenGLDefaultEnabled) {
        swiftSettings.append(.define("FRB_GRAPHICS_OPENGL"))
    }

    return swiftSettings
}()

let swiftSettings: [SwiftSetting] = renderingAPIDefines + platformDefines

let package = Package(
    name: "FirebladePAL",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "FirebladePAL",
            type: .static,
            targets: ["FirebladePAL"]
        ),
        .executable(
            name: "CPUBackendDemoApp",
            targets: ["CPUBackendDemoApp"]
        ),
        .executable(
            name: "VulkanBackendDemoApp",
            targets: ["VulkanBackendDemoApp"]
        ),
    ],
    dependencies: [
        .firebladeMath,
        .firebladeTime,
        .vulkan,
        .sdl2,
        .nfd,
    ],
    targets: [
        .target(
            name: "FirebladePAL",
            dependencies: [
                .firebladeMath,
                .firebladeTime,
                .sdl2,
                .vulkan,
                .nfd,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "CPUBackendDemoApp",
            dependencies: ["FirebladePAL"]
        ),
        .target(
            name: "VulkanBackendDemoApp",
            dependencies: ["FirebladePAL", .vulkan],
            swiftSettings: swiftSettings
        ),
        .testTarget(name: "FirebladePALTests",
                    dependencies: ["FirebladePAL"]),
    ]
)

extension Package.Dependency {
    static let firebladeMath = Package.Dependency.package(name: "FirebladeMath", url: "https://github.com/fireblade-engine/math.git", from: "0.11.0")
    static let firebladeTime = Package.Dependency.package(name: "FirebladeTime", url: "https://github.com/fireblade-engine/time.git", from: "0.2.0")
    static let sdl2 = Package.Dependency.package(name: "SDL2", url: "https://github.com/ctreffs/SwiftSDL2.git", from: "1.3.1")
    static let vulkan = Package.Dependency.package(name: "Vulkan", url: "https://github.com/ctreffs/SwiftVulkan", from: "0.1.2")
    static let nfd = Package.Dependency.package(name: "SwiftNFD", url: "https://github.com/ctreffs/SwiftNFD.git", from: "1.0.1")
}

extension Target.Dependency {
    static let firebladeTime = byName(name: "FirebladeTime")
    static let firebladeMath = product(name: "FirebladeMath", package: "FirebladeMath")
    static let sdl2 = product(name: "SDL2", package: "SDL2")
    static let vulkan = product(name: "Vulkan", package: "Vulkan")
    static let nfd = product(name: "NFD", package: "SwiftNFD")
}

extension Env {
    /// Set environment variable.
    /// - Parameters:
    ///   - varName: Env variable name
    ///   - value: Value to set variable to
    ///   - override: Override existing variable, true/false.
    /// - Returns: True if set, false otherwise.
    @discardableResult
    static func set<S>(variable varName: Env, to value: S, override: Bool = true) -> Bool where S: CustomStringConvertible {
        setenv(varName.rawValue, value.description, override ? 1 : 0) == 0
    }

    /// Get environment variable as string if present.
    /// - Parameter varName: Env variable name
    /// - Returns: The value if present.
    static func get(string varName: Env) -> String? {
        guard let cEnvVarPtr = getenv(varName.rawValue) else {
            return nil
        }
        return String(cString: cEnvVarPtr, encoding: .utf8)
    }

    /// Get environment variable as string or return default value.
    /// - Parameters:
    ///   - varName: Env variable name
    ///   - defaultValue: Default value to be returned if variable is not set.
    /// - Returns: The value or defaultValue if not present.
    static func get(string varName: Env, orElse defaultValue: String) -> String {
        get(string: varName) ?? defaultValue
    }

    /// Get environment variable as boolean if present.
    /// - Parameter varName: Env variable name
    /// - Returns: true/false or nil if not present
    static func get(bool varName: Env) -> Bool? {
        Bool(string: get(string: varName))
    }

    /// Get environment variable as boolean or return default value.
    /// - Parameters:
    ///   - varName: Env variable name
    ///   - defaultValue: Default value to be returned if variable is not set.
    /// - Returns: Boolean value.
    static func get(bool varName: Env, orElse defaultValue: Bool) -> Bool {
        Bool(string: get(string: varName)) ?? defaultValue
    }

    /// Clear environment variable
    /// - Parameter varName: Env variable name
    /// - Returns: True if cleared; false otherwise
    @discardableResult
    static func clear(variable varName: Env) -> Bool {
        unsetenv(varName.rawValue) == 0
    }

    /// Convenience to dump the current state of set environment variables.
    static func dump() {
        let output = Env
            .allCases
            .compactMap {
                guard let value = get(string: $0) else {
                    return nil
                }
                return "\($0.rawValue)=\(value)"
            }
            .sorted()
            .joined(separator: "\n")
        Swift.dump(output)
    }
}

public extension Bool {
    /// Initialize boolean from string representations.
    /// - Parameter value: "true" or "1" result in `true`; "false" or "0" result in `false`.
    ///                    All other values return `nil`.
    init?(string value: String?) {
        switch value?.lowercased() {
        case "true",
             "1":
            self = true
        case "false",
             "0":
            self = false
        default:
            return nil
        }
    }
}
