//
//  Day+CoreDataProperties.swift
//  Weather
//
//  Created by SemikSS on 16.01.2023.
//
//

import Foundation
import CoreData
import UIKit


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var day: String?
    @NSManaged public var dayNumber: Int32
    @NSManaged public var weatherForecast: NSSet?

    public var wrappedDay: String {
        day ?? "unknown day"
    }
    
    public var wrappedDayNumber: Int32 {
        dayNumber
    }
    
    public var weatherForecastArray: [WeatherForecast] {
        let set = weatherForecast as? Set<WeatherForecast> ?? []
        
        return set.sorted { $0.unixTime < $1.unixTime }
    }
    
    public var averageWeather: String {
        var weathers = Set<String>()
        
        for weatherForecast in weatherForecastArray {
            weathers.insert(weatherForecast.weather ?? "")
        }
        
        let countedSet = NSCountedSet(array: weatherForecastArray)

        var averageWeather = weatherForecastArray.first?.weather ?? ""
        var hoursAmount = countedSet.count(for: averageWeather)
        
        for weather in weathers {
            let weatherCount = countedSet.count(for: weather)
            
            if weatherCount > hoursAmount {
                averageWeather = weather
                hoursAmount = weatherCount
            }
        }
        
        return averageWeather
    }
}

// MARK: Generated accessors for weatherForecast
extension Day {

    @objc(addWeatherForecastObject:)
    @NSManaged public func addToWeatherForecast(_ value: WeatherForecast)

    @objc(removeWeatherForecastObject:)
    @NSManaged public func removeFromWeatherForecast(_ value: WeatherForecast)

    @objc(addWeatherForecast:)
    @NSManaged public func addToWeatherForecast(_ values: NSSet)

    @objc(removeWeatherForecast:)
    @NSManaged public func removeFromWeatherForecast(_ values: NSSet)

}

extension Day : Identifiable {

}
