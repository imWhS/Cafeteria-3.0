//
//  ExtString.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/04/14.
//  Copyright © 2020 손원희. All rights reserved.
//

extension String {
    
    static var noServer: String {
        return "서버에 접속할 수 없습니다."
    }
    
    static var logout: String {
        return "정말 로그아웃 하시겠습니까?"
    }
    
    static var cancel_num: String {
        return "대기번호를 초기화하면 알림이 오지 않습니다. 초기화 하시겠습니까?"
    }
    
    static var stuinfo_fail: String {
        return "학생 정보를 불러올 수 없습니다. 다시 로그인 해주세요."
    }
    
    static var complete_num: String {
        return "주문하신 메뉴가 완료되었습니다. 카운터에서 받아가세요"
    }
    
    static var update: String {
        return "스토어에 새 버전이 올라왔습니다. 업데이트해주세요."
    }
    
    static var login_failed: String {
        return  "로그인에 실패했습니다."
    }
    
    static var no_barcode: String {
        return "바코드 정보 오류. 다시 로그인해주세요."
    }
    
    static var no_code: String {
        return "식당 정보 오류. 다시 로그인해주세요."
    }
    
    static var no_stuinfo: String {
        return "학생 정보 오류. 다시 로그인해주세요."
    }
    
    static var appStore: String {
        return "itms://itunes.apple.com/kr/app/id1272600111"
    }
    
    static var csrSuc: String {
        return "문의사항이 접수되었습니다"
    }
    
    static var checkId: String {
        return "아이디, 비밀번호를 확인해주세요."
    }
    
    static var noContents: String {
        return "내용이 입력되지 않았습니다"
    }
    
    static var noNumber: String {
        return "번호를 입력해주세요."
    }
    
    static var fail_version: String {
        return "버전 정보를 받아오는 데 실패했습니다. 다시 시도해주세요."
    }
    
    static var noToken: String {
        return "토큰이 만료되었습니다. 다시 로그인해주세요."
    }
    
    static var dbERROR: String {
        return "서버 DB 오류"
    }
    
    static var noAlarm: String {
        return "해당 식당은 알림을 지원하지 않습니다."
    }
}
