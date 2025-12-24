import UIKit

class TransactionCell: UITableViewCell {
    
    private let categoryIcon = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        categoryIcon.font = .systemFont(ofSize: 30)
        categoryIcon.text = "💰"
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel
        
        amountLabel.font = .systemFont(ofSize: 17, weight: .bold)
        amountLabel.textAlignment = .right
        
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 2
        
        let mainStack = UIStackView(arrangedSubviews: [categoryIcon, labelsStack, amountLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            categoryIcon.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with transaction: Transaction) {
        titleLabel.text = transaction.category?.name ?? "Без категории"
        amountLabel.text = "\(transaction.amount) ₸"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateLabel.text = formatter.string(from: transaction.date)
        
        if transaction.category?.type?.lowercased() == "expense" {
            amountLabel.textColor = .systemRed
        } else {
            amountLabel.textColor = .systemGreen
        }
    }
}
