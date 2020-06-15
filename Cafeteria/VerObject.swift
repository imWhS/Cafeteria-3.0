//
//  VerObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 6. 25..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import ObjectMapper

class VerObject: Mappable {
    var android: VerInfo?
    var ios: VerInfo?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.android <- map["android"]
        self.ios <- map["ios"]
    }
    
    class VerInfo: Mappable {
        var latest: String = ""
        var log: [VersionHistory] = []
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.latest <- map["latest"]
            self.log <- map["log"]
        }
        
    }
    
    class VersionHistory: Mappable {
        var version: String = ""
        var info: [String] = []
        var date: String = ""
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.version <- map["version"]
            self.info <- map["info"]
            self.date <- map["date"]
        }
    }
}
