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
    
    init() { }
    
    func saveCurrentWeather(currentResponse: OpenWeatherManager.CurrentResponse) {
        guard let currentWeather = try? managedObjectContext.fetch(CurrentWeather.fetchRequest())
        else {
            debugPrint("Fetch failed")
            return
        }
        
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

        contextSave(errorMessage: "saveCurrentWeather failed")
        
        for weather in currentWeather {
            debugPrint(weather)
        }
        debugPrint(currentWeather.count)
    }

    func saveWeatherForecast(forecastResponse: OpenWeatherManager.ForecastResponse) {
        guard let weatherForecast = try? managedObjectContext.fetch(WeatherForecast.fetchRequest())
        else {
            debugPrint("Fetch failed")
            return
        }
        
        var fiveForecastResponse = [forecastResponse.list[7]]
        for i in 2...5 {
            fiveForecastResponse.append(forecastResponse.list[(8 * i) - 1])
        }
        debugPrint(fiveForecastResponse.count)

        for index in 0..<5 {
            let date = Date(timeIntervalSince1970: TimeInterval(fiveForecastResponse[index].dt))
            let day = date.formatted(.dateTime.weekday(.wide))
            debugPrint(day)

            if weatherForecast.count == 5 {
                weatherForecast[index].weather = fiveForecastResponse[index].weather[0].main
                weatherForecast[index].day = day
                weatherForecast[index].unixTime = Int64(truncatingIfNeeded: fiveForecastResponse[index].dt)
            } else {
                let weatherForecastFromResponse = WeatherForecast(context: managedObjectContext)
                weatherForecastFromResponse.weather = fiveForecastResponse[index].weather[0].main
                weatherForecastFromResponse.day = day
                weatherForecastFromResponse.unixTime = Int64(truncatingIfNeeded: fiveForecastResponse[index].dt)
            }

            contextSave(errorMessage: "saveWeatherForecast failed")
        }
        
        for weather in weatherForecast {
            debugPrint(weather)
        }
    
        debugPrint(weatherForecast.count)
    }

    private func contextSave(errorMessage: String = "unknownError") {
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint(errorMessage)
        }
    }
}
