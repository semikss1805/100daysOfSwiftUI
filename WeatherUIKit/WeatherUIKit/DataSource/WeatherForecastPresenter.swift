//
//  WeatherForecastPresenter.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 07.02.2023.
//

import UIKit

final class WeatherForecastPresenter {
    internal weak var collectionView: UICollectionView?
    
    private var day: Day?
    
    private lazy var hourlyDataSource = HourlyWeatherForecastDataSource(collectionView: collectionView, day: day)
    
    private var storyboard: UIStoryboard?
    private var navigationController: UINavigationController?
    private var days: [Day]?
    
    private lazy var dailyDataSource = DailyWeatherForecastDataSource(collectionView: collectionView, navigationController: navigationController, storyboard: storyboard, days: days)
    
    func setHourlyDataSource(collectionView: UICollectionView?, day: Day?) {
        self.collectionView = collectionView
        self.day = day
        
        collectionView?.dataSource = hourlyDataSource
    }
    
    func setDailyDataSource(collectionView: UICollectionView?, navigationController: UINavigationController?, storyboard: UIStoryboard?, days: [Day]?) {
        self.collectionView = collectionView
        self.navigationController = navigationController
        self.storyboard = storyboard
        self.days = days
        
        collectionView?.dataSource = dailyDataSource
        collectionView?.delegate = dailyDataSource
    }
}
