import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
    private var methodChannel: FlutterMethodChannel?

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        
        if let windowScene = scene as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController as? FlutterViewController {
            setupChannel(with: rootVC)
            
            if let url = connectionOptions.urlContexts.first?.url {
                handleIncomingURL(url)
            }
        }
    }

    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)
        if let url = URLContexts.first?.url {
            handleIncomingURL(url)
        }
    }

    private func setupChannel(with flutterVC: FlutterViewController) {
        methodChannel = FlutterMethodChannel(name: "com.craftlineinteractive.docview/open_with", binaryMessenger: flutterVC.binaryMessenger)
    }

    private func handleIncomingURL(_ url: URL) {
        methodChannel?.invokeMethod("onFileReceived", arguments: url.path)
    }
}

