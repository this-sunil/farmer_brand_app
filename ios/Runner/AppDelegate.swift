import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    private var channel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        // Initialize the channel
        channel = FlutterMethodChannel(
            name: "CheckoutProChannel",
            binaryMessenger: controller.binaryMessenger
        )

        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
