//
//  ViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 23.01.2023.
//

import Moya
import Foundation
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private typealias ConcurrencyTask = _Concurrency.Task
    
    private let weatherDataManager = WeatherDataManager()
    
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    private var day: [Day]?
    private var weatherForecast: [WeatherForecast]?
    private var currentWeather: [CurrentWeather]?
    
    private let weatherForecastCellIdentifier = "WeatherForecastCell"
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        do {
            day = try managedObjectContext.fetch(Day.fetchRequest())
            weatherForecast = try managedObjectContext.fetch(WeatherForecast.fetchRequest())
            currentWeather = try managedObjectContext.fetch(CurrentWeather.fetchRequest())
            
            print(weatherForecast)
        } catch {
            debugPrint(error.localizedDescription)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherForecastCellIdentifier, for: indexPath) as! WeatherForecastCell
        if let forecast = day?[indexPath.item] {
            cell.configure(day: forecast.wrappedDay, image: forecast.averageWeather)
        }
        
        return cell
    }
    
    func updateData() {
        ConcurrencyTask {
            do {
                try await weatherDataManager.updateLocalData()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}

