import SwiftUI
import CoreBluetooth


class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let peripheralName = peripheral.name, !peripheralNames.contains(peripheralName) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheralName)
        }
    }
}

struct BluetoothContentView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    @State private var showAlert = false
    @State private var selectedPeripheral: String = ""

    var body: some View {
        NavigationView {
            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
                Text(peripheral)
                    .onTapGesture {
                        selectedPeripheral = peripheral
                        showAlert = true
                    }
            }
            .navigationTitle("Bluetooth Devices")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Device Connected"),
                    message: Text("You are now connected to \(selectedPeripheral)"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct BluetoothViewModel_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothContentView()
    }
}
