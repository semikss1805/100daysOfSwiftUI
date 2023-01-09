//
//  WeatherApp.swift
//  Weather
//
//  Created by SemikSS on 03.01.2023.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        
        let persistenceController = PersistenceController.shared
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}
