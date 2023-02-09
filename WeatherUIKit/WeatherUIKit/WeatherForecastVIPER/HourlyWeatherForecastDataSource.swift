//
//  HourlyWeatherForecastDataSource.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 07.02.2023.
//

import UIKit

final class HourlyWeatherForecastDataSource: NSObject {
    private weak var collectionView: UICollectionView?
    
    private var day: Day?
    
    private let weatherForecastCellIdentifier = "WeatherForecastCell"

    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }
    
    func reload(day: Day?) {
        self.day = day
        
        collectionView?.reloadData()
    }
}

extension HourlyWeatherForecastDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day?.weatherForecastArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherForecastCellIdentifier, for: indexPath) as! WeatherForecastCell
        
        cell.prepareForReuse()
        
        if let relatedForecast = day?.weatherForecastArray[index] {
            let date = Date(timeIntervalSince1970: TimeInterval(relatedForecast.unixTime + 6400))
            let hour = date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)))
            
            cell.configure(text: hour, image: relatedForecast.weather)
        }
        
        return cell
    }
}
