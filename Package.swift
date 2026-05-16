// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TuyaSmartSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TuyaSmartActivatorKit",
            targets: ["TuyaSmartActivatorKitWrapper"]
        )
    ],
    targets: [
        // Binary targets
        .binaryTarget(
            name: "TYMbedtlsBinary",
            path: "Frameworks/TYMbedtls.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartQUICBinary",
            path: "Frameworks/TuyaSmartQUIC.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartUtilBinary",
            path: "Frameworks/TuyaSmartUtil.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartSocketChannelKitBinary",
            path: "Frameworks/TuyaSmartSocketChannelKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartNetworkKitBinary",
            path: "Frameworks/TuyaSmartNetworkKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartMQTTChannelKitBinary",
            path: "Frameworks/TuyaSmartMQTTChannelKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartBaseKitBinary",
            path: "Frameworks/TuyaSmartBaseKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartPairingCoreKitBinary",
            path: "Frameworks/TuyaSmartPairingCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceCoreKitBinary",
            path: "Frameworks/TuyaSmartDeviceCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartShareKitBinary",
            path: "Frameworks/TuyaSmartShareKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceKitBinary",
            path: "Frameworks/TuyaSmartDeviceKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartActivatorCoreKitBinary",
            path: "Frameworks/TuyaSmartActivatorCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartActivatorKitBinary",
            path: "Frameworks/TuyaSmartActivatorKit.xcframework"
        ),
        
        // Wrapper targets with dependencies
        .target(
            name: "TYMbedtls",
            dependencies: ["TYMbedtlsBinary"],
            path: "Sources/TYMbedtls"
        ),
        .target(
            name: "TuyaSmartQUIC",
            dependencies: ["TuyaSmartQUICBinary"],
            path: "Sources/TuyaSmartQUIC"
        ),
        .target(
            name: "TuyaSmartUtil",
            dependencies: [
                "TuyaSmartUtilBinary",
                "TYMbedtls"
            ],
            path: "Sources/TuyaSmartUtil"
        ),
        .target(
            name: "TuyaSmartSocketChannelKit",
            dependencies: [
                "TuyaSmartSocketChannelKitBinary",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartSocketChannelKit"
        ),
        .target(
            name: "TuyaSmartNetworkKit",
            dependencies: [
                "TuyaSmartNetworkKitBinary",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartNetworkKit"
        ),
        .target(
            name: "TuyaSmartMQTTChannelKit",
            dependencies: [
                "TuyaSmartMQTTChannelKitBinary",
                "TuyaSmartQUIC",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartMQTTChannelKit"
        ),
        .target(
            name: "TuyaSmartBaseKit",
            dependencies: [
                "TuyaSmartBaseKitBinary",
                "TuyaSmartMQTTChannelKit",
                "TuyaSmartNetworkKit",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartBaseKit"
        ),
        .target(
            name: "TuyaSmartPairingCoreKit",
            dependencies: [
                "TuyaSmartPairingCoreKitBinary",
                "TuyaSmartMQTTChannelKit",
                "TuyaSmartSocketChannelKit",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartPairingCoreKit"
        ),
        .target(
            name: "TuyaSmartDeviceCoreKit",
            dependencies: [
                "TuyaSmartDeviceCoreKitBinary",
                "TuyaSmartBaseKit",
                "TuyaSmartMQTTChannelKit",
                "TuyaSmartSocketChannelKit",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartDeviceCoreKit"
        ),
        .target(
            name: "TuyaSmartShareKit",
            dependencies: [
                "TuyaSmartShareKitBinary",
                "TuyaSmartBaseKit",
                "TuyaSmartDeviceCoreKit"
            ],
            path: "Sources/TuyaSmartShareKit"
        ),
        .target(
            name: "TuyaSmartDeviceKit",
            dependencies: [
                "TuyaSmartDeviceKitBinary",
                "TuyaSmartBaseKit",
                "TuyaSmartDeviceCoreKit",
                "TuyaSmartNetworkKit",
                "TuyaSmartShareKit"
            ],
            path: "Sources/TuyaSmartDeviceKit"
        ),
        .target(
            name: "TuyaSmartActivatorCoreKit",
            dependencies: [
                "TuyaSmartActivatorCoreKitBinary",
                "TuyaSmartDeviceCoreKit",
                "TuyaSmartPairingCoreKit",
                "TuyaSmartUtil"
            ],
            path: "Sources/TuyaSmartActivatorCoreKit"
        ),
        .target(
            name: "TuyaSmartActivatorKitWrapper",
            dependencies: [
                "TuyaSmartActivatorKitBinary",
                "TuyaSmartActivatorCoreKit",
                "TuyaSmartDeviceKit"
            ],
            path: "Sources/TuyaSmartActivatorKit"
        )
    ]
)
