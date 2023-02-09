//
//  ViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 23.01.2023.
//

import Moya
import UIKit
import SwiftUI

class ViewController: UIViewController, VIPERView {
    var presenter: Presenter?
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet private var loadingText: UILabel!
    @IBOutlet private var currentWeatherImage: UIImageView!
    @IBOutlet private var currentWeatherTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        presenter?.setDailyForecastDataSource(collectionView: collectionView )
        
        presenter?.loadData()
    }
    
    func setCurrentWeatherData(weather: String, weatherDescription: String) {
        currentWeatherImage.image = UIImage(named: weather)
        currentWeatherTextView.text = weatherDescription
    }
    
    func updateLoadingText(isSucceed: Bool) -> Void {
        if isSucceed {
            loadingText.isHidden = true
        } else {
            loadingText.text = "Update Failed"
        }
    }
}

