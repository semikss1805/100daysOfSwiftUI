//
//  ViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 23.01.2023.
//

import Moya
import UIKit
import SwiftUI

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var loadingText: UILabel!
    @IBOutlet var currentWeatherImage: UIImageView!
    @IBOutlet var currentWeatherTextView: UITextView!
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
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        updateData {
            self.fetchData()
            self.setCurrentWeatherData()
            self.collectionView.reloadData()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        
        cell.prepareForReuse()
        
        if let day = day?[indexPath.item] {
            cell.configure(text: day.wrappedDay, image: day.averageWeather)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: Identifier.DetailViewController.rawValue) as? DetailViewController,
           let day = day?[index]{
            detailVC.configure(day: day)
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
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
}

