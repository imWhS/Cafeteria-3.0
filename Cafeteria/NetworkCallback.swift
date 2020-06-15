//
//  NetworkCallback.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/14.
//  Copyright © 2020 손원희. All rights reserved.
//

protocol NetworkCallback {
    func networkResult(resultData: Any, code: String)
    func networkFailed(errorMsg: String, code: String)
    func networkFailed()
}

protocol ViewCallback {
    func passData(resultData: Any, code: String)
}
