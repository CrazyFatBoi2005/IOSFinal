import UIKit

class AddTransactionViewController: UIViewController {
    
    private let amountField = UITextField()
    private let noteField = UITextField()
    private let categoryPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didTapCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didTapSave))
    }
    
    var transactionType: String = "Expense"
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didTapCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didTapSave))
    }
    
    private func loadCategories() {
        categories = PersistenceManager.shared.fetchCategories().filter { $0.type == transactionType }
        if categories.isEmpty {
            // Создание дефолтной категории если список пуст
            let defaultName = transactionType == "Income" ? "Прочее" : "Общее"
            let category = PersistenceManager.shared.createCategory(name: defaultName, iconName: "list.bullet", hexColor: "#808080", type: transactionType)
            categories = [category]
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = transactionType == "Income" ? "Новый доход" : "Новый расход"
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        amountField.placeholder = "Сумма"
        amountField.keyboardType = .decimalPad
        amountField.borderStyle = .roundedRect
        
        noteField.placeholder = "Комментарий (необязательно)"
        noteField.borderStyle = .roundedRect
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        stack.addArrangedSubview(UILabel().then { $0.text = "Сумма:" })
        stack.addArrangedSubview(amountField)
        stack.addArrangedSubview(UILabel().then { $0.text = "Категория:" })
        stack.addArrangedSubview(categoryPicker)
        stack.addArrangedSubview(noteField)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSave() {
        guard let amountText = amountField.text, let amount = Double(amountText) else { return }
        let category = categories[categoryPicker.selectedRow(inComponent: 0)]
        
        PersistenceManager.shared.createTransaction(
            amount: amount,
            date: Date(), // Всегда сегодня
            note: noteField.text,
            category: category
        )
        
        dismiss(animated: true)
    }
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
}

protocol Then {}
extension Then where Self: Any {
    @discardableResult
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}
extension NSObject: Then {}
