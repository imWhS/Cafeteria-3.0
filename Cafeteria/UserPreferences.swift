//
//  UserPreferences.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/06/13.
//  Copyright © 2020 손원희. All rights reserved.
//

import Foundation

let userPreferences = UserDefaults.standard


extension UserDefaults {
    
    private var _barcode: String {
        return "barcode"
    }
    
    private var _token: String {
        return "token"
    }
    
    open func saveBarcode(barcode: String) {
        userPreferences.setValue(barcode, forKey: _barcode)
    }
    
    open func getBarcode() -> String? {
        if let b = userPreferences.string(forKey: _barcode) {
            print(b)
            return b
        }
        return nil
    }
    
    open func isBarcode() -> Bool {
        if userPreferences.object(forKey: _barcode) != nil {
            return true
        }
        return false
    }
    
    open func saveToken(token: String) {
        userPreferences.setValue(token, forKey: _token)
    }
    
    open func getToken() -> String? {
        if let t = userPreferences.string(forKey: _token) {
            return t
        }
        return nil
    }
    
    open func removeAllUserDefaults() {
        userPreferences.removeObject(forKey: _barcode)
        userPreferences.removeObject(forKey: _token)
    }
}
