//
//  FloatingViewContoller.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/02.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit
import SPAlert

class FloatingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var errorMsgLabel: UILabel!
    var isSignedIn = false
    var IDV: IDView!
    var BV: BarcodeView!
    var alertView: SPAlertView!
    
    /*
     SignInView 관련 프로퍼티
     */
    @IBOutlet var loginBtn: PMSuperButton!
    var idTF: HoshiTextField!
    var pwTF: HoshiTextField!
    var is_moved = false
    var loginBtn_y: CGFloat!
    var cal_loginBtn_y: CGFloat {
        get { return loginBtn_y }
        set { if loginBtn_y != newValue { return } }
    }
    var errorMsgLabel_y: CGFloat!
    var cal_errorMsgLabel_y: CGFloat {
        get { return errorMsgLabel_y }
        set { if errorMsgLabel_y != newValue { return } }
    }
    
    private lazy var loginModel: LoginModel = {
        let model = LoginModel(self)
        return model
    }()
    
    @IBOutlet var tmpErrorView: NetworkConnectionErrorView2!
    @IBOutlet var tmpErrorViewHeight: NSLayoutConstraint!
    @IBOutlet var tmpErrorViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        
        let tmpErrorViewX = tmpErrorView.frame.maxX
        let tmpErrorViewY = tmpErrorView.frame.maxY
        
        tmpErrorView.moveToPage.addTarget(self, action: #selector(pressed1), for: .touchUpInside)
        
        tmpErrorView.close.addTarget(self, action: #selector(pressed2), for: .touchUpInside)
        
        tmpErrorView.frame = CGRect(x: tmpErrorViewX, y: tmpErrorViewY, width: bottomView.frame.width, height: 300 + bottomSafeAreaHeight)
        tmpErrorViewHeight.constant += bottomSafeAreaHeight
        
        tmpErrorView.bg.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 300)
    
        if userPreferences.isBarcode() {
            setBarcodeView()
        } else {
            setSignInView()
        }
    }
    
    @objc func pressed1() {
        guard let url = URL(string: "https://cafeteria-barcode-generator.herokuapp.com") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func pressed2() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.tmpErrorViewBottom.constant += (300 + bottomSafeAreaHeight)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.tmpErrorView = nil
        })
    }
    
    func setBarcodeView() {
        BV = BarcodeView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: UIScreen.main.bounds.size.height - 26 - 66 - 30))
        if UIScreen.main.bounds.size.height <= 568.0 {
            let descOriginFrame = BV.desc.frame
            BV.descTitle.alpha = 0
            BV.desc.frame = CGRect(x: descOriginFrame.origin.x, y: descOriginFrame.origin.y - 94, width: descOriginFrame.width, height: descOriginFrame.height)
        }
        
        BV.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.BV.alpha = 1
        })
        
        BV.barcodeNumber.text = userPreferences.getBarcode()
        BV.barcodeImageView.image = generateBarcode(from: userPreferences.getBarcode() ?? "")
        loginBtn.setTitle("로그아웃", for: .normal)
        bottomView.addSubview(BV)
    }
    
    func setSignInView() {
        IDV = IDView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: UIScreen.main.bounds.size.height - 26 - 66 - 30))
        IDV.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.IDV.alpha = 1
        })
        
        bottomView.addSubview(IDV)
        
        IDV.id_field.textContentType = .username
        IDV.pw_field.delegate = self
        
        idTF = IDV.id_field
        pwTF = IDV.pw_field

        loginBtn_y = loginBtn.frame.origin.y
       
        loginBtn.setTitle("로그인", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @objc func pressed(sender: UIButton!) {
        guard let url = URL(string: "http://portal.inu.ac.kr") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userPreferences.isBarcode() == false {
            if self.IDV.id_field.isFirstResponder {
                self.IDV.id_field.resignFirstResponder()
            } else if self.IDV.pw_field.isFirstResponder {
                self.IDV.pw_field.resignFirstResponder()
            }
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if userPreferences.isBarcode() == false {
            if let id = idTF.text, let password = pwTF.text {
                if id == "" || password == "" {
                    showErrorMsg(string: "아이디, 비밀번호를 다시 확인하세요.")
                    return
                }
                alertView = SPAlertView(message: "로그인 중입니다.")
                alertView.duration = 100
                //alertView.dismissByTap = true
                alertView.haptic = .warning
                alertView.overrideUserInterfaceStyle = .light
                alertView.layer.cornerRadius = 15
                alertView.present()
                loginModel.login(id: id, password: password, auto: true)
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.BV.alpha = 0
            }, completion: { _ in
                userPreferences.removeAllUserDefaults()
                self.BV.removeFromSuperview()
                self.setSignInView()
                self.BV = nil
            })
            
            alertView = SPAlertView(message: "로그아웃 되었습니다.")
            alertView.duration = 3
            alertView.dismissByTap = true
            alertView.haptic = .warning
            alertView.overrideUserInterfaceStyle = .light
            alertView.layer.cornerRadius = 15
            alertView.present()
        }
    }
    
    func showErrorMsg(string: String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.errorMsgLabel.alpha = 0
        }, completion: { _ in
            self.errorMsgLabel.text = string
            UIView.animate(withDuration: 0.5, animations: {
                self.errorMsgLabel.alpha = 1
            })
        })
    }
}


extension FloatingViewController: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        if code == loginModel._login {
            if let result = resultData as? LoginObject {
                errorMsgLabel.text = ""
                
                if let barcode = result.barcode {
                    isSignedIn = true;
                    userPreferences.saveBarcode(barcode: barcode)
                }
                
                if let token = result.token {
                    userPreferences.saveToken(token: token)
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.IDV.alpha = 0
                }, completion: { _ in
                    self.IDV.removeFromSuperview()
                    self.setBarcodeView()
                    self.IDV = nil
                    self.alertView.dismiss()
                })
            }
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        print(errorMsg)
        alertView.dismiss()
        showErrorMsg(string: errorMsg)
    }
    
    func networkFailed() {
        print("networkFailed")
        alertView.dismiss()
        showErrorMsg(string: "networkFailed")
    }
}

extension FloatingViewController {
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
                
                IDV.login_form_view.frame.origin.y -= 183
                loginBtn.frame.origin.y -= keyboardHeight
                errorMsgLabel.frame.origin.y -= keyboardHeight
                
                loginBtn_y = keyboardHeight
                cal_loginBtn_y = keyboardHeight
                
                errorMsgLabel_y = keyboardHeight
                cal_errorMsgLabel_y = keyboardHeight
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
                loginBtn.frame.origin.y += cal_loginBtn_y
                errorMsgLabel.frame.origin.y += cal_errorMsgLabel_y
                is_moved = false
            }
        }
    }
}

extension SPAlert {
    
}
