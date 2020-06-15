//
//  WeeklyMenu.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/18.
//  Copyright © 2020 손원희. All rights reserved.
//

import Foundation

class DataVO {
    var type1: String = ""
    var type2: String = ""
    var calorie: Int = 0
    var corner_id: Int = 0
    var foods: String = ""
    var price: Int = 0
    
    init() {}
    init(type1: String, type2: String, calorie: Int, corner_id: Int, foods: String, price: Int) {
        self.type1 = type1
        self.type2 = type2
        self.calorie = calorie
        self.corner_id = corner_id
        self.foods = foods
        self.price = price
    }
}
