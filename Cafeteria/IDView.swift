//
//  IDView.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/03/31.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class IDView: UIView {
    private let xibName = "IDView"
    @IBOutlet var sView: UIView!
    @IBOutlet var id_field: HoshiTextField!
    @IBOutlet var pw_field: HoshiTextField!
    @IBOutlet var search_account_btn: UIButton!
    @IBOutlet var desc_view: UIView!
    @IBOutlet var login_form_view: UIView!
    
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
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.bounds.height)
        
        self.addSubview(view)
    }
}
