import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private var categories: [Category] = []
    private var transactions: [Transaction] = []
    private var goals: [Goal] = []
    
    private let categoriesFile = "categories.json"
    private let transactionsFile = "transactions.json"
    private let goalsFile = "goals.json"
    
    private init() {
        loadData()
        if categories.isEmpty {
            // Добавим несколько категорий по умолчанию только если список пуст
            categories = [
                Category(name: "Еда", iconName: "fork.knife", hexColor: "#FF9500", type: "Expense"),
                Category(name: "Транспорт", iconName: "car", hexColor: "#007AFF", type: "Expense"),
                Category(name: "Зарплата", iconName: "dollarsign.circle", hexColor: "#34C759", type: "Income")
            ]
            saveData()
        }
    }
    
    private func getFileURL(for fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    private func saveData() {
        let encoder = JSONEncoder()
        do {
            let catData = try encoder.encode(categories)
            try catData.write(to: getFileURL(for: categoriesFile))
            
            let transData = try encoder.encode(transactions)
            try transData.write(to: getFileURL(for: transactionsFile))
            
            let goalData = try encoder.encode(goals)
            try goalData.write(to: getFileURL(for: goalsFile))
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        do {
            let catUrl = getFileURL(for: categoriesFile)
            if FileManager.default.fileExists(atPath: catUrl.path) {
                let data = try Data(contentsOf: catUrl)
                categories = try decoder.decode([Category].self, from: data)
            }
            
            let transUrl = getFileURL(for: transactionsFile)
            if FileManager.default.fileExists(atPath: transUrl.path) {
                let data = try Data(contentsOf: transUrl)
                transactions = try decoder.decode([Transaction].self, from: data)
            }
            
            let goalUrl = getFileURL(for: goalsFile)
            if FileManager.default.fileExists(atPath: goalUrl.path) {
                let data = try Data(contentsOf: goalUrl)
                goals = try decoder.decode([Goal].self, from: data)
            }
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
    func createCategory(name: String, iconName: String, hexColor: String, type: String) -> Category {
        let category = Category(name: name, iconName: iconName, hexColor: hexColor, type: type)
        categories.append(category)
        saveData()
        return category
    }
    
    func fetchCategories() -> [Category] {
        return categories
    }
    
    func createTransaction(amount: Double, date: Date, note: String?, category: Category?, type: String) {
        let transaction = Transaction(amount: amount, date: date, note: note, type: type, category: category)
        transactions.append(transaction)
        saveData()
    }
    
    func fetchTransactions(for month: Int, year: Int) -> [Transaction] {
        return transactions.sorted { $0.date > $1.date }
    }
    
    func createGoal(targetAmount: Double, currentAmount: Double, month: Int16, year: Int16, category: Category?) {
        let goal = Goal(targetAmount: targetAmount, currentAmount: currentAmount, month: month, year: year, category: category)
        goals.append(goal)
        saveData()
    }
    
    func fetchGoals() -> [Goal] {
        return goals
    }
    
    func getExpensesForCategory(_ categoryName: String) -> Double {
        return transactions
            .filter { $0.type.lowercased() == "expense" && $0.category?.name == categoryName }
            .reduce(0) { $0 + $1.amount }
    }
}
