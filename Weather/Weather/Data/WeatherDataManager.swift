//
//  WeatherDataManager.swift
//  Weather
//
//  Created by SemikSS on 13.01.2023.
//

import Foundation
import CoreData

final class WeatherDataManager {
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    private let openWeatherManager = OpenWeatherManager()
    
    enum DataError: Error {
        case CurrentWeatherFailed
        case WeatherForecastFailed
        case Unknown
    }
    
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
        
        contextSave(error: .CurrentWeatherFailed)
    }
    
    private func updateLocalWeatherForecast() async throws {
        let weatherForecast = try managedObjectContext.fetch(WeatherForecast.fetchRequest())
        
        let forecastResponse = try await openWeatherManager.getForecastResponse()
        
        for forecast in weatherForecast {
            managedObjectContext.delete(forecast)
            contextSave()
        }
        
        let responseArray = forecastResponse.list
        
        for index in  0..<responseArray.count {
            let date = Date(timeIntervalSince1970: TimeInterval(responseArray[index].dt))
            let day = date.formatted(.dateTime.weekday(.wide))
            let dayNumber = index
            //            debugPrint(day)
            //            debugPrint(dayNumber)
            
            let weatherForecastFromResponse = WeatherForecast(context: managedObjectContext)
            weatherForecastFromResponse.weather = responseArray[index].weather[0].main
            weatherForecastFromResponse.unixTime = Int64(truncatingIfNeeded: responseArray[index].dt)
            weatherForecastFromResponse.relatedDay = Day(context: managedObjectContext)
            weatherForecastFromResponse.relatedDay?.day = day
            weatherForecastFromResponse.relatedDay?.dayNumber = Int32(dayNumber)
            weatherForecastFromResponse.temp = responseArray[index].main.temp
            weatherForecastFromResponse.tempFeelsLike = responseArray[index].main.feels_like
            weatherForecastFromResponse.minTemp = responseArray[index].main.temp_min
            weatherForecastFromResponse.maxTemp = responseArray[index].main.temp_max
            
            contextSave(error: .WeatherForecastFailed)
        }
    }
    
    func updateLocalData() async throws {
        try await updateLocalCurrentWeather()
        try await updateLocalWeatherForecast()
    }
    
    private func contextSave(error: DataError = DataError.Unknown) {
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint(error)
        }
    }
}
