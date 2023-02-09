//
//  WeatherNavigationController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 09.02.2023.
//

import UIKit

protocol VIPERView {
    var presenter: Presenter? { get set }
}

class WeatherNavigationController: UINavigationController, VIPERView {
    var presenter: Presenter?
    
    override func viewDidLoad() {
        presenter?.locationRequest()
    }
}
