//
//  WeatherForecast+CoreDataProperties.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 31.01.2023.
//
//

import Foundation
import CoreData


extension WeatherForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherForecast> {
        return NSFetchRequest<WeatherForecast>(entityName: "WeatherForecast")
    }

    @NSManaged public var weather: String?
    @NSManaged public var unixTime: Int64
    @NSManaged public var temp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var tempFeelsLike: Double
    @NSManaged public var relatedDay: Day

    public var wrappedWeather: String {
        weather ?? "unknown weather"
    }
    
    public var wrappedUnixTime: Int64 {
        unixTime
    }
    
    public var wrappedTemp: Double {
        temp
    }
    
    public var wrappedMinTemp: Double {
        minTemp
    }
    
    public var wrappedMaxTemp: Double {
        maxTemp
    }
    
    public var wrappedTempFeelsLike: Double {
        tempFeelsLike
    }

}

extension WeatherForecast : Identifiable {

}
