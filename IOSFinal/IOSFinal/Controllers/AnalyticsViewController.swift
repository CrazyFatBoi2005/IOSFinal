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
        let totalIncome = transactions.filter { $0.type.lowercased() == "income" }.reduce(0) { $0 + $1.amount }
        let totalExpense = transactions.filter { $0.type.lowercased() == "expense" }.reduce(0) { $0 + $1.amount }
        
        // Поиск самой крупной категории расходов
        let expenses = transactions.filter { $0.type.lowercased() == "expense" }
        var categoryTotals: [String: Double] = [:]
        for tx in expenses {
            let catName = tx.category?.name ?? "Без категории"
            categoryTotals[catName, default: 0] += tx.amount
        }
        
        let topCategory = categoryTotals.max { $0.value < $1.value }
        
        if let top = topCategory {
            label.text = "Топ расходов: \(top.key)\n\(Int(top.value)) ₸\n\nВсего доходов: \(Int(totalIncome)) ₸\nВсего расходов: \(Int(totalExpense)) ₸"
        } else {
            label.text = "Нет данных для анализа.\nДобавьте расходы на вкладке 'Расходы'."
        }
    }
    
    // UI elements needs to be accessible
    private let label = UILabel()
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        historyLabel.text = "Статистика"
        historyLabel.font = .systemFont(ofSize: 18, weight: .medium)
        historyLabel.textAlignment = .center
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyLabel)
        
        let placeholderChart = UIView()
        placeholderChart.backgroundColor = .secondarySystemBackground
        placeholderChart.layer.cornerRadius = 12
        placeholderChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderChart)
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        placeholderChart.addSubview(label)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            historyLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            historyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderChart.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 20),
            placeholderChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeholderChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            placeholderChart.heightAnchor.constraint(equalToConstant: 250),
            
            label.centerXAnchor.constraint(equalTo: placeholderChart.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: placeholderChart.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: placeholderChart.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: placeholderChart.trailingAnchor, constant: -20)
        ])
    }
    
    func updateAnalytics(sortType: SortType) {
    }
}

enum SortType {
    case transactionCount
    case totalAmount
}
