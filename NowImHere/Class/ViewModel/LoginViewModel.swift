//
//  LoginViewModel.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import Alamofire
import CommonCrypto

class LoginViewModel{

}

extension LoginViewModel {
    
    class func requestDataWithUserNameAndPassword(Username : String, Password : String,finishCallback : @escaping(_ msg:String)->()){
        
        let now             = Date().nowTimeStamp
        let dateStr         = String().getJSONStringFromDictionary(dictionary: ["user_id": Username ,"password" : Password , "time" : now])
        let sign : String   = "123555aaa8sdfasdfasdf" + dateStr
        let signMD5         = String().md5String(str: sign)
        let signValue       = String().toBase64(string: signMD5)
//        let url           = "https://202.226.78.21/Attence/API/SSAPI.do?method=webAppLogin"
        let url             = String().getUrlAdress() + "API/SSAPI.do?method=webAppLogin"

        let para            = ["dataStr": dateStr,"sign": signValue!]
        
        NetworkTools.requestDate(URLString: url, type:.get, parameters: para, finishedCallback: { (result) in
            
            guard let resultDic = result as? [String : Any] else { return }
            guard let code      = resultDic["code"] as? String else { return }
            guard let message   = resultDic["message"] as? String else { return }
            if code == "0" {
                print("Login Success")
                let dataDic             = resultDic["data"] as! [String : String]
                guard let clientcd      = dataDic["client_cd"] else { return }
                guard let dbclient_cd   = dataDic["dbclientcd"] else { return }
                guard let menuName      = dataDic["user_name"] else { return }
                guard let clientName    = dataDic["client_name"] else { return }

                
                LoginTools.saveUsernameAndPasswordAndEmployeeNo(username: Username, password: Password, employeeNo: dataDic["employee_no"]! ,client_cd: clientcd,dbclient_cd:dbclient_cd,menu_name: menuName,client_name: clientName)
            }
            else{
                LoginTools.logout()
                print("Login Faild")
            }
            finishCallback(message)
        })
    }
}
