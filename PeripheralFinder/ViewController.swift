//
//  ViewController.swift
//  PeripheralFinder
//
//  Created by Yousuf on 15/2/20.
//  Copyright © 2020 Yousuf. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var region: CLBeaconRegion!
    
    let uuid = "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
    let identifier = "PLACE_YOUR_IDENTIFIER_HERE"
    
    let colors = [
        12345: UIColor.red,
        33333: UIColor.green,
        44444: UIColor.blue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Called viewDidLoad")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuid)!, identifier: identifier)
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("All Beacons: \(beacons)")
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        
        print("Known Beacons: \(knownBeacons)")
        
        if(knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            self.view.backgroundColor = self.colors[Int(closestBeacon.minor)]
            
        }
        
    }
}

