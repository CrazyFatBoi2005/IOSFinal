import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    private let tableView = UITableView()
    private let summaryHeaderView = UIView()
    private let balanceLabel = UILabel()
    private let incomeLabel = UILabel()
    private let expenseLabel = UILabel()
    
    private var transactions: [Transaction] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Категории", style: .plain, target: self, action: #selector(self.didTapCategories))
    }
    
    @objc private func didTapCategories() {
        let alert = UIAlertController(title: "Новая категория", message: "Введите название расхода", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Название (Напр: Еда)" }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                _ = PersistenceManager.shared.createCategory(name: name, iconName: "tag", hexColor: "#FF9500", type: "Expense")
            }
        })
        present(alert, animated: true)
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
        summaryHeaderView.layer.cornerRadius = 16
        summaryHeaderView.clipsToBounds = true
        
        balanceLabel.text = "Баланс: 0 ₸"
        balanceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        balanceLabel.textAlignment = .center
        
        incomeLabel.text = "Доход: 0 ₸"
        incomeLabel.textColor = .systemGreen
        incomeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        expenseLabel.text = "Расход: 0 ₸"
        expenseLabel.textColor = .systemRed
        expenseLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let statsStack = UIStackView(arrangedSubviews: [incomeLabel, expenseLabel])
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.spacing = 20
        
        let mainStack = UIStackView(arrangedSubviews: [balanceLabel, statsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        summaryHeaderView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: summaryHeaderView.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: summaryHeaderView.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: summaryHeaderView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: summaryHeaderView.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadData() {
        transactions = PersistenceManager.shared.fetchTransactions(for: 0, year: 0).sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        updateSummary()
        tableView.reloadData()
    }
    
    private func updateSummary() {
        let totalIncome = transactions.filter { $0.type.lowercased() == "income" }.reduce(0) { $0 + $1.amount }
        let totalExpense = transactions.filter { $0.type.lowercased() == "expense" }.reduce(0) { $0 + $1.amount }
        let balance = totalIncome - totalExpense
        
        balanceLabel.text = "Общий баланс: \(Int(balance)) ₸"
        incomeLabel.text = "↑ Доход: \(Int(totalIncome)) ₸"
        expenseLabel.text = "↓ Расход: \(Int(totalExpense)) ₸"
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
