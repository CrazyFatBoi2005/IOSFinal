import Foundation

class Category: Codable {
    var id: UUID
    var name: String
    var iconName: String
    var hexColor: String
    var type: String // "Income" or "Expense"
    
    init(id: UUID = UUID(), name: String, iconName: String, hexColor: String, type: String) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.hexColor = hexColor
        self.type = type
    }
}

class Transaction: Codable {
    var id: UUID
    var amount: Double
    var date: Date
    var note: String?
    var type: String // "Income" or "Expense"
    var category: Category?
    
    init(id: UUID = UUID(), amount: Double, date: Date = Date(), note: String?, type: String, category: Category?) {
        self.id = id
        self.amount = amount
        self.date = date
        self.note = note
        self.type = type
        self.category = category
    }
}

class Goal: Codable {
    var id: UUID
    var targetAmount: Double
    var currentAmount: Double
    var month: Int16
    var year: Int16
    var category: Category?
    
    init(id: UUID = UUID(), targetAmount: Double, currentAmount: Double, month: Int16, year: Int16, category: Category?) {
        self.id = id
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.month = month
        self.year = year
        self.category = category
    }
}
