import UIKit

class AnalyticsViewController: UIViewController {
    
    private let segmentedControl = UISegmentedControl(items: ["Неделя", "Месяц", "Год"])
    private let historyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        let transactions = PersistenceManager.shared.fetchTransactions(for: 0, year: 0)
        let expenses = transactions.filter { $0.type.lowercased() == "expense" }
        
        var categoryTotals: [(name: String, amount: Double, color: String)] = []
        let categories = PersistenceManager.shared.fetchCategories().filter { $0.type == "Expense" }
        
        for cat in categories {
            let total = expenses.filter { $0.category?.name == cat.name }.reduce(0) { $0 + $1.amount }
            if total > 0 {
                categoryTotals.append((cat.name, total, cat.hexColor))
            }
        }
        
        // Сортируем по убыванию суммы
        categoryTotals.sort { $0.amount > $1.amount }
        
        // Очистка предыдущего графика
        chartContainer.subviews.filter { $0 != label }.forEach { $0.removeFromSuperview() }
        
        if categoryTotals.isEmpty {
            label.isHidden = false
            label.text = "Нет данных за выбранный период.\nДобавьте расходы, чтобы увидеть распределение трат."
        } else {
            label.isHidden = true
            setupSimpleBarChart(data: categoryTotals)
        }
    }
    
    // UI elements needs to be accessible
    private let chartContainer = UIView()
    private let label = UILabel()
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Аналитика"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        historyLabel.text = "Распределение трат"
        historyLabel.font = .systemFont(ofSize: 20, weight: .bold)
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyLabel)
        
        chartContainer.backgroundColor = .secondarySystemBackground
        chartContainer.layer.cornerRadius = 20
        chartContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartContainer)
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(label)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            historyLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            chartContainer.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 20),
            chartContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartContainer.heightAnchor.constraint(equalToConstant: 300),
            
            label.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: chartContainer.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSimpleBarChart(data: [(name: String, amount: Double, color: String)]) {
        let maxAmount = data.first?.amount ?? 1.0
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: chartContainer.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: -20)
        ])
        
        // Берем топ 5 для визуализации
        for item in data.prefix(5) {
            let row = UIStackView()
            row.axis = .vertical
            row.spacing = 4
            
            let nameLabel = UILabel()
            nameLabel.text = "\(item.name) (\(Int(item.amount)) ₸)"
            nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
            row.addArrangedSubview(nameLabel)
            
            let barBg = UIView()
            barBg.backgroundColor = .quaternarySystemFill
            barBg.layer.cornerRadius = 4
            barBg.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
            let bar = UIView()
            bar.backgroundColor = UIColor(hex: item.color) ?? .systemBlue
            bar.layer.cornerRadius = 4
            bar.translatesAutoresizingMaskIntoConstraints = false
            barBg.addSubview(bar)
            
            let percentage = CGFloat(item.amount / maxAmount)
            NSLayoutConstraint.activate([
                bar.leadingAnchor.constraint(equalTo: barBg.leadingAnchor),
                bar.topAnchor.constraint(equalTo: barBg.topAnchor),
                bar.bottomAnchor.constraint(equalTo: barBg.bottomAnchor),
                bar.widthAnchor.constraint(equalTo: barBg.widthAnchor, multiplier: percentage)
            ])
            
            row.addArrangedSubview(barBg)
            stack.addArrangedSubview(row)
        }
    }
    
    func updateAnalytics(sortType: SortType) {
    }
}

enum SortType {
    case transactionCount
    case totalAmount
}

extension UIColor {
    convenience init?(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        if cString.count != 6 { return nil }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
