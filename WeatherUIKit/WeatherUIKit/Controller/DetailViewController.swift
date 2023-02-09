//
//  DetailViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 02.02.2023.
//

import UIKit

class DetailViewController: UIViewController, VIPERView {
    var presenter: Presenter?
    
    @IBOutlet var collectionView: UICollectionView!

    private var weatherForecastPresenter = WeatherForecastPresenter()
    
    private var day: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        title = day?.day
        
        presenter?.setHourlyForecastDataSource(collectionView: collectionView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
