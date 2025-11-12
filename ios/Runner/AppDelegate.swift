import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        if let controller = window?.rootViewController as? FlutterViewController {
            let upiChannel = FlutterMethodChannel(name: "com.brand.farmer_brand/upi",
                                                  binaryMessenger: controller.binaryMessenger)
            upiChannel.setMethodCallHandler({ call, result in
                if call.method == "startTransaction" {
                    #if targetEnvironment(simulator)
                    result(FlutterError(code: "UNSUPPORTED", message: "UPI not supported on iOS Simulator", details: nil))
                    #else
                    if let args = call.arguments as? [String: Any],
                       let urlString = args["url"] as? String,
                       let url = URL(string: urlString),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:]) { success in
                            if success {
                                result("UPI app opened successfully")
                            } else {
                                result(FlutterError(code: "FAILED", message: "Failed to open UPI app", details: nil))
                            }
                        }
                    } else {
                        result(FlutterError(code: "FAILED", message: "Invalid or unsupported UPI URL", details: nil))
                    }
                    #endif
                } else {
                    result(FlutterMethodNotImplemented)
                }
            })
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

