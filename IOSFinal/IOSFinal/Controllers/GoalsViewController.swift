import UIKit

class GoalsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
    }
}

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
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
        let progress = Float(goal.currentAmount / goal.targetAmount)
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
