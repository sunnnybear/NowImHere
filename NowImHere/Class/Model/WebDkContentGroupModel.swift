//
//  WebDkContentGroupModel.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

class WebDkContentGroupModel: NSObject {
    
    @objc var webDKContent : [[NSString : NSObject]]? {
        didSet {
            guard let webDKContent = webDKContent else {return}
            for dict in webDKContent {
                contentModels.append(WebDKContentModel(dict: dict as [String : NSObject]))
            }
        }
    }
    
    @objc var webDKDetailList : [[NSString : NSObject]]? {
        didSet {
            guard let webDKDetailList = webDKDetailList else {return}
            for dict in webDKDetailList {
                detailListModels.append(WebDKDetailListModel(dict: dict as [String : NSObject]))
            }
        }
    }
    @objc var btnKind : String?
    
    lazy var contentModels : [WebDKContentModel] = [WebDKContentModel]()
    lazy var detailListModels : [WebDKDetailListModel] = [WebDKDetailListModel]()
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
