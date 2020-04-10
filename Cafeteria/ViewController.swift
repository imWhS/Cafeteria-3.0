//
//  ViewController.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/03/26.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController, FloatingPanelControllerDelegate {
    @IBOutlet var cardViewBg: UIView!
    @IBOutlet var day_tab: UIView!
    var fpc: FloatingPanelController!
    var is_first = true
    var VC: UIViewController!
    @IBOutlet var load_view_bg: UIView!
    @IBOutlet var main_title: UIView!
    @IBOutlet var load_title: UIView!
    @IBOutlet var info_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        main_title.alpha = 0
        cardViewBg.alpha = 0
        day_tab.alpha = 0
        
        self.navigationController?.navigationBar.alpha = 0
        
        /*
         Card View 영역 초기화
         */
        
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        
        let common_width = self.cardViewBg.frame.width - 100
        let common_height = self.cardViewBg.frame.height - 55 - bottomSafeAreaHeight
        
        let horizontalScrollView =  ASHorizontalScrollView(frame: CGRect(x: 0, y: 0, width: self.cardViewBg.frame.width, height: self.cardViewBg.frame.height))
        horizontalScrollView.defaultMarginSettings = .init(leftMargin: 35, miniMarginBetweenItems: 5, miniAppearWidthOfLastItem: 30)
        //horizontalScrollView.uniformItemSize = CGSize(width: self.cardViewBg.frame.width * 0.7, height: self.cardViewBg.frame.height * 0.85)
        horizontalScrollView.uniformItemSize = CGSize(width: common_width, height: common_height)
        horizontalScrollView.setItemsMarginOnce()
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.indicatorStyle = .black
        
        for _ in 1...7 {
            let menu = CustomView(frame: CGRect(x: 0, y: 0, width: common_width, height: common_height))
            //menu.world_table.estimatedRowHeight = 50
            //menu.world_table.rowHeight = UITableView.automaticDimension
            
            horizontalScrollView.addItem(menu)
        }
        
        self.cardViewBg.addSubview(horizontalScrollView)
        
        /*
         Floating Panel 영역 초기화
         */
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        guard let VC = self.storyboard?.instantiateViewController(identifier: "FloatingViewController") as? FloatingViewController else { return }
        fpc.set(contentViewController: VC)
        fpc.addPanel(toParent: self)
        
        self.view.bringSubviewToFront(load_view_bg)
        self.view.bringSubviewToFront(load_title)
        fpc.view.alpha = 0
        self.load_title.alpha = 0
        self.info_btn.alpha = 0

        UIView.animate(withDuration: 1.5, animations: {
            self.load_title.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                //self.load_view_bg.alpha = 0
                self.load_title.frame = CGRect(x: 32, y: 50 + topSafeAreaHeight, width: 230, height: 98)
                self.load_view_bg.frame = CGRect(x: 0, y: -(UIScreen.main.bounds.size.height) + 223, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: { _ in
                self.load_view_bg.alpha = 0
                UIView.animate(withDuration: 1, animations: {
                    self.main_title.alpha = 1
                    self.cardViewBg.alpha = 1
                    self.day_tab.alpha = 1
                    self.fpc.view.alpha = 1
                    self.info_btn.alpha = 1
                }, completion: { _ in
                    self.view.sendSubviewToBack(self.load_view_bg)
                    self.view.sendSubviewToBack(self.load_title)
                })
            })
        })
    }
    
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
