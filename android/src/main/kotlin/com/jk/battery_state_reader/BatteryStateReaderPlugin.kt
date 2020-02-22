package com.jk.battery_state_reader

import android.annotation.TargetApi
import android.content.Context
import android.content.Context.BATTERY_SERVICE
import android.os.BatteryManager
import android.os.BatteryManager.*
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

@TargetApi(Build.VERSION_CODES.O)
class BatteryStateReaderPlugin : FlutterPlugin, MethodCallHandler {
  private var applicationContext: Context? = null
  private var batteryManager: BatteryManager? = null
  private var methodChannel: MethodChannel? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
  }

  private fun onAttachedToEngine(
    applicationContext: Context,
    messenger: BinaryMessenger
  ) {
    this.applicationContext = applicationContext
    val service = applicationContext.getSystemService(BATTERY_SERVICE)
    batteryManager = service as BatteryManager
    methodChannel = MethodChannel(messenger, "battery_state_reader")
    methodChannel?.setMethodCallHandler(this)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      BatteryStateReaderPlugin().onAttachedToEngine(
        registrar.context(),
        registrar.messenger()
      )
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getBatteryPercentage" -> {
        result.success(getBatteryPercentage())
      }
      "getBatteryStatus" -> {
        result.success(getBatteryStatus())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

private fun getBatteryPercentage() =
  batteryManager?.getIntProperty(BATTERY_PROPERTY_CAPACITY)
    ?: -1

private fun getBatteryStatus() =
  when (
    batteryManager?.getIntProperty(BATTERY_PROPERTY_STATUS)) {
    BATTERY_STATUS_CHARGING -> "charging"
    BATTERY_STATUS_DISCHARGING -> "discharging"
    BATTERY_STATUS_FULL -> "full"
    else -> "unknown"
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = null
    batteryManager = null
    methodChannel?.setMethodCallHandler(null)
    methodChannel = null
  }
}