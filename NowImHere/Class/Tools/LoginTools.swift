//
//  LoginTools.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/8/29.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

class LoginTools: NSObject {
    
    static let StrUsernameKey   :String = "username"
    static let StrPasswordKey   :String = "password"
    static let StrEmployKey     :String = "employee_no"
    static let StrLoginStateKey :String = "StrLoginState"
    static let StrClientCdKey   :String = "StrClientCd"
    static let StrDbClientCdKey :String = "StrDbClientCd"
    static let StrMenuNameKey   :String = "StrMenuNameKey"
    static let StrClientNameKey :String = "StrClientNameKey"
    
    static let StrIsAutoLoginKey:String = "StrIsAutoLogin"
    static let StrIsUseFaceIDKey:String = "StrIsUseFaceID"
    static let StrLoginState    :String = "StrLoginState"

    class func saveUsernameAndPasswordAndEmployeeNo(username : String,password : String,employeeNo : String,client_cd:String,dbclient_cd:String, menu_name : String, client_name : String) {
//        let StrUsernameKey:String = "username"
//        let StrPasswordKey:String = "password"
//        let StrEmployKey:String = "employee_no"
//        let StrLoginStateKey:String = "StrLoginState"
//        let StrClientCdKey:String = "StrClientCd"
//        let StrDbClientCdKey:String = "StrDbClientCd"
//        let StrMenuNameKey:String = "StrMenuNameKey"
//        let StrClientNameKey:String = "StrClientNameKey"

        UserDefaults.standard.setValue(username, forKey: StrUsernameKey)
        UserDefaults.standard.setValue(password, forKey: StrPasswordKey)
        UserDefaults.standard.setValue(employeeNo, forKey: StrEmployKey)
        UserDefaults.standard.setValue(client_cd, forKey: StrClientCdKey)
        UserDefaults.standard.setValue(dbclient_cd, forKey: StrDbClientCdKey)
        UserDefaults.standard.setValue(menu_name, forKey: StrMenuNameKey)
        UserDefaults.standard.setValue(client_name, forKey: StrClientNameKey)

        UserDefaults.standard.setValue(true, forKey: StrLoginStateKey)
        UserDefaults.standard.synchronize()
    }
    
    class func saveIsAutoLogin (isAutoLogin:Bool){
//        let StrIsAutoLoginKey:String = "StrIsAutoLogin"
        UserDefaults.standard.setValue(isAutoLogin, forKey: StrIsAutoLoginKey)
        UserDefaults.standard.synchronize()
    }
    class func saveIsUseFaceID(isUseFaceID:Bool){
//        let StrIsUseFaceIDKey:String = "StrIsUseFaceID"
        UserDefaults.standard.setValue(isUseFaceID, forKey: StrIsUseFaceIDKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getIsUseFaceID() -> Bool {
//        let StrIsUseFaceIDKey:String = "StrIsUseFaceID"
        let isUseFaceID = UserDefaults.standard.bool(forKey: StrIsUseFaceIDKey)
        return isUseFaceID
    }
    
    class func getIsAutoLogin() -> Bool {
//        let StrIsAutoLoginKey:String = "StrIsAutoLogin"
        let isAutoLogin = UserDefaults.standard.bool(forKey: StrIsAutoLoginKey)
        return isAutoLogin
    }
    class func getMenuName() -> String {
//        let StrMenuNameKey:String = "StrMenuNameKey"
        let MenuName = UserDefaults.standard.string(forKey: StrMenuNameKey)
        return String(MenuName ?? "")
    }
    class func getClientName() -> String {
//        let StrClientNameKey:String = "StrClientNameKey"
        let ClientName = UserDefaults.standard.string(forKey: StrClientNameKey)
        return String(ClientName ?? "")
    }
    class func getClientCd() -> String {
//        let StrClientCdKey:String = "StrClientCd"
        let clientCd = UserDefaults.standard.string(forKey: StrClientCdKey)
        return String(clientCd ?? "")
    }
    class func getDbClientCd() -> String {
//        let StrDbClientCdKey:String = "StrDbClientCd"
        let dbClientCd = UserDefaults.standard.string(forKey: StrDbClientCdKey)
        return String(dbClientCd ?? "")
    }
    class func getUsername() -> String {
//        let StrUsernameKey:String = "username"
        
        let storedUsername = UserDefaults.standard.string(forKey: StrUsernameKey)
        
        return String(storedUsername ?? "")
    }
    
    class func getPassword() -> String {
//        let StrPasswordKey:String = "password"
        
        let storedPassword = UserDefaults.standard.string(forKey: StrPasswordKey)
        
        return String(storedPassword ?? "")
    }
    
    class func getEmployeeNo() -> String {
//        let StrEmployKey:String = "employee_no"
        
        let storedEmployKey = UserDefaults.standard.string(forKey: StrEmployKey)
        
        return String(storedEmployKey ?? "")
    }
    
    class func getLoginState() -> Bool {
//        let StrLoginState:String = "StrLoginState"
        
        let storedLoginState = UserDefaults.standard.bool(forKey: StrLoginState)
        
        return storedLoginState
    }
    
    class func logout() {
        let StrLoginState:String = "StrLoginState"
//        let StrPasswordKey:String = "password"
//        let StrEmployKey:String = "employee_no"
        
        UserDefaults.standard.setValue(false, forKey: StrLoginState)
//        UserDefaults.standard.setValue("", forKey: StrPasswordKey)
//        UserDefaults.standard.setValue("", forKey: StrEmployKey)
        UserDefaults.standard.synchronize()
    }
}
