//
//  WeatherForecastCell.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 01.02.2023.
//

import UIKit

class WeatherForecastCell: UICollectionViewCell {
    
    
    @IBOutlet var forecastImage: UIImageView!
    @IBOutlet var forecastLabel: UILabel!
    
    func configure(text: String, image: String) {
        forecastImage.image = UIImage(named: image)
        forecastLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        forecastImage.image = nil
        forecastLabel.text = nil
    }
}
