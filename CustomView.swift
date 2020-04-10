//
//  CustomView.swift
//  TestTableViewInView
//
//  Created by 손원희 on 2020/04/05.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class CustomView: UIView, UITableViewDelegate, UITableViewDataSource {
    var view: UIView!
    @IBOutlet var bg: UIView!
    @IBOutlet var world_table: UITableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        view = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        world_table.delegate = self
        world_table.dataSource = self
        world_table.backgroundColor = .white
        world_table.estimatedRowHeight = 100
        world_table.rowHeight = UITableView.automaticDimension
        
        let nibName = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.world_table.register(nibName, forCellReuseIdentifier: "dCell")
        
        let nibName2 = UINib(nibName: "CustomTableViewCell2", bundle: nil)
        self.world_table.register(nibName2, forCellReuseIdentifier: "dCell2")
        
        bg.backgroundColor = .white
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.masksToBounds = false
        bg.layer.shadowOffset = CGSize(width: 0, height: 6)
        bg.layer.shadowRadius = 12
        bg.layer.shadowOpacity = 0.2
        bg.layer.cornerRadius = 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "dCell") as! CustomTableViewCell
        NSLog("NOL1: \(cell.tlabel.numberOfLines)")
        cell.tlabel.numberOfLines = 0
        cell.tlabel.lineBreakMode = .byWordWrapping
        cell.tlabel.sizeToFit()
        
        var cell2 = tableView.dequeueReusableCell(withIdentifier: "dCell2") as! CustomTableViewCell2
        cell2.price.layer.borderWidth = 1.5
        cell2.price.layer.borderColor = UIColor.red.cgColor
        cell2.price.layer.masksToBounds = false
        cell2.price.layer.cornerRadius = 10.5
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
