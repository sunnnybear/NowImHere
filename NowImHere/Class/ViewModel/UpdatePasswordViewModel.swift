//
//  UpdatePasswordViewModel.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/3.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

class UpdatePasswordViewModel: NSObject {

}

extension UpdatePasswordViewModel {
    
    class func requestData(newPassword : String,finishCallBack :@escaping ()->()) {
        
        let now             = Date().nowTimeStamp
        let dateStr         = String().getJSONStringFromDictionary(dictionary: ["user_id"      : LoginTools.getUsername() ,
            "password"      : LoginTools.getPassword() ,
            "time"          : now,
            "employee_no"   : LoginTools.getEmployeeNo(),
            "client_cd"     : LoginTools.getClientCd(),
            "dbclientcd"    : LoginTools.getDbClientCd(),
            "data"          : ["password":newPassword]])
        let sign : String   = "123555aaa8sdfasdfasdf" + dateStr
        let signMD5         = String().md5String(str: sign)
        let signValue       = String().toBase64(string: signMD5)
//        let url           = "https://202.226.78.21/Attence/API/SSAPI.do?method=webAppPwdUpdate"
        let url             = String().getUrlAdress() + "API/SSAPI.do?method=webAppPwdUpdate"
        let para            = ["dataStr": dateStr,"sign": signValue!]
        
        NetworkTools.requestDate(URLString: url, type:.get,parameters: para, finishedCallback: { (result) in
            
            guard let resultDic = result as? [String : Any] else { return }
            guard let code = resultDic["code"] as? String else { return }
            
            if code == "0" {
                print("update Success")
//                LoginTools.logout()
                finishCallBack()
            }
            else{
                print("update Faild")
            }
        })
        
    }
    
}
