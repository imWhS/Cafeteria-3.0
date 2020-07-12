//
//  ViewController.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/03/26.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit
import FloatingPanel
import ObjectMapper
import SPAlert
import SystemConfiguration

class MainViewController: UIViewController, FloatingPanelControllerDelegate {
    @IBOutlet var cardViewBg: UIView!
    @IBOutlet var day_tab: UIView!
    @IBOutlet var load_view_bg: UIView!
    @IBOutlet var load_title: UIView!
    @IBOutlet var info_btn: UIButton!
    @IBOutlet var current_dat: UILabel!
    
    var fpc: FloatingPanelController!
    var is_first = true
    var VC: UIViewController!
    
    var tmpNoticeView = NetworkConnectionErrorView2()
    
    var weeklyDates: [Int] = []
    let dateFormatter = DateFormatter()
    var dateToday: String = ""
    var dateFoodMenu: Int = 0
    var firstDayOfWeek: Int?
    var dayIdx = -1
    var dayStr = ""
    var isfirstLoad = true
    var trestaurants = [[DataVO]]()
    var horizontalScrollView: ASHorizontalScrollView? = ASHorizontalScrollView()
    
    var isNetworkFailed = false
    
    private lazy var networkModel: NetworkModel = {
        return NetworkModel(self)
    }()
    
    var networkConnectionErrorView: NetworkConnectionErrorView?
    var networkConnectionErrorView2: NetworkConnectionErrorView2?
    
    private var datas: [DataVO] = []
    
    @IBOutlet var dayTabMon: PMSuperButton!
    @IBOutlet var dayTabTue: PMSuperButton!
    @IBOutlet var dayTabWed: PMSuperButton!
    @IBOutlet var dayTabThu: PMSuperButton!
    @IBOutlet var dayTabFri: PMSuperButton!
    
    var feedbackGenerator: UIImpactFeedbackGenerator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    public var connectedToNetwork: Bool {
        get {
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            /* Only Working for WIFI
             let isReachable = flags == .reachable
             let needsConnection = flags == .connectionRequired
             
             return isReachable && !needsConnection
             */
            
            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)
            
            return ret
        }
    }
    
    func showNetworkErrorPage() {
        networkConnectionErrorView2 = NetworkConnectionErrorView2(frame: self.view.frame)
        networkConnectionErrorView2!.moveToPage.addTarget(self, action: #selector(rechkServerConnection), for: .touchUpInside)
        load_view_bg.addSubview(networkConnectionErrorView2!)
    }
    
    @objc func rechkNetworkStatus(sender: UIButton!) {
        if connectedToNetwork == true {
            UIView.animate(withDuration: 0.5, animations: {
                self.networkConnectionErrorView!.alpha = 0
            }, completion: { _ in
                self.initApplication()
            })
        }
    }
    
    @objc func rechkServerConnection(sender: UIButton!) {
        self.networkModel.foodplan(date: weeklyDates[dayIdx])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.bringSubviewToFront(load_view_bg)
        
        let window = UIApplication.shared.windows[0]
        
        if connectedToNetwork == false {
            networkConnectionErrorView = NetworkConnectionErrorView(frame: self.view.frame)
            networkConnectionErrorView!.chkAgainBtn.addTarget(self, action: #selector(rechkNetworkStatus), for: .touchUpInside)
            load_view_bg.addSubview(networkConnectionErrorView!)
        } else {
            initApplication()
        }
    }
    
    func initApplication() {
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        
        /*
         구동 시점 기준 월~금 날짜 정보 계산
         */
        calcWeek()
        
        /*
         Floating Panel 영역 초기화
         */
        fpc = FloatingPanelController()
        fpc.delegate = self
    
        /*
        애니메이션 관련 요소 전처리
        */
        self.view.bringSubviewToFront(load_view_bg)
        self.view.bringSubviewToFront(load_title)
        self.load_title.alpha = 0
        self.info_btn.alpha = 0
        self.cardViewBg.alpha = 0
        day_tab.alpha = 0
        fpc.view.alpha = 0
        
        /*
         요일 전환 탭 버튼 초기화
         */
        var currentDayTab = PMSuperButton()
        switch dayIdx {
        case 0: currentDayTab = dayTabMon
        case 1: currentDayTab = dayTabTue
        case 2: currentDayTab = dayTabWed
        case 3: currentDayTab = dayTabThu
        case 4, 5, 6: currentDayTab = dayTabFri
        default: print("def")
        }
        selectDayTabBtn(sender: currentDayTab)
        
        /*
         Floating View Controller 초기화
         */
        guard let VC = self.storyboard?.instantiateViewController(identifier: "FloatingViewController") as? FloatingViewController else { return }
        fpc.set(contentViewController: VC)
        fpc.addPanel(toParent: self)
    
        /*
         네트워크 서버 통신
         실행 시점 기준 토, 일요일일 경우 금요일 식단표 출력
         */
        if dayIdx == 6 {
            print("\n현재 실행 시점 기준으로 일요일이어서 금요일(\(weeklyDates[dayIdx - 2])) 식단표를 불러옵니다.")
            self.networkModel.foodplan(date: weeklyDates[dayIdx - 2])
        } else if dayIdx == 5 {
            print("\n현재 실행 시점 기준으로 토요일이어서 금요일(\(weeklyDates[dayIdx - 1])) 식단표를 불러옵니다.")
            self.networkModel.foodplan(date: weeklyDates[dayIdx - 1])
        } else {
            print("foodplan 서버 통신 시작")
            self.networkModel.foodplan(date: weeklyDates[dayIdx])
        }
    }
    
    func selectDayTabBtn(sender: PMSuperButton) {
        initDayTabBtns()
        sender.borderColor = UIColor(red: 0.92, green: 0.29, blue: 0.24, alpha: 0.00)
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = UIColor(red: 0.92, green: 0.29, blue: 0.24, alpha: 1.00)
    }
    
    func deselectDayTabBtn(sender: PMSuperButton) {
        sender.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
        sender.setTitleColor(UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.00), for: .normal)
        sender.backgroundColor = UIColor(red: 0.92, green: 0.29, blue: 0.24, alpha: 0.00)
    }
    
    func reloadDataFromServer(dateIdx: Int, sender: PMSuperButton) {
        selectDayTabBtn(sender: sender)
        print("reload firstDayOfWeek \(weeklyDates[dateIdx])")
        
        trestaurants.removeAll()
        print("서버로부터 \(weeklyDates[dateIdx]) 날짜의 식단표를 다시 불러옵니다. ")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.horizontalScrollView?.alpha = 0
        }, completion: { _ in
            self.horizontalScrollView?.removeFromSuperview()
            self.horizontalScrollView = nil
            self.horizontalScrollView = ASHorizontalScrollView(frame: CGRect(x: 0, y: 0, width: self.cardViewBg.frame.width, height: self.cardViewBg.frame.height))
            
            self.networkModel.foodplan(date: self.weeklyDates[dateIdx])
        })
    }

    func loadCardView() {
        print("loadCardView() ")
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        var common_width = self.cardViewBg.frame.width - 25 - 60
        let common_height = self.cardViewBg.frame.height - 80
        
        if UIScreen.main.bounds.size.width <= 320.0 {
            print(" - iPhone SE 및 5s 이하의 디바이스에 맞는 크기로 카드를 불러옵니다.")
            common_width = self.cardViewBg.frame.width - 25 - 60 + 15
        }
        
        horizontalScrollView?.frame = CGRect(x: 0, y: 0, width: self.cardViewBg.frame.width, height: self.cardViewBg.frame.height)
        horizontalScrollView?.defaultMarginSettings = .init(leftMargin: 25, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 30)
        horizontalScrollView?.uniformItemSize = CGSize(width: common_width, height: common_height)
        //horizontalScrollView.marginSettings_320 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 5, miniAppearWidthOfLastItem: 20)
        horizontalScrollView?.marginSettings_320 = MarginSettings(leftMargin: 25, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 25)
        horizontalScrollView?.setItemsMarginOnce()
        horizontalScrollView?.showsHorizontalScrollIndicator = false
        horizontalScrollView?.indicatorStyle = .black
        horizontalScrollView?.alpha = 0
        
        for i in 0 ..< self.trestaurants.count {
            if self.trestaurants[i].count == 0 {
                let menu = CustomView3(frame: CGRect(x: 0, y: 0, width: common_width, height: common_height))
                menu.restaurant_title?.text = self.setRestaurantTitle(number: i)
                menu.linkUICOOP.addTarget(self, action: #selector(pressed2), for: .touchUpInside)
                self.horizontalScrollView?.addItem(menu)
            } else {
                let menu = CustomView(frame: CGRect(x: 0, y: 0, width: common_width, height: common_height))
                menu.restaurant_title?.text = self.setRestaurantTitle(number: i)
                menu.restaurant_desc.text = self.setRestaurantDesc(number: i)
                menu.menus = self.trestaurants[i]
                
                menu.menuAlarm.tag = i
                menu.menuAlarm.setTitle("\(i)", for: .disabled)
                menu.menuAlarm.addTarget(self, action: #selector(pressed3), for: .touchUpInside)
                self.horizontalScrollView?.addItem(menu)
            }
        }
        
        self.cardViewBg.addSubview(self.horizontalScrollView ?? UIView())
        startAnimations()
    }
    
    @objc func pressed2(sender: UIButton!) {
        guard let url = URL(string: "https://uicoop.ac.kr:41052") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
       
    @objc func pressed3(sender: UIButton!) {
        
        let alertView = SPAlertView(message: "\(setRestaurantTitle(number: Int(sender.title(for: .disabled)!)!)) 번호 알림 지원 예정입니다.")
        alertView.duration = 3
        alertView.dismissByTap = true
        alertView.haptic = .warning
        alertView.overrideUserInterfaceStyle = .light
        alertView.layer.cornerRadius = 15
        alertView.present()
    }
    
    func initSubViews() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        let common_width = self.cardViewBg.frame.width - 100
        let common_height = self.cardViewBg.frame.height - 55
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("메뉴 수신 끝! SubViews init 시작")
        
        UIView.animate(withDuration: 0.5, animations: {
            self.load_title.alpha = 1
        }, completion: { _ in
            self.view.bringSubviewToFront(self.cardViewBg)
            self.view.bringSubviewToFront(self.info_btn)
            self.view.bringSubviewToFront(self.fpc.view)
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                self.load_title.frame = CGRect(x: 22, y: 50 + topSafeAreaHeight, width: 230, height: 98)
                self.load_view_bg.frame = CGRect(x: 0, y: -(UIScreen.main.bounds.size.height) + 223 + topSafeAreaHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: { _ in
                self.loadCardView()
                UIView.animate(withDuration: 0.3, animations: {
                    self.day_tab.alpha = 1
                    self.fpc.view.alpha = 1
                    self.info_btn.alpha = 1
                }, completion: { _ in
                    if self.isfirstLoad == true {
                        if self.dayIdx == 6 || self.dayIdx == 5 {
                            let alertView = SPAlertView(message: "주말 정보는 제공하지 않아, 금요일 정보를 불러옵니다.")
                            alertView.duration = 3
                            alertView.dismissByTap = true
                            alertView.haptic = .warning
                            alertView.overrideUserInterfaceStyle = .light
                            alertView.layer.cornerRadius = 15
                            alertView.present()
                        }
                        self.isfirstLoad = false
                    }
                })
            })
            
        })
    }
    
    func setRestaurantTitle(number: Int) -> String {
        switch number {
        case 0: return "학생식당 1코너"
        case 1: return "학생식당 2코너"
        case 2: return "학생식당 3코너"
        case 3: return "학생식당 4코너"
        case 4: return "학생식당 5코너"
        case 5: return "사범대식당"
        case 6: return "2호관식당"
        case 7: return "제1기숙사식당"
        case 8: return "27호관식당"
        default:
            return "def"
        }
    }
    
    func setRestaurantDesc(number: Int) -> String {
        switch number {
        case 0: return "\n중식 10:00 - 14:00\n코로나 19로 인한 제한 운영 중"
        case 1: return "\n중식 10:00 - 14:00\n코로나 19로 인한 제한 운영 중"
        case 2: return "\n중식 10:00 - 14:00\n코로나 19로 인한 제한 운영 중"
        case 3: return "\n중식 10:00 - 14:00\n코로나 19로 인한 제한 운영 중"
        case 4: return "\n중식 10:00 - 14:00\n코로나 19로 인한 제한 운영 중"
        case 5: return "\n중식 11:00 - 14:00\n코로나 19로 인한 제한 운영 중"
        case 6: return "\n중식 11:00 - 13:30\n석식 17:00 - 18:30\n코로나 19로 인한 제한 운영 중"
        case 7: return ""
        case 8: return ""
        default:
            return "def"
        }
    }
    
    func startAnimations() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        let common_width = self.cardViewBg.frame.width - 100
        let common_height = self.cardViewBg.frame.height - 55 - bottomSafeAreaHeight
        
        self.cardViewBg.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.cardViewBg.alpha = 1
            self.horizontalScrollView?.alpha = 1
        })
    }
    
    func getFirstDayOfWeek(current: String, dayIdx: Int) {
        for i in stride(from: dayIdx, to: -1, by: -1) {
            let before1day = Date(timeIntervalSinceNow: (-24 * Double(i)) * 60 * 60)
            let dateString = dateFormatter.string(from: before1day as Date)
            weeklyDates.append(Int(dateString)!)
        }
        
        for i in stride(from: 1, to: 7 - dayIdx, by: 1) {
            let before1day = Date(timeIntervalSinceNow: (24 * Double(i)) * 60 * 60)
            let dateString = dateFormatter.string(from: before1day as Date)
            weeklyDates.append(Int(dateString)!)
        }
        
        var j = 0
        for i in weeklyDates {
            j += 1
        }
    }
    
    func calcWeek() {
        let today = Date()
        
        dateFormatter.dateFormat = "M월 d일의"
        dateToday = dateFormatter.string(from: today as Date)
        current_dat.text = dateToday
       
        dateFormatter.dateFormat = "EEE"
        dayStr = dateFormatter.string(from: today as Date)
        dayIdx = getDayIndex(day: dayStr) //실행 시점 현재 요일 index 계산
        
        dateFormatter.dateFormat = "yyyyMMdd"
        dateToday = dateFormatter.string(from: today as Date) //실행 시점 현재 날짜 계산
        
        getFirstDayOfWeek(current: dayStr, dayIdx: dayIdx)
    }
    
    func getDayIndex(day: String) -> Int {
        switch day {
        case "Mon": return 0
        case "Tue": return 1
        case "Wed": return 2
        case "Thu": return 3
        case "Fri": return 4
        case "Sat": return 5
        case "Sun": return 6
        default:
            print("getDayIndex() : default value")
            return 6
        }
    }
    
    func classifyDatas(datas: [DataVO]) {
        for _ in 0 ..< 9 { trestaurants.append([]) }
        for data in datas {
            
            var type1str = ""
            var type2str = "   "
            
            //아침, 점심, 저녁 정보 삽입
            switch data.corner_id {
            case 2, 4, 13, 18:
                type1str = "석식"
            default:
                type1str = "중식"
            }
            
            if data.foods.hasPrefix("1-1코너") {
                let strRange2 = data.foods.index(data.foods.startIndex, offsetBy: 0) ..< data.foods.index(data.foods.startIndex, offsetBy: 5)
                data.foods.removeSubrange(strRange2)
                type2str = "\(type2str)1-1 코너"
            }
            
            if data.foods.hasPrefix("<즉석조리기기>") {
                let strRange2 = data.foods.index(data.foods.startIndex, offsetBy: 0) ..< data.foods.index(data.foods.startIndex, offsetBy: 9)
                data.foods.removeSubrange(strRange2)
                type2str = "\(type2str)2-2 코너 즉석 조리 기기"
            }
            
            if data.foods.hasPrefix("셀프라면") {
                let strRange2 = data.foods.index(data.foods.startIndex, offsetBy: 0) ..< data.foods.index(data.foods.startIndex, offsetBy: 5)
                data.foods.removeSubrange(strRange2)
                type2str = "\(type2str)셀프 라면 코너"
            }
            
            let catedata = DataVO(type1: type1str, type2: type2str, calorie: -1, corner_id: -1, foods: "", price: -1)
            
            //최종 식당 분류
            switch data.corner_id {
            case 1, 2:
                trestaurants[0].append(catedata)
                trestaurants[0].append(data)  //학생식당 1코너
            case 3, 4, 5:
                trestaurants[1].append(catedata)
                trestaurants[1].append(data)  //학생식당 2코너
            case 6:
                trestaurants[2].append(catedata)
                trestaurants[2].append(data)  //학생식당 3코너
            case 7:
                trestaurants[3].append(catedata)
                trestaurants[3].append(data)  //학생식당 4코너
            case 8:
                trestaurants[4].append(catedata)
                trestaurants[4].append(data)  //학생식당 5코너
            case 12, 13:
                trestaurants[5].append(catedata)
                trestaurants[5].append(data)  //사범대식당
            case 17, 18:
                trestaurants[6].append(catedata)
                trestaurants[6].append(data)  //2호관식당
            default:
                //restaurant 7  제 1기숙사식당
                //restaurant 8  27호관식당
                print("def")
            }
        }
    }
    
    func initDayTabBtns() {
        deselectDayTabBtn(sender: dayTabMon)
        deselectDayTabBtn(sender: dayTabTue)
        deselectDayTabBtn(sender: dayTabWed)
        deselectDayTabBtn(sender: dayTabThu)
        deselectDayTabBtn(sender: dayTabFri)
    }
    
    @IBAction func dayTabBtnMon(_ sender: PMSuperButton) {
        self.feedbackGenerator?.impactOccurred()
        reloadDataFromServer(dateIdx: 0, sender: sender)
    }
    
    @IBAction func dayTabBtnTue(_ sender: PMSuperButton) {
        self.feedbackGenerator?.impactOccurred()
        reloadDataFromServer(dateIdx: 1, sender: sender)
    }
    
    @IBAction func dayTabBtnWed(_ sender: PMSuperButton) {
        self.feedbackGenerator?.impactOccurred()
        reloadDataFromServer(dateIdx: 2, sender: sender)
    }
    
    @IBAction func dayTabBtnThu(_ sender: PMSuperButton) {
        self.feedbackGenerator?.impactOccurred()
        reloadDataFromServer(dateIdx: 3, sender: sender)
    }
    
    @IBAction func dayTabBtnFri(_ sender: PMSuperButton) {
        self.feedbackGenerator?.impactOccurred()
        reloadDataFromServer(dateIdx: 4, sender: sender)
    }
    
}

extension MainViewController {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        var bottomSafeAreaHeight: CGFloat = 0
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.windows[0]
                let safeFrame = window.safeAreaLayoutGuide.layoutFrame
                bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
            }
        return MyFloatingPanelLayout(is_First: true, btm_sa: bottomSafeAreaHeight)
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        self.view.becomeFirstResponder()
    }
    
    func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        if vc.position == .full {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            let topSafeAreaHeight = safeFrame.minY
            let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    var init_position: Bool
    var safearea_height: CGFloat
    var initialPosition: FloatingPanelPosition { return .tip }
    var supportedPositions: Set<FloatingPanelPosition> { return [.full, .tip] }
    
    init(is_First: Bool, btm_sa: CGFloat) {
        init_position = is_First
        safearea_height = btm_sa - 10
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 16.0 // A top inset from safe area
            case .half: return 216.0 // A bottom inset from the safe area
            case .tip:
                if safearea_height == -10.0 {
                    return 60.0
                } else {
                    return safearea_height + 30.0  // A bottom inset from the safe area
                }
            default: return nil // Or `case .hidden: return nil`
        }
    }
}

extension MainViewController: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        if code == networkModel._foodplan {
            
            if let result = resultData as? NSArray {
                var temp2: [DataVO] = []
                for item in result {
                    if let data = item as? NSDictionary {
                        let calorie = Int(data["calorie"] as? String ?? "0") ?? 0
                        let corner_id = data["corner-id"] as? Int ?? 0
                        let foods = (data["foods"] as? String ?? "_").replacingOccurrences(of: " ", with: "\n").replacingOccurrences(of: "*", with: " 및 ").replacingOccurrences(of: "D", with: "드레싱").replacingOccurrences(of: "신라면진라면안성탕면", with: "신라면\n진라면\n안성탕면").replacingOccurrences(of: "야채라면너구리", with: "야채라면\n너구리").replacingOccurrences(of: "짜파게티즉석라볶이", with: "짜파게티\n즉석 라볶이").replacingOccurrences(of: "(신라면너구리짜파게티)", with: "신라면\n너구리\n짜파게티").replacingOccurrences(of: "+토핑", with: "셀프 라면 토핑")
                        let price = Int(data["price"] as? String ?? "0") ?? 0
                        let obj2 = DataVO(type1: "", type2: "", calorie: calorie, corner_id: corner_id, foods: foods, price: price)
                        temp2.append(obj2)
                    }
                }
                datas = temp2
                classifyDatas(datas: temp2)
            }
        
            initSubViews()
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        NSLog("Failed! 1: \(errorMsg)")
    }
    
    func networkFailed() {
        NSLog("Failed! 2")
    }
}
