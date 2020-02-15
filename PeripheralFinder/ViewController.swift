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
    var miBand4Peripheral: CBPeripheral!
    
    // Services CBUUID
    let batteryServiceCBUUID = CBUUID(string: "0x180F") // Battery
    let bloodPressureServiceCBUUID = CBUUID(string: "0x1810") // Blood Presure
    let miBand4ServiceCBUUID = CBUUID(string: "0xFEE0") // MI Band 4
    let heartRateServiceCBUUID = CBUUID(string: "0x180D") // Heart Rate
    let currentTimeServiceCBUUID = CBUUID(string: "0x1805") // Curret Time Service
    let deviceInfoServiceCBUUID = CBUUID(string: "0x180A") // Device Information
    let userDataServiceCBUUID = CBUUID(string:"0x181C") // User Data
    let immediateAlertServiceCBUUID = CBUUID(string: "0x1802") // Immediate Alert
    let alertNotificationServiceCBUUID = CBUUID(string: "0x1811") // Alert Notification Service
    
    // Characteristics CBUUID
    let hearRateMeasurementCharCBUUID = CBUUID(string: "0x2A37") // Heart Rate Measurement
    let heartRateControlPointCharCBUUID = CBUUID(string: "0x2A39") // Heart Rate Control Point
    let bodySensorLocationCharCBUUID = CBUUID(string: "2A38") // Body Senson Loacation
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Called viewDidLoad")
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        
    }
}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Bluetooth State is .unknown")
        case .resetting:
            print("Bluetooth State is .resetting")
        case .unsupported:
            print("Bluetooth State is .unsupported")
        case .unauthorized:
            print("Bluetooth Stateis .unauthorized")
        case .poweredOff:
            print("Bluetooth State is .poweredOff")
        case .poweredOn:
            print("Bluetooth State is .poweredOn")
            
//            centralManager.scanForPeripherals(withServices: nil)
            centralManager.scanForPeripherals(withServices: [batteryServiceCBUUID, bloodPressureServiceCBUUID, miBand4ServiceCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered: \(peripheral)!")
        
        miBand4Peripheral = peripheral
        miBand4Peripheral.delegate = self
        
        centralManager.stopScan()
        centralManager.connect(miBand4Peripheral)
//        print("advertisementData: \(advertisementData)!")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected \(peripheral)")
//        miBand4Peripheral.discoverServices(nil)
//        miBand4Peripheral.discoverServices([heartRateServiceCBUUID, deviceInfoServiceCBUUID ])
        miBand4Peripheral.discoverServices([heartRateServiceCBUUID])
        
    }
}


extension ViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for (index, service) in services.enumerated() {
            print("Service #\(index) of peripheral \(peripheral.name ?? "Unknown"): \(service)")
            miBand4Peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for (index, characteristic) in characteristics.enumerated() {
            print("Characteristic #\(index) of service \(service.uuid): \(characteristic)")
        
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
            }
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties container .write")
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
            }
            
            
        }
    }
    
}
