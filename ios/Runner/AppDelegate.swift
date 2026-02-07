import UIKit
import Flutter
import WebKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    // 🔑 Enable camera for WKWebView
    let controller = WKWebViewConfiguration()
    controller.allowsInlineMediaPlayback = true

    if #available(iOS 10.0, *) {
      controller.mediaTypesRequiringUserActionForPlayback = []
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
