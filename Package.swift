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
            targets: [
                "TuyaSmartActivatorCoreKitWrapper",
                "TuyaSmartActivatorKitWrapper",
                "TuyaSmartBaseKitWrapper",
                "TuyaSmartDeviceCoreKitWrapper",
                "TuyaSmartDeviceKitWrapper",
                "TuyaSmartMQTTChannelKitWrapper",
                "TuyaSmartNetworkKitWrapper",
                "TuyaSmartPairingCoreKitWrapper",
                "TuyaSmartQUICWrapper",
                "TuyaSmartShareKitWrapper",
                "TuyaSmartSocketChannelKitWrapper",
                "TuyaSmartUtilWrapper",
                "TYMbedtlsWrapper"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/rbrovko/YYModel-SPM.git", from: "1.0.4")
    ],
    targets: [
        .binaryTarget(
            name: "TuyaSmartActivatorCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartActivatorCoreKit.xcframework.zip",
            checksum: "0271b394dfe03a6d26a62a211951c93828113646ba2094a9cefff76edd669a10"
        ),
        .binaryTarget(
            name: "TuyaSmartActivatorKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartActivatorKit.xcframework.zip",
            checksum: "2497dcb5b77ae0fd6102b88b860bd1cce0ccfee2359602aa90657cd8e61652d1"
        ),
        .binaryTarget(
            name: "TuyaSmartBaseKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartBaseKit.xcframework.zip",
            checksum: "0c637744bcdc5e8c38d30e0d0c1aca84bee267833c06307580445ac0a3dd5dc8"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartDeviceCoreKit.xcframework.zip",
            checksum: "53fc380eab8be34f584507326df0877642102630ae0f86c5700b1dea5b50f13b"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartDeviceKit.xcframework.zip",
            checksum: "bf94077ae96d3e9b850e276dc80c568520b75ab3d6adbe2f00acb99d3f6adbda"
        ),
        .binaryTarget(
            name: "TuyaSmartMQTTChannelKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartMQTTChannelKit.xcframework.zip",
            checksum: "372873768c6818770438b086c5c781cc32bf6dd93577b25a89da1346369d6c4e"
        ),
        .binaryTarget(
            name: "TuyaSmartNetworkKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartNetworkKit.xcframework.zip",
            checksum: "2973cf5c0c2ffd39b84c10357d8eb4943e5189e1faaa6a0832d68d39489f9a3e"
        ),
        .binaryTarget(
            name: "TuyaSmartPairingCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartPairingCoreKit.xcframework.zip",
            checksum: "ff629c2a1636939dbbfedb3ee0b5e6eac402119aafb2198e50b91e471b8523c7"
        ),
        .binaryTarget(
            name: "TuyaSmartQUIC",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartQUIC.xcframework.zip",
            checksum: "7920f3d8b4e595abfbbfff12faffc5de0773b1263cead704587a8033d6bc9556"
        ),
        .binaryTarget(
            name: "TuyaSmartShareKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartShareKit.xcframework.zip",
            checksum: "84854b8d93d70d2ac8ccda7f0f9ad35d701cb00761761bad05bd4be94addc27a"
        ),
        .binaryTarget(
            name: "TuyaSmartSocketChannelKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartSocketChannelKit.xcframework.zip",
            checksum: "7c705bc4e74983da5d93e6d8f37aee90a362f99b12e7047c6bdc599ff0dd9cdc"
        ),
        .binaryTarget(
            name: "TuyaSmartUtil",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartUtil.xcframework.zip",
            checksum: "adbe737c7f8435392df395b1bd8c615ea941941cc56d667b49c8e3928a60dc03"
        ),
        .binaryTarget(
            name: "TYMbedtls",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TYMbedtls.xcframework.zip",
            checksum: "24ef58c27b2c37d2d6fc545a7788d4904283fde425aa0d380442b19a16560f28"
        ),
        .target(
            name: "TuyaSmartActivatorCoreKitWrapper",
            dependencies: [
                "TuyaSmartActivatorCoreKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartActivatorCoreKitWrapper"
        ),
        .target(
            name: "TuyaSmartActivatorKitWrapper",
            dependencies: [
                "TuyaSmartActivatorKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartActivatorKitWrapper"
        ),
        .target(
            name: "TuyaSmartBaseKitWrapper",
            dependencies: [
                "TuyaSmartBaseKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartBaseKitWrapper"
        ),
        .target(
            name: "TuyaSmartDeviceCoreKitWrapper",
            dependencies: [
                "TuyaSmartDeviceCoreKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartDeviceCoreKitWrapper"
        ),
        .target(
            name: "TuyaSmartDeviceKitWrapper",
            dependencies: [
                "TuyaSmartDeviceKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartDeviceKitWrapper"
        ),
        .target(
            name: "TuyaSmartMQTTChannelKitWrapper",
            dependencies: [
                "TuyaSmartMQTTChannelKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartMQTTChannelKitWrapper"
        ),
        .target(
            name: "TuyaSmartNetworkKitWrapper",
            dependencies: [
                "TuyaSmartNetworkKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartNetworkKitWrapper"
        ),
        .target(
            name: "TuyaSmartPairingCoreKitWrapper",
            dependencies: [
                "TuyaSmartPairingCoreKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartPairingCoreKitWrapper"
        ),
        .target(
            name: "TuyaSmartQUICWrapper",
            dependencies: [
                "TuyaSmartQUIC",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartQUICWrapper"
        ),
        .target(
            name: "TuyaSmartShareKitWrapper",
            dependencies: [
                "TuyaSmartShareKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartShareKitWrapper"
        ),
        .target(
            name: "TuyaSmartSocketChannelKitWrapper",
            dependencies: [
                "TuyaSmartSocketChannelKit",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartSocketChannelKitWrapper"
        ),
        .target(
            name: "TuyaSmartUtilWrapper",
            dependencies: [
                "TuyaSmartUtil",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TuyaSmartUtilWrapper"
        ),
        .target(
            name: "TYMbedtlsWrapper",
            dependencies: [
                "TYMbedtls",
                .product(name: "YYModel", package: "YYModel-SPM")
            ],
            path: "Sources/TYMbedtlsWrapper"
        )
    ]
)
