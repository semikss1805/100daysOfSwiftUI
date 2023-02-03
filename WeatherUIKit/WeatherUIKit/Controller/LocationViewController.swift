//
//  LocationViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 31.01.2023.
//

import UIKit

class LocationViewController: UIViewController {
    @IBOutlet var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.requestLocation()
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
