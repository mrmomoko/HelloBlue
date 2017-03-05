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
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        bluetoothManager.scanForPeripherals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

