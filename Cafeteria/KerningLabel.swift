//
//  KerningLabel.swift
//  Cafeteria
//
//  Created by 손원희 on 2020/06/13.
//  Copyright © 2020 손원희. All rights reserved.
//

import UIKit

@IBDesignable
class KerningLabel: UILabel {

    @IBInspectable var kerning: CGFloat = 0.0 {
        didSet {
            if attributedText?.length == nil { return }

            let attrStr = NSMutableAttributedString(attributedString: attributedText!)
            let range = NSMakeRange(0, attributedText!.length)
            attrStr.addAttributes([NSAttributedString.Key.kern: kerning], range: range)
            attributedText = attrStr
        }
    }
}
