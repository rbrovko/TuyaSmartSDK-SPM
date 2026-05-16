// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TuyaSmartSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TuyaSmartSDK",
            targets: [
                "TuyaSmartActivatorKit",
                "TuyaSmartBaseKit",
                "TuyaSmartDeviceKit",
                "TuyaSmartActivatorCoreKit",
                "TuyaSmartDeviceCoreKit",
                "TuyaSmartMQTTChannelKit",
                "TuyaSmartNetworkKit",
                "TuyaSmartPairingCoreKit",
                "TuyaSmartQUIC",
                "TuyaSmartShareKit",
                "TuyaSmartSocketChannelKit",
                "TuyaSmartUtil",
                "TYMbedtls"
            ]
        )
    ],
    targets: [
        // Main frameworks
        .binaryTarget(
            name: "TuyaSmartActivatorKit",
            path: "Frameworks/TuyaSmartActivatorKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartBaseKit",
            path: "Frameworks/TuyaSmartBaseKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceKit",
            path: "Frameworks/TuyaSmartDeviceKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartActivatorCoreKit",
            path: "Frameworks/TuyaSmartActivatorCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceCoreKit",
            path: "Frameworks/TuyaSmartDeviceCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartMQTTChannelKit",
            path: "Frameworks/TuyaSmartMQTTChannelKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartNetworkKit",
            path: "Frameworks/TuyaSmartNetworkKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartPairingCoreKit",
            path: "Frameworks/TuyaSmartPairingCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartQUIC",
            path: "Frameworks/TuyaSmartQUIC.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartShareKit",
            path: "Frameworks/TuyaSmartShareKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartSocketChannelKit",
            path: "Frameworks/TuyaSmartSocketChannelKit.xcframework"
        ),
        .binaryTarget(
            name: "TuyaSmartUtil",
            path: "Frameworks/TuyaSmartUtil.xcframework"
        ),
        .binaryTarget(
            name: "TYMbedtls",
            path: "Frameworks/TYMbedtls.xcframework"
        )
    ]
)
