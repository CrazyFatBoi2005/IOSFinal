import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let dashboard = createNav(with: "Траты", and: UIImage(systemName: "house"), vc: DashboardViewController())
        let analytics = createNav(with: "Аналитика", and: UIImage(systemName: "chart.pie"), vc: AnalyticsViewController())
        let goals = createNav(with: "Цели", and: UIImage(systemName: "target"), vc: GoalsViewController())
        
        self.setViewControllers([dashboard, analytics, goals], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        vc.title = title
        return nav
    }
}

// MARK: - Base View Controllers (Placeholders)
class DashboardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

class AnalyticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

class GoalsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
