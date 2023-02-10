//
//  WeatherForecastPresenter.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 07.02.2023.
//

import CoreData
import UIKit

protocol Presenter {
    var router: Router? { get set }
    var interactor: Interactor? { get set }
    var view: VIPERView? { get set }
    
    func setDailyForecastDataSource(collectionView: UICollectionView)
    func setHourlyForecastDataSource(collectionView: UICollectionView)
    
    func loadData()
    func reloadData(days: [Day])
    
    func didCompleteLoading(isSucceed: Bool)
    func didCompleteFetch(weather: String, weatherDescription: String)
    
    func locationRequest()
    func mainView()
    func detailView()
}

final class WeatherForecastPresenter: Presenter {
    var view: VIPERView?
    
    var router: Router?
    
    var interactor: Interactor?
    
    private weak var collectionView: UICollectionView?
    
    private lazy var dailyDataSource = DailyWeatherForecastDataSource(collectionView: collectionView)
    
    private lazy var hourlyDataSource = HourlyWeatherForecastDataSource(collectionView: collectionView)
    
    private var day: Day?
    
    func setDailyForecastDataSource(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        dailyDataSource.dayDidSelect = { [weak self] day in
            self?.day = day
            self?.detailView()
        }
        
        collectionView.dataSource = dailyDataSource
        collectionView.delegate = dailyDataSource
    }
    
    func setHourlyForecastDataSource(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        collectionView.dataSource = hourlyDataSource
        
        hourlyDataSource.reload(day: day)
    }
    
    func loadData() {
        interactor?.loadData()
    }
    
    func reloadData(days: [Day]) {
        DispatchQueue.main.async {
            self.dailyDataSource.reload(days: days)
        }
    }
    
    func didCompleteLoading(isSucceed: Bool) {
        guard let view = view as? ViewController else { return }
        
        DispatchQueue.main.async {
            view.updateLoadingText(isSucceed: isSucceed)
        }
    }
    
    func didCompleteFetch(weather: String, weatherDescription: String) {
        guard let view = view as? ViewController else { return }
        
        DispatchQueue.main.async {
            view.setCurrentWeatherData(weather: weather, weatherDescription: weatherDescription)
        }
    }
    
    func locationRequest() {
        router?.showLocationView()
    }
    
    func mainView() {
        router?.showMainView()
    }
    
    func detailView() {
        router?.showDetailView()
    }
}
