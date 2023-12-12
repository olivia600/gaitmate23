//
//  ContentView.swift
//  GaitMate
//
//  Created by Abe Nidhiry on 11/29/23.
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var loggedIn : Bool = false
    @Published var navigateNowToLogIn: Bool = false
    @Published var navigateNowToSignup: Bool = false
}

//class BluetoothViewModel: NSObject, ObservableObject, CBPeripheralDelegate{
//    private var centralManager: CBCentralManager?
//    var peripherals: [CBPeripheral] = []
//    private var selectedPeripheral: CBPeripheral? // ChatGPT addition
//
//    @Published var peripheralNames: [String] = []
//    @Published var receivedData: String = "" // ChatGPT addition
//
//    @Published var jointAngle: String = ""
//    @Published var acceleration: String = ""
//    @Published var gaitPhase: String = ""
//
//
//    override init() {
//        super.init()
//        self.centralManager = CBCentralManager(delegate: self, queue: .main)
//    }
//
//    func connect(to peripheral: CBPeripheral) { // ChatGPT addition
//            centralManager?.connect(peripheral, options: nil)
//            selectedPeripheral = peripheral
//    }
//}
//
//extension BluetoothViewModel:CBCentralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            self.centralManager?.scanForPeripherals(withServices: nil)
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if !peripherals.contains(peripheral) {
//            self.peripherals.append(peripheral)
//            self.peripheralNames.append(peripheral.name ?? "unnamed device")
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) { //ChatGPT addition
//            peripheral.delegate = self
//            peripheral.discoverServices(nil)
//        }
////}
//
////extension BluetoothViewModel: CBPeripheralDelegate {
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//
//        for service in services {
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//
//        for characteristic in characteristics {
//            // Check for the characteristic you want to communicate with
//            if characteristic.uuid == CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214") {
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//        }
//    }
//
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard let data = characteristic.value else { return }
//        let stringValue = String(data: data, encoding: .utf8) ?? ""
//
//        // Update UI based on the characteristic UUID
//        switch characteristic.uuid {
//        case CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214"):
//            // Joint Angle
//            jointAngle = stringValue
//            fallthrough
//        case CBUUID(string: "19B10002-E8F2-537E-4F6C-D104768A1214"):
//            // Acceleration
//            acceleration = stringValue
//            fallthrough
//        case CBUUID(string: "19B10003-E8F2-537E-4F6C-D104768A1214"): break
//            // Gait Phase
//        default:
//            break
//        }
//    }
//
//}
//
//
//struct ContentView: View {
//    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Joint Angle: \(bluetoothViewModel.jointAngle)")
//                Text("Acceleration: \(bluetoothViewModel.acceleration)")
//                Text("Gait Phase: \(bluetoothViewModel.gaitPhase)")
//
//                List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
//                    Button(action: {
//                        if let selectedPeripheral = bluetoothViewModel.peripherals.first(where: { $0.name == peripheral }) {
//                            bluetoothViewModel.connect(to: selectedPeripheral)
//                        }
//                    }) {
//                        Text(peripheral)
//                    }
//                }
//                .navigationTitle("Peripherals")
//
//                Text("Received Data: \(bluetoothViewModel.receivedData)")
//                    .padding()
//            }
//        }
//    }
//}
