import Foundation
import CoreData

public class Transaction: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var type: String
    @NSManaged public var category: Category?
}

extension Transaction {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }
}
