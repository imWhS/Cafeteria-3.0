//
//  NumberObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 22..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import Foundation
import ObjectMapper

class WaitNumber: Mappable {
    var cafecode: String = ""
    var num: [String] = []
    var _cafecode: Int {
        if let int = Int(cafecode) { return int }
        return -1
    }
    var _num: [Int] {
        return num.flatMap { Int($0) }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.cafecode <- map["cafecode"]
        self.num <- map["num"]
    }
}
