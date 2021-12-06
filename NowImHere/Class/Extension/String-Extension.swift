//
//  String-Extension.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    func getUrlAdress() -> String {
//        return "http://kintai-ex.eee-secure.jp/NAUI/"
//        return "http://42.202.130.202:9989/"
        return "https://taa.eee-secure.jp/"
    }
    
    func toBase64(string: String) -> String? {
        if let data = string.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func md5String(str:String) -> String{
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
}
