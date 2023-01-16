//
//  WeatherForecast+CoreDataProperties.swift
//  Weather
//
//  Created by SemikSS on 16.01.2023.
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
    @NSManaged public var relatedDay: Day?

}

extension WeatherForecast : Identifiable {

}
