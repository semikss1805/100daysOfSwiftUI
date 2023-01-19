//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by SemikSS on 03.01.2023.
//

import XCTest
import Moya
import CoreData
@testable import Weather

// Quick, Nimble, SwiftyMocky

class WeatherTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWeatherModelRelation() throws {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let weatherForecast = try managedObjectContext.fetch(WeatherForecast.fetchRequest())
        
        for singleForecast in weatherForecast {
            XCTAssertNotNil(singleForecast.relatedDay.day)
        }
    }
    
    func testForecastResponseMaping() throws {
        let url = Bundle.main.url(forResource: "TestResponse", withExtension: "json")!
        let data = try Data(contentsOf: url)
        
        let response = Response(statusCode: 200, data: data)
        
        let result = try response.map(OpenWeatherManager.ForecastResponse.self)
        
        XCTAssertEqual(result.list.first?.dt, 1673276400)
        XCTAssertEqual(result.list.first?.main.temp, 286.73)
        XCTAssertEqual(result.list.first?.main.feels_like, 286.62)
        XCTAssertEqual(result.list.first?.main.temp_min, 286.66)
        XCTAssertEqual(result.list.first?.main.temp_max, 286.73)
        XCTAssertEqual(result.list.first?.weather.first?.main, "Rain")
    }
    
    func testWeatherModelSaveDelete() throws {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        let testWeatherForecast = WeatherForecast(context: context)
        testWeatherForecast.weather = "Cloud"
        testWeatherForecast.unixTime = 1673276400
        testWeatherForecast.relatedDay = Day(context: context)
        testWeatherForecast.relatedDay.day = "test day"
        testWeatherForecast.relatedDay.dayNumber = 0
        testWeatherForecast.temp = 286.73
        testWeatherForecast.minTemp = 286.66
        testWeatherForecast.maxTemp = 286.73
        testWeatherForecast.tempFeelsLike = 286.62
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in return true }
        
        try context.save()
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        var weatherForecast = try context.fetch(WeatherForecast.fetchRequest())
        
        XCTAssertEqual(weatherForecast.count, 1)
        
        context.delete(testWeatherForecast)
        try context.save()
        
        weatherForecast = try context.fetch(WeatherForecast.fetchRequest())

        XCTAssertEqual(weatherForecast.count, 0)
    }
}
