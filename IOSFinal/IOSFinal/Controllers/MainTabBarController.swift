import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let dashboard = createNav(with: "Дашборд", and: UIImage(systemName: "house"), vc: DashboardViewController())
        let incomes = createNav(with: "Доходы", and: UIImage(systemName: "arrow.down.circle"), vc: IncomesViewController())
        let expenses = createNav(with: "Расходы", and: UIImage(systemName: "arrow.up.circle"), vc: ExpensesViewController())
        let analytics = createNav(with: "Аналитика", and: UIImage(systemName: "chart.pie"), vc: AnalyticsViewController())
        let goals = createNav(with: "Цели", and: UIImage(systemName: "target"), vc: GoalsViewController())
        
        self.setViewControllers([dashboard, incomes, expenses, analytics, goals], animated: false)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        vc.title = title
        return nav
    }
}
