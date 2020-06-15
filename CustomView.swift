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
    @IBOutlet var menu_table: UITableView!
    @IBOutlet var restaurant_title: UILabel!
    @IBOutlet var restaurant_desc: UILabel!
    @IBOutlet var menuAlarm: PMSuperButton!
    
    var menus: [DataVO] = [] {
        didSet {
            print("menus didSet called!")
            
        }
    }
    
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
        menu_table.delegate = self
        menu_table.dataSource = self
        menu_table.backgroundColor = .white
        menu_table.estimatedRowHeight = 100
        menu_table.rowHeight = UITableView.automaticDimension
        
        let nibName = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.menu_table.register(nibName, forCellReuseIdentifier: "dCell")
        
        let nibName2 = UINib(nibName: "CustomTableViewCell2", bundle: nil)
        self.menu_table.register(nibName2, forCellReuseIdentifier: "dCell2")
        
        bg.backgroundColor = .white
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.masksToBounds = false
        bg.layer.shadowOffset = CGSize(width: 0, height: 6)
        bg.layer.shadowRadius = 8
        bg.layer.shadowOpacity = 0.2
        bg.layer.cornerRadius = 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if menus[indexPath.row].type1 != "" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "dCell2") as! CustomTableViewCell2
            cell.category.text = "\(menus[indexPath.row].type1)\(menus[indexPath.row].type2)"
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "dCell") as! CustomTableViewCell
            cell.tlabel.numberOfLines = 0
            cell.tlabel.lineBreakMode = .byWordWrapping
            cell.tlabel.sizeToFit()
            cell.tlabel.text = menus[indexPath.row].foods
            cell.price.layer.borderWidth = 1.5
            cell.price.layer.borderColor = UIColor(red: 0.92, green: 0.29, blue: 0.24, alpha: 1.00).cgColor
            cell.price.layer.masksToBounds = false
            cell.price.layer.cornerRadius = 10.5
            if menus[indexPath.row].price == 0 {
                cell.price.text = "직접 문의"
            } else {
                cell.price.text = "￦ \(menus[indexPath.row].price)"
            }
            
            if menus[indexPath.row].calorie == 0 {
                cell.kcal.text = ""
            } else {
                cell.kcal.text = "\(menus[indexPath.row].calorie)kcal"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func MenuNotiBtn(_ sender: Any) {
        let alert = UIAlertController(title: "테스트 메시지", message: "테스트 메시지입니다.", preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(action1)
        
    }
}
