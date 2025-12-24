import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    private let context = CoreDataStack.shared.context
    
    func createCategory(name: String, iconName: String, hexColor: String, type: String) -> Category {
        let category = Category(context: context)
        category.id = UUID()
        category.name = name
        category.iconName = iconName
        category.hexColor = hexColor
        category.type = type
        save()
        return category
    }
    
    func fetchCategories() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func fetchCategoriesSorted(by sortType: SortType) -> [Category] {
        let categories = fetchCategories()
        switch sortType {
        case .transactionCount:
            return categories.sorted { ($0.transactions?.count ?? 0) > ($1.transactions?.count ?? 0) }
        case .totalAmount:
            return categories.sorted { cat1, cat2 in
                let total1 = (cat1.transactions?.allObjects as? [Transaction])?.reduce(0) { $0 + $1.amount } ?? 0
                let total2 = (cat2.transactions?.allObjects as? [Transaction])?.reduce(0) { $0 + $1.amount } ?? 0
                return total1 > total2
            }
        }
    }
    
    func createTransaction(amount: Double, date: Date, note: String?, category: Category) {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = date
        transaction.note = note
        transaction.category = category
        save()
    }
    
    func fetchTransactions(for month: Int, year: Int) -> [Transaction] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    private func save() {
        CoreDataStack.shared.saveContext()
    }
}
