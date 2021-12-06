//
//  WebDKContentModel.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

class WebDKContentModel: NSObject {
    @objc var id : String = ""
    @objc var name : String = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
//    override func setValue(_ value: Any?, forKey key: String) {
//    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
