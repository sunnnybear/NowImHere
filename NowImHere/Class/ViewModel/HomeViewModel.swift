//
//  HomeButtonViewModel.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewModel {
    
    var homeButtonState : String? = nil
    var webContents     = [Dictionary<String, Any>]()
    var endTime         = ""
    var startTime       = ""
    var articleArray : Array<[String : String]>?
    
    var homeGroupModel : WebDkContentGroupModel = WebDkContentGroupModel(dict: [:])
    
}

extension HomeViewModel {
    
    func requestData (finishCallBack :@escaping ()->()) {
        
//        let url = "https://202.226.78.21/Attence/API/SSAPI.do?method=webAppShowDK"
        let url = String().getUrlAdress() + "API/SSAPI.do?method=webAppShowDK"
        let now = Date().nowTimeStamp
        let dic = ["user_id" : LoginTools.getUsername(),
                   "password" : LoginTools.getPassword(),
                   "employee_no" : LoginTools.getEmployeeNo(),
                   "client_cd" : LoginTools.getClientCd(),
                   "dbclientcd" : LoginTools.getDbClientCd(),
                   "time" : now]
        let jsonStr = String().getJSONStringFromDictionary(dictionary: dic as NSDictionary)
        let sign : String = "123555aaa8sdfasdfasdf" + jsonStr
        let md5Sign = String().md5String(str: sign)
        let bata64 = String().toBase64(string: md5Sign)
        
        NetworkTools.requestDate(URLString: url, type: .get, parameters: ["dataStr" : jsonStr, "sign" : bata64!]) { (result) in
            
            guard let resultDic = result as? [String : Any] else { return }
            guard let code = resultDic["code"] as? String else { return }
            
            if code == "0" {
                guard let data          = resultDic["data"] as? [String : Any] else { return }
                guard let btnkind       = data["btnKind"] as? String else {return}
//                guard let articleArray  = data["infoList"] as? Array<[String : String]> else {return}

//                guard let webContents   = data["webDKContent"] as? [[String : NSObject]] else {return}
                print("*** resultDic")
                print(resultDic["data"]!)
                let contentGroups       = WebDkContentGroupModel(dict: data as! [String : NSObject])
                
                self.homeGroupModel     = contentGroups;
                self.homeButtonState    = btnkind
//                self.webContents        = webContents
//                self.startTime          = data["StartTime"] as! String
//                self.endTime            = data["EndTime"] as! String
                self.articleArray       = data["infoList"] as? Array<[String : String]>
            }
            else{
                print("HomeVM request Faild")
            }
            finishCallBack()
        }
        
    }
    
    
}
