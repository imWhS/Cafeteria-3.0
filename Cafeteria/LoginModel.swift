//
//  LoginModel.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/14.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LoginModel: NetworkModel {
    
    let _login = "login"
    let _cafecode = "cafecode.json"
    let _logout = "logout"
    let _version = "version.json"
    let _notice = "notice.json"
    
    func login(id: String, password: String, auto: Bool) {
        
        let params = [
            "id": id,
            "password": password
        ]
        //userPreferences.saveSNO(sno: sno)
        post(function: _login, type: LoginObject.self, params: params)
    }
    
    /*
    func logout() {
        if let token = userPreferences.getToken() {
            let params = [
                "token": token
            ]
            post(function: _logout, params: params)
        } else {
            self.view?.networkResult(resultData: true, code: _logout)
        }
        userPreferences.removeAllUserDefaults()
    }
    */
}
