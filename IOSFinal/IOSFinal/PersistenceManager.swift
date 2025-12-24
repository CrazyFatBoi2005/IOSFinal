import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private init() {}
    
    private var categories: [Category] = []
    private var transactions: [Transaction] = []
    private var goals: [Goal] = []
    
    private init() {
        // Добавим несколько категорий по умолчанию
        categories = [
            Category(name: "Еда", iconName: "fork.knife", hexColor: "#FF9500", type: "Expense"),
            Category(name: "Транспорт", iconName: "car", hexColor: "#007AFF", type: "Expense"),
            Category(name: "Зарплата", iconName: "dollarsign.circle", hexColor: "#34C759", type: "Income")
        ]
    }
    
    func createCategory(name: String, iconName: String, hexColor: String, type: String) -> Category {
        let category = Category(name: name, iconName: iconName, hexColor: hexColor, type: type)
        categories.append(category)
        return category
    }
    
    func fetchCategories() -> [Category] {
        return categories
    }
    
    func createTransaction(amount: Double, date: Date, note: String?, category: Category?, type: String) {
        let transaction = Transaction(amount: amount, date: date, note: note, type: type, category: category)
        transactions.append(transaction)
    }
    
    func fetchTransactions(for month: Int, year: Int) -> [Transaction] {
        // Для простоты возвращаем все в этом тестовом приложении
        return transactions.sorted { $0.date > $1.date }
    }
    
    func createGoal(targetAmount: Double, currentAmount: Double, month: Int16, year: Int16, category: Category?) {
        let goal = Goal(targetAmount: targetAmount, currentAmount: currentAmount, month: month, year: year, category: category)
        goals.append(goal)
    }
    
    func fetchGoals() -> [Goal] {
        return goals
    }
}
