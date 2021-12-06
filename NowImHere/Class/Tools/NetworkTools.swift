//
//  NetworkTools.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/8/28.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    
    // 网络请求
    class func requestDate(URLString : String,type : MethodType,parameters : [String : Any]? = nil, finishedCallback : @escaping (_ result : Any)->() ){
        
        NetworkTools.validateHTTPS()
        
//        let manager = SessionManager.default
//        manager.delegate.sessionDidReceiveChallenge = {
//            session,challenge in
//            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
//        }
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            guard let result = response.result.value  else {
                print(response.result.error as Any)
                finishedCallback(["message": "インターネットエラーを要請します。", "code": "-3"])
                return
            }
            
            guard let resultDic = result as? [String : Any] else { return }
            
            print(resultDic)
            
            finishedCallback(resultDic)
        }
    }
    
    // 支持https
    class func validateHTTPS(){
        
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
}
