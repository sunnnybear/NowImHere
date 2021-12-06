//
//  Date-Extension.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import Foundation

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var nowTimeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
}
