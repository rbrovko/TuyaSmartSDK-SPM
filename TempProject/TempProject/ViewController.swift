//
//  ViewController.swift
//  TempProject
//
//  Created by Brovko Roman on 16.05.2026.
//

import UIKit
import TuyaSmartActivatorKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

@objc protocol TuyaSmartActivatorType {
    func startConfigWiFi(ssid: String,
                         password: String,
                         token: String)
    func stopConfigWiFi()
}

extension TuyaSmartActivator: TuyaSmartActivatorType {
    func startConfigWiFi(ssid: String, password: String, token: String) {
        startConfigWiFi(.EZ, ssid: ssid, password: password, token: token, timeout: 100)
    }
}
