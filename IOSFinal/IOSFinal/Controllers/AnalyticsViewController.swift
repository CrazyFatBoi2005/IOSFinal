import UIKit
// import DGCharts // Note: User needs to add this package

class AnalyticsViewController: UIViewController {
    
    // private let pieChartView = PieChartView()
    private let segmentedControl = UISegmentedControl(items: ["Неделя", "Месяц", "Год"])
    private let historyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        historyLabel.text = "Статистика за Декабрь"
        historyLabel.font = .systemFont(ofSize: 18, weight: .medium)
        historyLabel.textAlignment = .center
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyLabel)
        
        // Placeholder for Chart
        let placeholderChart = UIView()
        placeholderChart.backgroundColor = .secondarySystemBackground
        placeholderChart.layer.cornerRadius = 12
        placeholderChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderChart)
        
        let label = UILabel()
        label.text = "Здесь будет график DGCharts\n(требуется установка пакета)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
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
            placeholderChart.heightAnchor.constraint(equalTo: placeholderChart.widthAnchor),
            
            label.centerXAnchor.constraint(equalTo: placeholderChart.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: placeholderChart.centerYAnchor)
        ])
    }
    
    // Logic for sorting and filtering based on segment
    func updateAnalytics(sortType: SortType) {
        // Fetch data and update chart
    }
}

enum SortType {
    case transactionCount
    case totalAmount
}
