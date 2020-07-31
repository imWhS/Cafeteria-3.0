Cafeteria 3
=============
인천대학교 교내 식당 관련 정보 및 재학생 인증 서비스 제공 애플리케이션

## 클라이언트 다운로드 및 설치
App Store 링크: https://apps.apple.com/kr/app/inu-카페테리아/id1272600111

## 주요 기능
1. 교내 학생 식당 주간 운영 정보 제공  
    제 1 학생 식당, 사범대 식당, 2호관 식당, 제 1 기숙사 식당, 27호관 식당에 대해 운영 시간, 식단을 제공합니다. 
2. 재학생 인증 바코드 제공  
    인천대학교 포털 계정으로 로그인 한 사용자에 대해 매장에서 재학생으로 인증할 수 있는 바코드를 제공합니다.
3. ~~학생 식당 별 번호 호출 알림 제공~~  
    지원 예정입니다. 

## 사용 라이브러리
* [PMSuperButton](https://github.com/pmusolino/PMSuperButton)  
    주요 UIButton 터치 시 물리적으로 눌리는(작아졌다가 커지는) 효과를 빠르게 구현하기 위해 사용했습니다.  
    *8월 초까지 직접 구현 예정 목표*  
* [TextfieldEffects](https://github.com/raulriera/TextFieldEffects)  
    학생 인증 바코드 활성화를 위해 아이디, 비밀번호 입력 시 UITextField의 선택된 효과를 빠르게 구현하기 위해 사용했습니다.  
    *8월 초까지 직접 구현 예정 목표*  
* [AppStoreStyleHorizontalScrollView](https://github.com/terenceLuffy/AppStoreStyleHorizontalScrollView)  
    교내 학생 식당 관련 정보를 제공하는 카드 형태의 custom UIView 여러 개를 좌, 우로 하나씩 넘겨볼 수 있도록 구현하기 위해 사용했습니다. 

## 버전 변경 사항
* 3.0  
    첫 릴리즈  
* 3.0.1  
    학생 인증 바코드 관련 서버 접속 문제 해결, 바코드 발급 우회 경로 안내 팝업 추가

## 개발자 정보
* 손원희(imWhS / dnjsgml1230@gmail.com)  
    iOS 클라이언트 개발, iOS 클라이언트 UX/UI 디자인
* 송병준  
    안드로이드 클라이언트 개발, 서버 개발
