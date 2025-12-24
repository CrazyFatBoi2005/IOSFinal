import Foundation
import CoreData
import UIKit

@objc(Category)
public class Category: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var iconName: String
    @NSManaged public var hexColor: String
    @NSManaged public var type: String
    @NSManaged public var transactions: NSSet?
    @NSManaged public var goals: NSSet?
}

extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
}
