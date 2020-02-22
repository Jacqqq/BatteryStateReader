import Flutter
import UIKit

public class SwiftBatteryStateReaderPlugin:
NSObject, FlutterPlugin {
  
  public static func register(
    with registrar: FlutterPluginRegistrar) {
    let methodChannel =
      FlutterMethodChannel(
        name: "battery_state_reader",
        binaryMessenger: registrar.messenger())
    let instance = SwiftBatteryStateReaderPlugin()
    registrar.addMethodCallDelegate(
      instance, channel: methodChannel)
  }
  
public func handle(_ call: FlutterMethodCall,
                   result: @escaping FlutterResult) {
  switch call.method {
  case "getBatteryStatus":
    result(getBatteryStatus())
    break
  case "getBatteryPercentage":
    result(getBatteryLevel())
    break
  default:
    result(FlutterMethodNotImplemented)
    break
  }
}
  
func getMonitorableDevice() -> UIDevice{
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  return device
}
  
func getBatteryLevel() -> Int {
  var battteryLevel = getMonitorableDevice().batteryLevel
  if (battteryLevel > 0){
    battteryLevel = battteryLevel * 100
  }
  return Int(battteryLevel)
}

func getBatteryStatus() -> String{
  var state: String
  switch (getMonitorableDevice().batteryState) {
  case .full:
    state = "full"
    break
  case .charging:
    state = "charging"
    break
  case .unplugged:
    state = "discharging"
    break
  default: state = "unknown"
  }
  return state
}
  


  
  func setupListeners() {
    UIDevice.current.isBatteryMonitoringEnabled = true
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleBatteryLevelChange),
                                           name: UIDevice.batteryLevelDidChangeNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleBatteryLevelChange),
                                           name: UIDevice.batteryLevelDidChangeNotification,
                                           object: nil)
  }
  
  @objc func handleBatteryLevelChange() {
    print("Battery level: \(UIDevice.current.batteryLevel)")
  }
  
  @objc func handleBatteryStatusChange() {
    print("Battery level: \(UIDevice.current.batteryLevel)")
  }
}
