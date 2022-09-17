//
//  User+CoreDataClass.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//
//

import Foundation
import CoreData


public class AppUser: NSManagedObject {
    static let entityName = "AppUser"
    @NSManaged public var id: String
    @NSManaged public var userName: String
    @NSManaged public var password: String
    @NSManaged public var country: String

    init(managedObjectContext: NSManagedObjectContext) {
        let ed = NSEntityDescription.entity(forEntityName: AppUser.entityName, in: managedObjectContext)!
        super.init(entity: ed, insertInto: managedObjectContext)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}

extension AppUser {
   
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: entityName)
    }

    class func fetchAppUser(user_name: String, withManagedObjectContext context: NSManagedObjectContext) -> AppUser? {
        if let user = DataStore.sharedStore.excuteFetchRequestForEntity(entity: AppUser.self, entityName: AppUser.entityName, withIdentifier: user_name, identifierName: "userName", context: context)?.first {
            return user
        }
        return nil
    }
    
    class func itemWithID(_ id: String, withManagedObjectContext context: NSManagedObjectContext) -> AppUser {
        if let user = DataStore.sharedStore.excuteFetchRequestForEntity(entity: AppUser.self, entityName: AppUser.entityName, withIdentifier: id, identifierName: "id", context: context)?.first {
            return user
        }
        
        let user = AppUser(managedObjectContext: context)
        user.id = id
        return user
    }
}
