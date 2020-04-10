//
//  MenuCardView.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/03/30.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class MenuCardView: UIView, UITableViewDataSource, UITableViewDelegate {
    var view: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var bg: UIView!
    @IBOutlet var menuList: UITextView!
    @IBOutlet var menuScrollView: UIScrollView!
    @IBOutlet var tableView_list: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        view = Bundle.main.loadNibNamed("MenuCardView", owner: self, options: nil)?.first as! UIView
        view.frame = frame
        innerView.frame = frame
        self.addSubview(view)
        
        tableView_list.delegate = self
        tableView_list.dataSource = self
        let nibName = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView_list.register(nibName, forCellReuseIdentifier: "dCell")

        tableView_list.backgroundColor = .white
        tableView_list.rowHeight = UITableView.automaticDimension
        
        view.backgroundColor = .none
        menuList.backgroundColor = .white
        bg.backgroundColor = .white
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.masksToBounds = false
        bg.layer.shadowOffset = CGSize(width: 0, height: 6)
        bg.layer.shadowRadius = 12
        bg.layer.shadowOpacity = 0.2
        bg.layer.cornerRadius = 15
        
        self.addSubview(view)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("hello \(indexPath.row)")
        var cell = tableView.dequeueReusableCell(withIdentifier: "dCell") as! MenuTableViewCell
        //cell.content.text = "sample cell"
        return cell
    }
    

    
}
