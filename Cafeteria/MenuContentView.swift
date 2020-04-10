//
//  MenuContentView.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/04.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class MenuContentView: UIView, UITextViewDelegate {
    @IBOutlet var menu: UITextView!
    var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = Bundle.main.loadNibNamed("MenuContentView", owner: self, options: nil)?.first as! UIView
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = Bundle.main.loadNibNamed("MenuContentView", owner: self, options: nil)?.first as! UIView
        commonInit()
    }
    
    func commonInit() {
        self.menu.delegate = self
        self.addSubview(view)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NSLog("TEST!!!!!!!!!!!!!!!!")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        NSLog("22222TEST!!!!!!!!!!!!!!!!")
    }
    
}
