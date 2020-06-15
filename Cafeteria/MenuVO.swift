//
//  MenuVO.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/17.
//  Copyright © 2020 손원희. All rights reserved.
//

import Foundation

class MenuVO {
    var calorie: Int = 0
    var corner_id: Int = 0
    var foods: String = ""
    var price: Int = 0
    var test_1: String = ""
    var test_2: String = ""
    
    init() {}
    
    init(calorie: Int, corner_id: Int, foods: String, price: Int) {
        self.calorie = calorie
        self.corner_id = corner_id
        self.foods = foods
        self.price = price
    }
    
    init(calorie: Int, corner_id: Int, foods: String, price: Int, test_1: String, test_2: String) {
        self.calorie = calorie
        self.corner_id = corner_id
        self.foods = foods
        self.price = price
        self.test_1 = test_1
        self.test_2 = test_2
    }
}
