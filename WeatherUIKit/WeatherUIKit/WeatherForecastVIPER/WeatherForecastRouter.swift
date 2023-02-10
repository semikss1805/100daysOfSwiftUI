//
//  WeatherForecastRouter.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 09.02.2023.
//

import UIKit

typealias EntryPoint = VIPERView & UINavigationController

protocol Router {
    var entry: EntryPoint? { get }
    var storyboard: UIStoryboard? { get }
    var navigationController: EntryPoint? { get }
    
    var presenter: Presenter? { get }
    var interactor: Interactor? { get }
    
    static func start() -> Router
    
    func showLocationView()
    func showMainView()
    func showDetailView()
}

final class WeatherForecastRouter: Router {
    var presenter: Presenter?
    
    var interactor: Interactor?
    
    var storyboard: UIStoryboard?
    
    var navigationController: EntryPoint?
    
    var entry: EntryPoint?
    
    private enum Identifier: String {
        case NavigationController
        case LocationViewController
        case MainViewController
        case DetailViewController
    }
    
    static func start() -> Router {
        let router = WeatherForecastRouter()
        
        var presenter: Presenter = WeatherForecastPresenter()
        var interactor: Interactor = WeatherForecastInteractor()
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.interactor = interactor
        
        router.storyboard = UIStoryboard(name: "Main", bundle: nil)
        router.navigationController = router.storyboard?.instantiateViewController(withIdentifier: Identifier.NavigationController.rawValue) as? EntryPoint
        router.navigationController?.presenter = presenter
        
        router.entry = router.navigationController
        router.presenter = presenter
        router.interactor = interactor
        
        return router
    }
    
    func showLocationView() {
        guard var locationVC = storyboard?.instantiateViewController(withIdentifier: Identifier.LocationViewController.rawValue) as? UIViewController & VIPERView else {
            debugPrint("Cast Failed")
            return
        }
        
        locationVC.presenter = presenter
        presenter?.view = locationVC
        
        navigationController?.setViewControllers([locationVC], animated: true)
    }
    
    func showMainView() {
        guard var mainVC = storyboard?.instantiateViewController(withIdentifier: Identifier.MainViewController.rawValue) as? UIViewController & VIPERView else {
            debugPrint("Cast Failed")
            return
        }
        
        mainVC.presenter = presenter
        presenter?.view = mainVC
        
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func showDetailView() {
        guard var detailVC = storyboard?.instantiateViewController(withIdentifier: Identifier.DetailViewController.rawValue) as? UIViewController & VIPERView else {
            debugPrint("Cast Failed")
            return
        }
        
        detailVC.presenter = presenter
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
