//
//  ShowTextModel.swift
//  Swift-Animations
//
//  Created by YouXianMing on 16/8/30.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

class ShowTextModel: NSObject {
    
    var inputTitleString   : String?
    var inputDateString   : String?
    var inputString        : String?
    var expendStringHeight : CGFloat?
    var normalStringHeight : CGFloat?
    var titleStringHeight  : CGFloat?
    
    convenience init(_ inputString : String, inputTitle : String, inputDate : String) {
        
        self.init()
        self.inputString = inputString
        self.inputTitleString = inputTitle
        self.inputDateString = inputDate

    }
}
