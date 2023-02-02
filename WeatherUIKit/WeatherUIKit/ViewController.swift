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
    
    private enum Identifier: String {
        case DetailViewController
        case WeatherForecastCell
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.updateData()
        
        self.fetchData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .dataChanged, object: weatherDataManager)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.WeatherForecastCell.rawValue, for: indexPath) as! WeatherForecastCell
        if let forecast = day?[indexPath.item] {
            cell.configure(day: forecast.wrappedDay, image: forecast.averageWeather)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: Identifier.DetailViewController.rawValue) as? DetailViewController {
            detailVC.name = day?[index].day
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
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
    
    @objc func fetchData() {
        do {
            day = try managedObjectContext.fetch(Day.fetchRequest()).sorted(by: { $0.dayNumber < $1.dayNumber})
            weatherForecast = try managedObjectContext.fetch(WeatherForecast.fetchRequest()).sorted(by: { $0.unixTime < $1.unixTime})
            currentWeather = try managedObjectContext.fetch(CurrentWeather.fetchRequest())
            
            debugPrint(weatherForecast)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

