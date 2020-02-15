//
//  ViewController.swift
//  PeripheralFinder
//
//  Created by Yousuf on 15/2/20.
//  Copyright © 2020 Yousuf. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    var otherPeripheral: CBPeripheral!
    
    let batteryServiceCBUUID = CBUUID(string: "0x180F")
    let bloodPressureServiceCBUUID = CBUUID(string: "0x1810")
    let miBrand4ServiceCBUUID = CBUUID(string: "0xFEE0") // MI Brand 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        
    }
}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            
//            centralManager.scanForPeripherals(withServices: nil)
            centralManager.scanForPeripherals(withServices: [batteryServiceCBUUID, bloodPressureServiceCBUUID, miBrand4ServiceCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered: \(peripheral)!")
        
        otherPeripheral = peripheral
        otherPeripheral.delegate = self
        
        centralManager.stopScan()
        centralManager.connect(otherPeripheral)
//        print("advertisementData: \(advertisementData)!")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected \(peripheral)")
        otherPeripheral.discoverServices(nil)
    }
}


extension ViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for (index, service) in services.enumerated() {
            print("Service #\(index): \(service)")
        }
    }
    
}
