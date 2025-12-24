import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("🔍 [DEBUG] SceneDelegate: willConnectTo session starting")
        guard let windowScene = (scene as? UIWindowScene) else { 
            print("🔍 [DEBUG] SceneDelegate: Failed to get UIWindowScene")
            return 
        }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.backgroundColor = .systemBackground
        print("🔍 [DEBUG] SceneDelegate: Setting rootViewController to MainTabBarController")
        window.rootViewController = MainTabBarController()
        print("🔍 [DEBUG] SceneDelegate: making window key and visible")
        window.makeKeyAndVisible()
        print("🔍 [DEBUG] SceneDelegate: willConnectTo session finished")
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.saveContext()
    }
}
