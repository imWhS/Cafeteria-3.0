//
//  Network.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/14.
//  Copyright © 2020 손원희. All rights reserved.
//

import Foundation

struct Network {
    
    func saveCookie() {
        let cookies: [Any] = HTTPCookieStorage.shared.cookies!
        let cookieData = NSKeyedArchiver.archivedData(withRootObject: cookies)
        UserDefaults.standard.set(cookieData, forKey: "Cookies")
    }
    
    func getCookie() {
        var cookiesData: Data? = UserDefaults.standard.object(forKey: "Cookies") as? Data
        if cookiesData?.count != nil {
            let cookies: [HTTPCookie]? = NSKeyedUnarchiver.unarchiveObject(with: cookiesData!) as? [HTTPCookie]
            for cookie: HTTPCookie in cookies! {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
}
