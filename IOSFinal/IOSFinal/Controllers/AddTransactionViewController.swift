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
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Новая запись"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        
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
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        stack.addArrangedSubview(UILabel().then { $0.text = "Сумма:" })
        stack.addArrangedSubview(amountField)
        stack.addArrangedSubview(UILabel().then { $0.text = "Дата:" })
        stack.addArrangedSubview(datePicker)
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
        dismiss(animated: true)
    }
}

extension UIView {
    func then(_ block: (UIView) -> Void) -> Self {
        block(self)
        return self
    }
}
