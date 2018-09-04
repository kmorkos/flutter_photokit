package land.crater.flutterphotokit

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterPhotokitPlugin(): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "flutter_photokit")
      channel.setMethodCallHandler(FlutterPhotokitPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result): Unit {
    result.notImplemented()
  }
}
