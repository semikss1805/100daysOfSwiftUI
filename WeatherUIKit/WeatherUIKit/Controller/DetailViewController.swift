//
//  DetailViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 02.02.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!

    private var weatherForecastPresenter = WeatherForecastPresenter()
    
    private var day: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        title = day?.day

        weatherForecastPresenter.setHourlyDataSource(collectionView: collectionView, day: day)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configure(day: Day) {
        self.day = day
    }
}
