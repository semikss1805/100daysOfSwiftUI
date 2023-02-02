//
//  WeatherDataManager.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 31.01.2023.
//

import Foundation
import CoreData

extension Notification.Name {
    static let dataChanged = Notification.Name("dataChanged")
}

final class WeatherDataManager {
    
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    private let openWeatherManager = OpenWeatherManager()
    
    init() { }
    
    private func updateLocalCurrentWeather() async throws {
        let currentWeather = try managedObjectContext.fetch(CurrentWeather.fetchRequest())
        
        let currentResponse = try await openWeatherManager.getCurrentResponse()
        
        let date = Date(timeIntervalSince1970: TimeInterval(currentResponse.dt))
        let day = date.formatted(date: .complete, time: .shortened)
        
        if currentWeather.isEmpty {
            let currentWeatherFromResponse = CurrentWeather(context: managedObjectContext)
            currentWeatherFromResponse.weather = currentResponse.weather[0].main
            currentWeatherFromResponse.name = currentResponse.name
            currentWeatherFromResponse.day = day
            currentWeatherFromResponse.unixTime = Int64(truncatingIfNeeded: currentResponse.dt)
        } else {
            currentWeather[0].weather = currentResponse.weather[0].main
            currentWeather[0].name = currentResponse.name
            currentWeather[0].day = day
            currentWeather[0].unixTime = Int64(truncatingIfNeeded: currentResponse.dt)
        }
        
        contextSave()
    }
    
    private func updateLocalWeatherForecast() async throws {
        let forecastResponse = try await openWeatherManager.getForecastResponse()
        
        let responseArray = forecastResponse.list
        
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.clearLocalWeatherForecast()
            } catch {
                    debugPrint("clear failed")
            }
            
            for index in  0..<responseArray.count {
                let date = Date(timeIntervalSince1970: TimeInterval(responseArray[index].dt))
                let day = date.formatted(.dateTime.weekday(.wide))
                let dayNumber = index
                
                let weatherForecastFromResponse = WeatherForecast(context: self!.managedObjectContext)
                weatherForecastFromResponse.weather = responseArray[index].weather[0].main
                weatherForecastFromResponse.unixTime = Int64(truncatingIfNeeded: responseArray[index].dt)
                weatherForecastFromResponse.relatedDay = Day(context: self!.managedObjectContext)
                weatherForecastFromResponse.relatedDay.day = day
                weatherForecastFromResponse.relatedDay.dayNumber = Int64(dayNumber)
                weatherForecastFromResponse.temp = responseArray[index].main.temp
                weatherForecastFromResponse.tempFeelsLike = responseArray[index].main.feels_like
                weatherForecastFromResponse.minTemp = responseArray[index].main.temp_min
                weatherForecastFromResponse.maxTemp = responseArray[index].main.temp_max
            }
            
            self?.contextSave()
        }
        
        clearEmptyDays()
    }
    
    
    private func clearLocalWeatherForecast() throws {
        let weatherForecast = try managedObjectContext.fetch(WeatherForecast.fetchRequest())
        
        for weatherForecast in weatherForecast {
            managedObjectContext.delete(weatherForecast)
        }
    }
    
    private func postChanges() {
        NotificationCenter.default.post(name: .dataChanged, object: self)
    }
    
    private func clearEmptyDays() {
        do {
            let days = try managedObjectContext.fetch(Day.fetchRequest())
            
            for day in days {
                if day.weatherForecastArray.isEmpty {
                    managedObjectContext.delete(day)
                    contextSave()
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func contextSave() {
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("save failed")
        }
    }
    
    func updateLocalData() async throws {
        try await updateLocalCurrentWeather()
        try await updateLocalWeatherForecast()
        postChanges()
    }
}

