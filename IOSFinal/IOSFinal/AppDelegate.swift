import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🔍 [DEBUG] AppDelegate: didFinishLaunchingWithOptions started")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        print("🔍 [DEBUG] AppDelegate: Window created with frame \(window?.frame ?? .zero)")
        window?.backgroundColor = .magenta // ОЧЕНЬ яркий цвет для теста
        
        let rootVC = MainTabBarController()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        print("🔍 [DEBUG] AppDelegate: window.isKeyWindow = \(window?.isKeyWindow ?? false)")
        print("🔍 [DEBUG] AppDelegate: didFinishLaunchingWithOptions finished")
        return true
    }
}
