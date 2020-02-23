import Flutter
import UIKit

public class SwiftBatteryStateReaderPlugin:
NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  
  public static func register(
    with registrar: FlutterPluginRegistrar) {
    let methodChannel =
      FlutterMethodChannel(
        name: "battery_state_reader",
        binaryMessenger: registrar.messenger())
    let instance = SwiftBatteryStateReaderPlugin()
    registrar.addMethodCallDelegate(
      instance, channel: methodChannel)
    let eventChannel =
      FlutterEventChannel(
        name: "battery_state_reader_event_channel",
        binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)
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
  
  public func onListen(
    withArguments arguments: Any?,
    eventSink: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = eventSink
    sendBatteryStateEvent()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleBatteryStatusChange),
      name: UIDevice.batteryStateDidChangeNotification,
      object: nil)
    return nil
  }
  
  private func sendBatteryStateEvent() {
    guard let eventSink = eventSink else { return }
    eventSink(getBatteryStatus())
  }
  
  @objc func handleBatteryStatusChange() {
    sendBatteryStateEvent()
  }
  
  public func onCancel(
    withArguments arguments: Any?) -> FlutterError? {
    NotificationCenter.default.removeObserver(self)
    eventSink = nil
    return nil
  }
}
