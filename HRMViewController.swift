

import UIKit
import CoreBluetooth
let heartRateServiceCBUUID = CBUUID(string:"0x180D")


class HRMViewController: UIViewController {

  @IBOutlet weak var heartRateLabel: UILabel!
  @IBOutlet weak var bodySensorLocationLabel: UILabel!
  
  //Create CBCentralManager
  var centralManager:CBCentralManager!
  
  //heartRatePeripheral instance variable of type CBPeripheral
  var heartRatePeripheral: CBPeripheral!

  override func viewDidLoad() {
    //Initialize new variable
    centralManager = CBCentralManager(delegate: self, queue: nil)
    
    
    super.viewDidLoad()

    // Make the digits monospaces to avoid shifting when the numbers change
    heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
  }

  func onHeartRateReceived(_ heartRate: Int) {
    heartRateLabel.text = String(heartRate)
    print("BPM: \(heartRate)")
  }
}

extension HRMViewController: CBCentralManagerDelegate{
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state{
      
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
      centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
      
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print(peripheral)
    heartRatePeripheral = peripheral
    heartRatePeripheral.delegate = self
    
    centralManager.stopScan()
    centralManager.connect(heartRatePeripheral)
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected!")
    heartRatePeripheral.discoverServices(nil)
    
  }
  
  
}


/// Conform to CBPeripheralDelegate

extension HRMViewController: CBPeripheralDelegate{
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    //peripheral object has a property which gives you a list of services
    guard let services = peripheral.services else {return}
    
    for service in services{
      print(service)
    }
  }
}
