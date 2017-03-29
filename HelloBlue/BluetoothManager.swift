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
    
    override init() {
        super.init()
        // Set self as the delegate of the CentralManager
        centralManager = CBCentralManager.init(delegate: self, queue: nil)
    }
    
    func scanForPeripherals() {
        print("Scan for Peripherals")
        if centralManager?.state == .poweredOn {
            // Pass nil here to scan for all peripherals. For power conservation, you could scan for only devices with a certain service UUID.
            // It's more fun in the demo to see all the devices.
            // You can set up options here to not allow duplicates
            // Or if you want to scan in the background, you set the service uuid you are scanning for here.
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func toggleLED() {
    }
    
    // MARK: Central Manager Delegate Methods
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Central Manager did Discover Peripheral: \(peripheral.name)")
        // In this example, we are looking for devices of a specific name, one could look for devices of a certain UUID, or other data which may be available in the advertisingData
        // Please look at the back of your device to find out it's name. 
        // You should check your log to see if you are discovering a device with the correct name
        if peripheral.name == "RigCom" {
        //if peripheral.name == "EvalDemo" {
            self.peripheral = peripheral
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CentralManager did Connect to Peripheral: : \(peripheral)")
        // Stop scanning after you connect to the device you are looking for
        central.stopScan()
        // Set self as the delegate of the peripheral
        peripheral.delegate = self
        // Start discovery of Services. As in scanning, one can limit discovery to specific services by passing in an array of the specific UUIDs.
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // Likely, you would send an alert to your user here.
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    
    // MARK: Peripheral Delegate Methods
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Peripheral did Discover Services: \(peripheral.services!) \n")
        // Once you have found services, you can elect to discover their characteristics
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Peripheral did Discover Characteristics: \(service.characteristics!) \n")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Peripheral did update value")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Peripheral did write value: \(characteristic.value)")
        if let error = error { print(error) }
    }
}

