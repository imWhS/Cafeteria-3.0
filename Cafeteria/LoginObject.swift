//
//  LoginObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 28..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import ObjectMapper

class LoginObject: Mappable {
    
    var barcode: String?
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.barcode <- map["barcode"]
        self.token <- map["token"]
    }
}

class CafeCode: Mappable {
    
    var no: String = ""
    var name: String = ""
    var menu: Int = -1
    
    var alarm: Bool = false
    var img: String = ""
    var bgimg: String = ""
    var order: String = ""
    
    var _no: Int {
        if let int = Int(no) { return int }
        return -1
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.no <- map["no"]
        self.name <- map["name"]
        self.menu <- map["menu"]
        self.alarm <- map["alarm"]
        self.img <- map["img"]
        self.bgimg <- map["bgimg"]
        self.order <- map["order"]
    }
}

class NoticeObject: Mappable {
    var all: DetailNotice?
    var ios: DetailNotice?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.all <- map["all"]
        self.ios <- map["ios"]
    }
    
    class DetailNotice: Mappable {
        var title: String = ""
        var message: String?
        var id: String = ""
        
        func mapping(map: Map) {
            self.id <- map["id"]
            self.title <- map["title"]
            self.message <- map["message"]
        }
        
        func isVaild() -> Int? {
            // 메시지 값이 없으면 공지 없는거
            // 공지가 있으면 id값 반환
            if let msg = self.message {
                if msg == "" { return nil }
                return Int(self.id)
            }
            return nil
        }
        
        required init?(map: Map) {
            
        }
    }
}

class AdObject: Mappable {
    var no: String = ""
    var title: String = ""
    var img: String = ""
    var previewimg: String = ""
    var url: String = ""
    var contents: [ContentObj]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.no <- map["no"]
        self.title <- map["title"]
        self.img <- map["img"]
        self.previewimg <- map["previewimg"]
        self.url <- map["url"]
        self.contents <- map["contents"]
    }
    
    class ContentObj: Mappable {
        var title: String = ""
        var msg: String = ""
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.title <- map["title"]
            self.msg <- map["msg"]
        }
    }
}

class FoodMenu: Mappable {
    var calorie: Int = 0
    var corner_id: Int = 0
    var foods: String = ""
    var price: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.calorie <- map["calorie"]
        self.corner_id <- map["corner-id"]
        self.foods <- map["foods"]
        self.price <- map["price"]
    }
}
