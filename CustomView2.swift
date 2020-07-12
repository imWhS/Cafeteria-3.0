//
//  CustomView.swift
//  TestTableViewInView
//
//  Created by 손원희 on 2020/04/05.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class CustomView2: UIView {
    var view: UIView!
    @IBOutlet var restaurant_title: UILabel!
    @IBOutlet var restaurant_desc: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        view = Bundle.main.loadNibNamed("CustomView2", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
