//
//  MessageObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 16..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import ObjectMapper

class MessageObject: Mappable {
    var title: String?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.message <- map["message"]
    }
}
