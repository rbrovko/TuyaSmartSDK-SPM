// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TuyaSmartSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TuyaSmartActivatorKit-SMP",
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
        .binaryTarget(
            name: "TuyaSmartActivatorKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartActivatorKit.xcframework.zip",
            checksum: "0a51b159c7501abc5f25baca358d462fe0a7bbc4c3a18384e387e827e1db2abd"
        ),
        .binaryTarget(
            name: "TuyaSmartBaseKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartBaseKit.xcframework.zip",
            checksum: "f45124bc8cd05647c5ac74d7914736e85c1ac47e7a56d773da46eaf03cb822fb"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartDeviceKit.xcframework.zip",
            checksum: "a6828d1ef04912d1cd14b1d7e0111fa61a536d32fb438c7e76265a0ef8f72a5a"
        ),
        .binaryTarget(
            name: "TuyaSmartActivatorCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartActivatorCoreKit.xcframework.zip",
            checksum: "f57b88e98f5b8d14dfd650642f3cb21e145dac49749e9e974975073def59e1f0"
        ),
        .binaryTarget(
            name: "TuyaSmartDeviceCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartDeviceCoreKit.xcframework.zip",
            checksum: "81e299af49ef08dd1e0f4ddcd4cf6a274050533ee0670ec89e6c0615138c745a"
        ),
        .binaryTarget(
            name: "TuyaSmartMQTTChannelKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartMQTTChannelKit.xcframework.zip",
            checksum: "f6a60985d7f7466d2bf7e9dc305e4749820105c41513711c1ab88996ba91db36"
        ),
        .binaryTarget(
            name: "TuyaSmartNetworkKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartNetworkKit.xcframework.zip",
            checksum: "c6f2aba0033aac1b12bdc85a053792f1bfd45f901489789bcb02a5defbe0b978"
        ),
        .binaryTarget(
            name: "TuyaSmartPairingCoreKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartPairingCoreKit.xcframework.zip",
            checksum: "01054e81bef5170975bec70b33083ddf77b39eb46ff5c36f18ebe092bf45ea0c"
        ),
        .binaryTarget(
            name: "TuyaSmartQUIC",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartQUIC.xcframework.zip",
            checksum: "9a546c3ab395ec39ae35e411acd61b4c8b8ad67b6f0b19ecf53fcb41510c4ed2"
        ),
        .binaryTarget(
            name: "TuyaSmartShareKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartShareKit.xcframework.zip",
            checksum: "d4c29b219fe1d3c34f33d4f58512934c58afd294f17ae80bb303c690530e25ad"
        ),
        .binaryTarget(
            name: "TuyaSmartSocketChannelKit",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartSocketChannelKit.xcframework.zip",
            checksum: "6be283ba20c38f747359c7659ce4c0b9a2e956214fdb0c220412a1f3e6dd891e"
        ),
        .binaryTarget(
            name: "TuyaSmartUtil",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TuyaSmartUtil.xcframework.zip",
            checksum: "1afa958c9ac92adf279195ec29d6111d768f11d0c85ac59cbbe2ee12eeadf8ec"
        ),
        .binaryTarget(
            name: "TYMbedtls",
            url: "https://github.com/rbrovko/TuyaSmartSDK-SPM/releases/download/4.0.0/TYMbedtls.xcframework.zip",
            checksum: "53b11d11a770eb33481ccd77af9711e67d5765c4d6f34cc7281a64a0fa753562"
        )
    ]
)
