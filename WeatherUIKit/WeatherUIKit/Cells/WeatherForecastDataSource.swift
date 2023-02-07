//
//  WeatherForecastDataSource.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 07.02.2023.
//

import UIKit

final class WeatherForecastDataSource: NSObject {
    
    internal weak var collectionView: UICollectionView?
    
    var storyboard: UIStoryboard?
    var navigationController: UINavigationController?
    
    var days: [Day]?
    
    private enum Identifier: String {
        case DetailViewController
        case WeatherForecastCell
    }
    
    init(collectionView: UICollectionView?, navigationController: UINavigationController?, storyboard: UIStoryboard?, days: [Day]?) {
        self.collectionView = collectionView
        self.navigationController = navigationController
        self.storyboard = storyboard
        self.days = days
        
        super.init()
    }
}

extension WeatherForecastDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.WeatherForecastCell.rawValue, for: indexPath) as! WeatherForecastCell
        
        cell.prepareForReuse()
        
        if let day = days?[indexPath.item] {
            cell.configure(text: day.wrappedDay, image: day.averageWeather)
        }
        
        return cell
    }
}

extension WeatherForecastDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: Identifier.DetailViewController.rawValue) as? DetailViewController,
           let day = days?[index]{
            detailVC.configure(day: day)
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
