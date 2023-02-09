//
//  WeatherForecastDataSource.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 07.02.2023.
//

import UIKit

final class DailyWeatherForecastDataSource: NSObject {
    var presenter: Presenter?
    
    private weak var collectionView: UICollectionView?
    
    private var days: [Day]?
    
    private enum Identifier: String {
        case DetailViewController
        case WeatherForecastCell
    }
    
    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
        
        super.init()
    }
    
    func reload(days: [Day]) {
        self.days = days
        
        collectionView?.reloadData()
    }
}

extension DailyWeatherForecastDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.WeatherForecastCell.rawValue, for: indexPath) as! WeatherForecastCell
        
        if let day = days?[indexPath.item] {
            cell.configure(text: day.wrappedDay, image: day.averageWeather)
        }
        
        return cell
    }
}

extension DailyWeatherForecastDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        if let day = days?[index] {
            presenter?.didSelectItem(day: day)
        }
    }
}
