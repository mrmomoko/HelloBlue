//
//  ViewController.swift
//  HelloBlue
//
//  Created by Momoko Saunders on 2/3/17.
//  Copyright © 2017 Momoko Saunders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bluetoothManager = BluetoothManager()

    @IBAction func scanButtonTapped(_ sender: Any) {
        bluetoothManager.scanForPeripherals()
    }
 
    @IBAction func toggleLEDButtonTapped(_ sender: Any) {
        bluetoothManager.toggleLED()
    }
}

