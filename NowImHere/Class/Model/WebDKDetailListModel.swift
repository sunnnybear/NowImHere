//
//  webDKdetailListModel.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/9.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

class WebDKDetailListModel: NSObject {
    @objc var start_time : String = ""
    @objc var button_kind : String = ""
    @objc var end_time : String = ""
    @objc var time : String = ""
    @objc var East : String = ""
    @objc var Noth : String = ""
    @objc var address : String = ""
    @objc var position : String = ""
    @objc var position_local : String = ""

    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
