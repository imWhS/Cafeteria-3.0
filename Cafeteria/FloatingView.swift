//
//  StudentIDView.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/03/30.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class FloatingView: UIView {
    private let xibName = "FloatingView"
    @IBOutlet var contentView: UIView!
    @IBOutlet var bottomView: UIView!
    var logged_in = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        
        view.backgroundColor = .blue
        view.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        view.subviews[0].frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    
        
        NSLog("bottomView width: \(bottomView.frame.width)")
        if logged_in == false {
            let IDV = IDView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: bottomView.frame.height))
            IDV.sView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            bottomView.addSubview(IDV)
        }
        
        self.addSubview(view)
    }
}

