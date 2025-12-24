import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    private let tableView = UITableView()
    private var expenses: [Transaction] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet.plus"), style: .plain, target: self, action: #selector(self.didTapAddCategory))
    }
    
    @objc private func didTapAddCategory() {
        let alert = UIAlertController(title: "Новая категория", message: "Введите название", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Название" }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                _ = PersistenceManager.shared.createCategory(name: name, iconName: "tag", hexColor: "#007AFF", type: "Expense")
            }
        })
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        let allTransactions = PersistenceManager.shared.fetchTransactions(for: 0, year: 0)
        expenses = allTransactions.filter { $0.category?.type == "Expense" }
        tableView.reloadData()
    }
    
    @objc private func didTapAdd() {
        let addVC = AddTransactionViewController()
        addVC.transactionType = "Expense"
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let expense = expenses[indexPath.row]
        cell.configure(with: expense)
        return cell
    }
}
