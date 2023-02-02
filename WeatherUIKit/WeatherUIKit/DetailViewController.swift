//
//  DetailViewController.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 02.02.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var name: String?
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidLoad()
        
        title = name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
