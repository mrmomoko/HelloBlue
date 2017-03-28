//
//  BluetoothManager.swift
//  HelloBlue
//
//  Created by Momoko Saunders on 2/3/17.
//  Copyright © 2017 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager : CBCentralManager?
    var peripheral : CBPeripheral?
    
    var ledCharacteristic : CBCharacteristic?
    
    var lightState = false
    let onCommand : UInt8 = 0x00
    let offCommand : UInt8 = 0x64
    
    override init() {
        super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil)
        scanForPeripherals()
    }
    
    func scanForPeripherals() {
        print("Scan for Peripherals")
        if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func toggleLED() {
        if lightState == true {
            print("Toggle Light Off")
            peripheral?.writeValue(Data.init(bytes: [offCommand]), for: ledCharacteristic!, type: .withResponse)
        } else {
            print("Toggle Light On")
            peripheral?.writeValue(Data.init(bytes: [onCommand]), for: ledCharacteristic!, type: .withResponse)
        }
        lightState = !lightState
    }
    
    // MARK: Central Manager Delegate Methods
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Central Manager did Discover Peripheral: \(peripheral.name)")
        if peripheral.name == "RB-Demo" {
            self.peripheral = peripheral
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CentralManager did Connect to Peripheral: : \(peripheral)")
        centralManager?.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    
    // MARK: Peripheral Delegate Methods
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Peripheral did Discover Services: \(peripheral.services!) \n")
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Peripheral did Discover Characteristics: \(service.characteristics!) \n")
        
        for char in service.characteristics! as [CBCharacteristic] {
            if char.uuid == CBUUID.init(string:"59db1525-428d-4190-9f89-ab7be9e22384") {
                ledCharacteristic = char
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Peripheral did update Value")
    }
    
}

