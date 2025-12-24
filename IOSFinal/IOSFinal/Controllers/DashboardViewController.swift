import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    private let tableView = UITableView()
    private let summaryHeaderView = UIView()
    private let balanceLabel = UILabel()
    private let incomeLabel = UILabel()
    private let expenseLabel = UILabel()
    
    private var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Асинхронная загрузка данных, чтобы не блокировать Main Thread при запуске
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Отложенная настройка кнопок решает проблему с AutoLayout Constraints в навигаторе
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupHeader()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            summaryHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            summaryHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryHeaderView.heightAnchor.constraint(equalToConstant: 120),
            
            tableView.topAnchor.constraint(equalTo: summaryHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeader() {
        summaryHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryHeaderView)
        summaryHeaderView.backgroundColor = .secondarySystemBackground
        
        balanceLabel.text = "Баланс: 0 ₸"
        balanceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        incomeLabel.text = "Доход: 0 ₸"
        incomeLabel.textColor = .systemGreen
        
        expenseLabel.text = "Расход: 0 ₸"
        expenseLabel.textColor = .systemRed
        
        let stack = UIStackView(arrangedSubviews: [balanceLabel, incomeLabel, expenseLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        summaryHeaderView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: summaryHeaderView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: summaryHeaderView.centerYAnchor)
        ])
    }
    
    private func loadData() {
        updateSummary()
    }
    
    private func updateSummary() {
    }
    
    @objc private func didTapAdd() {
        let addVC = AddTransactionViewController()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
}
