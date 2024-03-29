//
//  Persistence.swift
//  Weather
//
//  Created by SemikSS on 09.01.2023.
//

import CoreData

enum ModelName: String {
    case weather = "WeatherModel"
    // ...
}

// read about dependency injection

// read about principles: DRY, YAGNI, KISS, SOLID

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    typealias ErrorCompletion = (Error?) -> ()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: ModelName.weather.rawValue)
        container.loadPersistentStores {(description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func save(completion: @escaping ErrorCompletion = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping ErrorCompletion = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
}
