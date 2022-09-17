//
//  DataStore.swift
//  Cartrack
//
//  Created by Aadil Majeed on 14/09/22.
//

import Foundation
import CoreData

class DataStore {
    static let sharedStore = DataStore()
    
    private init() {}
    
    func registeredAppUser() -> AppUser {
        let context = self.persistentContainer.viewContext
        guard let appUser = AppUser.fetchAppUser(user_name: "aadil_majeed", withManagedObjectContext: context) else {
            let user = AppUser(managedObjectContext: context)
            user.id = UUID().uuidString
            user.userName = "aadil_majeed"
            user.password = "car_track"
            user.country = "India"
            self.saveContext()
            return user
        }
        return appUser
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Cartrack")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func excuteFetchRequestForEntity<T: NSManagedObject>(entity: T.Type,
                                                         entityName: String,
                                          withIdentifier identifier: String,
                                          identifierName name: String,
                                          context:NSManagedObjectContext) -> [T]? {
        
        let fetchRequest:NSFetchRequest<T> = NSFetchRequest(entityName: entityName )
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        fetchRequest.entity = entityDescription
        
        let predicate: NSPredicate = NSPredicate(format: "(%K == %@)",name,identifier)
        fetchRequest.predicate = predicate
        
        do{
            let result = try context.fetch(fetchRequest)
            return result;
        }
        catch let error as NSError{
            print("Error = \(error.localizedDescription)")
            return nil
        }
    }

}
