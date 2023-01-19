//
//  TestCoreDataStack.swift
//  WeatherTests
//
//  Created by SemikSS on 18.01.2023.
//

import CoreData
import Foundation
@testable import Weather

final class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "WeatherModel")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
