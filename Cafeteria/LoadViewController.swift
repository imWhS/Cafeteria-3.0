//
//  LoadViewController.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/04.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        //self.present(vcName!, animated: false, completion: nil)
        
        self.performSegue(withIdentifier: "test", sender: self)
    }
}
