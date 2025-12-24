import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
        super.init()
        print("🔍 [DEBUG] AppDelegate: init() called")
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🔍 [DEBUG] AppDelegate: didFinishLaunchingWithOptions started")
        
        // Fallback for devices/configurations not using SceneDelegate
        if window == nil {
            print("🔍 [DEBUG] AppDelegate: SceneDelegate not detected, setting up window manually")
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .systemBackground
            window?.rootViewController = MainTabBarController()
            window?.makeKeyAndVisible()
        }
        
        print("🔍 [DEBUG] AppDelegate: didFinishLaunchingWithOptions finished")
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("🔍 [DEBUG] AppDelegate: configurationForConnecting called")
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        return config
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
