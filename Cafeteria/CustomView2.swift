//
//  CustomView.swift
//  TestTableViewInView
//
//  Created by 손원희 on 2020/04/05.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class CustomView2: UIView, UITableViewDelegate, UITableViewDataSource {
    var view: UIView!
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
        view = Bundle.main.loadNibNamed("CustomView2", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        world_table.delegate = self
        world_table.dataSource = self
        
        let nibName2 = UINib(nibName: "CustomTableViewCell2", bundle: nil)
        self.world_table.register(nibName2, forCellReuseIdentifier: "dCell2")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "dCell2") as! CustomTableViewCell2
        cell.tlabel.text = "Asshole"
        
        return cell
    }
}
