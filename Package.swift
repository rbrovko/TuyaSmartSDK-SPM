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
            targets: ["TuyaSmartActivatorKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "TuyaSmartActivatorKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartActivatorKit.xcframework.zip",
            checksum: "9881225ec96b6e5e770550cc521ac146bf4c392ce027b7e0a2cc6604b47a92ea"
        ),
        .binaryTarget(
            name: "TuyaSmartBaseKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartBaseKit.xcframework.zip",
            checksum: "8c3242e798d9ac7e65a7ce508dda5c3acac61dc6e057f73576309d0902b749e7"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartDeviceKit.xcframework.zip",
            checksum: "9ccea2fd14c467f9930ca4b4fc77b78e7513e5e0a6c984771a4021239cfacaf5"
        ),
        .binaryTarget(
            name: "TuyaSmartActivatorCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartActivatorCoreKit.xcframework.zip",
            checksum: "3244e9bb61b67d8a526e4a58f6ab100dd09b07de9f04cce84d0438a9fea81aab"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartDeviceCoreKit.xcframework.zip",
            checksum: "dd50b03dc4ef41676e32c26ec8db69c175c06a7f18918a2936516ac3b89dd60a"
        ),
        .binaryTarget(
            name: "TuyaSmartMQTTChannelKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartMQTTChannelKit.xcframework.zip",
            checksum: "b50293fab1ba83153e4dfdf10ef7a231ca0605669b306890d947d566311576de"
        ),
        .binaryTarget(
            name: "TuyaSmartNetworkKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartNetworkKit.xcframework.zip",
            checksum: "767e57d9786e8d925308b5fa1512c89d6f2db53b733a26f0801d681ea5bead44"
        ),
        .binaryTarget(
            name: "TuyaSmartPairingCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartPairingCoreKit.xcframework.zip",
            checksum: "27c6f7f6d69ef3f41b4c84dba36dddf8a3104ec1f5b2ca0b0688f29ea3a1d1bc"
        ),
        .binaryTarget(
            name: "TuyaSmartQUIC",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartQUIC.xcframework.zip",
            checksum: "ec0a3853d1946f774f2664a455bc4bbdcafffd1805552805a225bcb13b0655cc"
        ),
        .binaryTarget(
            name: "TuyaSmartShareKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartShareKit.xcframework.zip",
            checksum: "d63133a6ca00a3d6e23d256be52946d92c7fa6036657e3dce708ac711707f4d9"
        ),
        .binaryTarget(
            name: "TuyaSmartSocketChannelKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartSocketChannelKit.xcframework.zip",
            checksum: "339ced555cce8cfcdcd112c6506db4041096926fb8d89f8fb88b0995f1fb8816"
        ),
        .binaryTarget(
            name: "TuyaSmartUtil",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartUtil.xcframework.zip",
            checksum: "f3f5e7a9fb330b1a8c13a8b4579ebceab39ac410e20423175705d145ab819e21"
        ),
        .binaryTarget(
            name: "TYMbedtls",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TYMbedtls.xcframework.zip",
            checksum: "c83934555ab2779b17a7124836f6d91405632bcacb8c3d6443afaf8338a0e240"
        )
    ]
)
