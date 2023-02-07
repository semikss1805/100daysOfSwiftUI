//
//  ViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 23.01.2023.
//

import Moya
import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet private var loadingText: UILabel!
    @IBOutlet private var currentWeatherImage: UIImageView!
    @IBOutlet private var currentWeatherTextView: UITextView!
    
    private var dailyWeatherForecastDataSource: DailyWeatherForecastDataSource?
    
    private typealias ConcurrencyTask = _Concurrency.Task
    
    private let weatherDataManager = WeatherDataManager()
    
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    private var day: [Day]?
    private var weatherForecast: [WeatherForecast]?
    private var currentWeather: [CurrentWeather]?
    
    private enum Identifier: String {
        case DetailViewController
        case WeatherForecastCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        updateData { [self] in
            fetchData()
            setCurrentWeatherData()
            dailyWeatherForecastDataSource = DailyWeatherForecastDataSource(collectionView: collectionView, navigationController: navigationController, storyboard: storyboard, days: day)

            collectionView.delegate = dailyWeatherForecastDataSource
            collectionView.dataSource = dailyWeatherForecastDataSource
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func setCurrentWeatherData() {
        let currentWeatherDescription = "\(currentWeather?.last?.name ?? ""), \(currentWeather?.last?.day ?? "")"
        
        currentWeatherImage.image = UIImage(named: currentWeather?.first?.weather ?? "")
        currentWeatherTextView.text = currentWeatherDescription
    }
    
    func updateData(completion: @escaping () -> Void) {
        ConcurrencyTask {
            do {
                try await weatherDataManager.updateLocalData()
                
                loadingText.isHidden = true
            } catch {
                loadingText.text = "Update Failed"
                debugPrint(error.localizedDescription)
            }
            
            completion()
        }
    }
    
    func fetchData() {
        do {
            day = try managedObjectContext.fetch(Day.fetchRequest()).sorted(by: { $0.dayNumber < $1.dayNumber})
            weatherForecast = try managedObjectContext.fetch(WeatherForecast.fetchRequest()).sorted(by: { $0.unixTime < $1.unixTime})
            currentWeather = try managedObjectContext.fetch(CurrentWeather.fetchRequest())
            debugPrint(weatherForecast)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getDays() -> [Day]? {
        day
    }
}

