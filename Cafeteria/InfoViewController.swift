//
//  InfoViewController.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/20.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.92, green: 0.29, blue: 0.24, alpha: 1.00)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func linkToINUcoop(_ sender: Any) {
        guard let url = URL(string: "https://uicoop.ac.kr:41052") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
