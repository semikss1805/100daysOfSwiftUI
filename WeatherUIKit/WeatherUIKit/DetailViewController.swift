//
//  DetailViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 02.02.2023.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var day: Day?
    
    private let weatherForecastCellIdentifier = "WeatherForecastCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        title = day?.day
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configure(day: Day) {
        self.day = day
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day?.weatherForecastArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherForecastCellIdentifier, for: indexPath) as! WeatherForecastCell
        if let relatedForecast = day?.weatherForecastArray[index] {
            let date = Date(timeIntervalSince1970: TimeInterval(relatedForecast.unixTime + 6400))
            let hour = date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)))
            
            cell.configure(text: hour, image: relatedForecast.weather)
        }
        
        return cell
    }
}
