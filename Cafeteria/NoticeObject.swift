//
//  NoticeObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 25..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import ObjectMapper

class Notices: Mappable {
    var all: Notice?
    var ios: Notice?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.all <- map["all"]
        self.ios <- map["ios"]
    }
}

class Notice: Mappable {
    var title: String?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.message <- map["message"]
    }
}
