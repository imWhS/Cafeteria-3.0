//
//  FloatingViewContoller.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/02.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var bottomView: UIView!
    @IBOutlet var loginBtn: PMSuperButton!
    
    var logged_in = false
    var IDV: IDView!
    var is_moved = false

    var loginBtn_y: CGFloat!
    
    var cal_loginBtn_y: CGFloat {
        get {
            return loginBtn_y
        }
        set {
            if loginBtn_y != newValue {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if logged_in == false {
            IDV = IDView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: UIScreen.main.bounds.size.height - 26 - 66 - 30))
            bottomView.addSubview(IDV)
            
            IDV.id_field.textContentType = .username
            IDV.pw_field.delegate = self

            loginBtn_y = loginBtn.frame.origin.y
            
            NotificationCenter.default.addObserver(
              self,
              selector: #selector(keyboardWillShow),
              name: UIResponder.keyboardWillShowNotification,
              object: nil
            )
            
            NotificationCenter.default.addObserver(
              self,
              selector: #selector(keyboardWillHide),
              name: UIResponder.keyboardWillHideNotification,
              object: nil
            )
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        UIView.animate(withDuration: 0.7) { self.IDV.desc_view.alpha = 0 }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if is_moved == false {
                let window = UIApplication.shared.windows[0]
                let safeFrame = window.safeAreaLayoutGuide.layoutFrame
                let topSafeAreaHeight = safeFrame.minY
                let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
                
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height + 34 - bottomSafeAreaHeight
                //let keyboardHeight = keybaordRectangle.height
                
                IDV.login_form_view.frame.origin.y -= 183
                loginBtn.frame.origin.y -= keyboardHeight
                
                loginBtn_y = keyboardHeight
                cal_loginBtn_y = keyboardHeight
                
                NSLog("SHOWING keyboard height (WillShow): \(keyboardHeight)")
                is_moved = true
            }
        }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.7) { self.IDV.desc_view.alpha = 1 }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            
            
            if is_moved {
                IDV.login_form_view.frame.origin.y += 183
                //loginBtn.frame.origin.y = loginBtn_y
                loginBtn.frame.origin.y += cal_loginBtn_y
                NSLog("SHOWING keyboard height (WillHide): \(cal_loginBtn_y)")
                is_moved = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.IDV.id_field.isFirstResponder {
            self.IDV.id_field.resignFirstResponder()
        } else if self.IDV.pw_field.isFirstResponder {
            self.IDV.pw_field.resignFirstResponder()
        }
    }
}
