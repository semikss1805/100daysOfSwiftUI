//
//  WeatherForecastInteractor.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 09.02.2023.
//

import UIKit

protocol Interactor {
    var presenter: Presenter? { get set }
    
    func loadData() -> Void
}

final class WeatherForecastInteractor: Interactor {
    var presenter: Presenter?
    
    private typealias ConcurrencyTask = _Concurrency.Task
    
    private let weatherDataManager = WeatherDataManager()
    
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    func loadData() {
        updateData {
            DispatchQueue.main.async {
                self.fetchData()
            }
        }
    }
    
    func updateData(completion: @escaping () -> Void) {
        ConcurrencyTask {
            do {
                try await weatherDataManager.updateLocalData()
                
                presenter?.didCompleteLoading(isSucceed: true)
            } catch {
                presenter?.didCompleteLoading(isSucceed: false)
                debugPrint(error.localizedDescription)
            }
            
            completion()
        }
    }
    
    func fetchData() {
        do {
            try fetchDays()
            
            try fetchCurrentWeather()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func fetchDays() throws {
        let days = try managedObjectContext.fetch(Day.fetchRequest()).sorted(by: { $0.dayNumber < $1.dayNumber})
        presenter?.reloadData(days: days)
    }
    
    func fetchCurrentWeather() throws {
        let currentWeather = try managedObjectContext.fetch(CurrentWeather.fetchRequest())
        let weather = currentWeather.first?.weather ?? ""
        let weatherDescription = "\(currentWeather.last?.name ?? ""), \(currentWeather.last?.day ?? "")"
        
        presenter?.didCompleteFetch(weather: weather, weatherDescription: weatherDescription)
    }
}
