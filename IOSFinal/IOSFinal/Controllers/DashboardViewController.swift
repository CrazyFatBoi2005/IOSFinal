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
        // Настройка кнопки после появления экрана окончательно решает проблемы с констрейнтами в навигаторе
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
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
        transactions = PersistenceManager.shared.fetchTransactions(for: 0, year: 0).sorted { $0.date ?? Date() > $1.date ?? Date() }
        updateSummary()
        tableView.reloadData()
    }
    
    private func updateSummary() {
        let totalIncome = transactions.filter { $0.category?.type == "Income" }.reduce(0) { $0 + $1.amount }
        let totalExpense = transactions.filter { $0.category?.type == "Expense" }.reduce(0) { $0 + $1.amount }
        let balance = totalIncome - totalExpense
        
        balanceLabel.text = "Баланс: \(Int(balance)) ₸"
        incomeLabel.text = "Доход: \(Int(totalIncome)) ₸"
        expenseLabel.text = "Расход: \(Int(totalExpense)) ₸"
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
