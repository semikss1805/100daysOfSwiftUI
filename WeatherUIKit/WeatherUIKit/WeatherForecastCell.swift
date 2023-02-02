//
//  WeatherForecastCell.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 01.02.2023.
//

import UIKit

class WeatherForecastCell: UICollectionViewCell {
    
    
    @IBOutlet var forecastImage: UIImageView!
    @IBOutlet var forecastDay: UILabel!
    
    func configure(day: String, image: String) {
        forecastImage.image = UIImage(named: image)
        forecastDay.text = day
        
    }
    
    
}
