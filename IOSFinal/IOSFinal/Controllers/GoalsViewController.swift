import UIKit

class GoalsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAdd))
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GoalCell.self, forCellReuseIdentifier: "GoalCell")
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
        goals = PersistenceManager.shared.fetchGoals()
        tableView.reloadData()
    }
    
    @objc private func didTapAdd() {
        let categories = PersistenceManager.shared.fetchCategories().filter { $0.type == "Expense" }
        if categories.isEmpty {
            let alert = UIAlertController(title: "Нет категорий", message: "Сначала создайте категорию расходов на Дашборде", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "Новая цель", message: "Выберите категорию и введите сумму", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Целевая сумма" ; $0.keyboardType = .decimalPad }
        
        // Для простоты в алерте выберем первую доступную категорию или предложим выбор в будущем
        // В рамках этого тестового приложения просто создадим цель для первой категории расходов
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { _ in
            if let amountText = alert.textFields?.first?.text, let amount = Double(amountText) {
                PersistenceManager.shared.createGoal(targetAmount: amount, currentAmount: 0, month: 12, year: 2025, category: categories.first)
                self.loadData()
            }
        })
        present(alert, animated: true)
    }
}

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        cell.configure(with: goals[indexPath.row])
        return cell
    }
}

class GoalCell: UITableViewCell {
    private let categoryLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        categoryLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        amountLabel.font = .systemFont(ofSize: 14)
        amountLabel.textColor = .secondaryLabel
        progressView.tintColor = .systemBlue
        
        let stack = UIStackView(arrangedSubviews: [categoryLabel, progressView, amountLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with goal: Goal) {
        categoryLabel.text = goal.category?.name ?? "Категория"
        let progress: Float
        if goal.targetAmount > 0 {
            progress = Float(goal.currentAmount / goal.targetAmount)
        } else {
            progress = 0
        }
        progressView.setProgress(progress, animated: true)
        
        if progress > 1.0 {
            progressView.tintColor = .systemRed
        } else if progress > 0.8 {
            progressView.tintColor = .systemOrange
        } else {
            progressView.tintColor = .systemGreen
        }
        
        amountLabel.text = "\(goal.currentAmount) / \(goal.targetAmount) ₸"
    }
}
