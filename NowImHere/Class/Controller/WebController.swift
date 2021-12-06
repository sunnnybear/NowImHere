//
//  WebController.swift
//  NowImHere
//
//  Created by 韩云鹏 on 2020/9/16.
//  Copyright © 2020 杉田浩隆. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController,WKUIDelegate, WKNavigationDelegate {
    var urlHost : String? = "https://kintai-ex.eee-secure.jp/NAUI/"
//        var urlHost : String? = "https://pan.baidu.com"
    var webView: WKWebView!
    var progressView : UIProgressView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        let userContentController = WKUserContentController()
        webConfiguration.userContentController = userContentController
        let processPool = WKProcessPool()
        webConfiguration.processPool = processPool
        let cookieScript = WKUserScript(source: self.cookieJavaScriptString(), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(cookieScript)
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        var navigationH : CGFloat = 64.0
        
        if isiPhoneXScreen() {
            navigationH = CGFloat(64.0 + additionaliPhoneXTopSafeHeight - 9.0)
        }
        
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(navigationH), width: UIScreen.main.bounds.width, height: 1))
        self.progressView.tintColor = UIColor.systemBlue      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        self.progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);

        view = webView
        view.addSubview(progressView)
        view.bringSubviewToFront(self.progressView) // 将进度条至于最顶层
    }
    
    func isiPhoneXScreen() -> Bool {

           guard#available(iOS 11.0, *) else {

               return false

           }

           let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0

           print("是不是--->\(isX)")

           return isX

       }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            //  加载进度条
            if keyPath == "estimatedProgress"{
                progressView.alpha = 1.0
                print(self.webView.estimatedProgress)
                progressView.setProgress(Float((self.webView.estimatedProgress) ), animated: true)
                if (self.webView.estimatedProgress )  >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                        self.progressView.alpha = 0
                    }, completion: { (finish) in
                        self.progressView.setProgress(0.0, animated: false)
                    })
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        let myURL = URL(string:"https://kintai-ex.eee-secure.jp/NAUI/")
//        let myURL = URL(string:"https://pan.baidu.com")
        
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func cookieJavaScriptString() -> String {
        var cookieString = String()
        let userDefault = UserDefaults.standard
        guard let cookieDic : [String : [HTTPCookiePropertyKey : Any]] = userDefault.object(forKey: self.urlHost!) as? [String : [HTTPCookiePropertyKey : Any]] else {return ""}
        for (_,value) in cookieDic {
            let cookie = HTTPCookie(properties: value)
            let excuteJSString = String("document.cookie='\(cookie?.name)=\(cookie?.value)';")
            cookieString.append(excuteJSString)
        }
        return cookieString
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.urlHost = navigationAction.request.url?.host ?? ""
        if self.urlHost == "" {
            if navigationAction.request.allHTTPHeaderFields!["Cookie"] == nil {
                decisionHandler(.cancel)
                self.loadRequestWithString(url: navigationAction.request.url!)
            }
            else {
                decisionHandler(.allow)
            }
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    
    
    func loadRequestWithString(url: URL) {
        var cookieValue = String()
        let userDefault = UserDefaults.standard
        var cookieDic : [String : [HTTPCookiePropertyKey : Any]] = userDefault.object(forKey: self.urlHost!) as! [String : [HTTPCookiePropertyKey : Any]]
        if self.urlHost != nil {
            cookieDic = userDefault.object(forKey: self.urlHost!) as! [String : [HTTPCookiePropertyKey : Any]]
        }
        
        for (_,value) in cookieDic {
            let cookie = HTTPCookie(properties: value)
            let appendString = "\(String(describing: cookie?.name))=\(String(describing: cookie?.value))"
            cookieValue.append(appendString)
        }
        let request = NSMutableURLRequest(url: url)
        request.addValue(cookieValue, forHTTPHeaderField: "Cookie")
        self.webView.load(request as URLRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let userDefaults = UserDefaults.standard
        guard var cookieDic : [String : [HTTPCookiePropertyKey : Any]] = userDefaults.object(forKey: self.urlHost!) as? [String : [HTTPCookiePropertyKey : Any]] else {decisionHandler(.allow); return}
        let response : HTTPURLResponse = navigationResponse.response as! HTTPURLResponse
        let cookies : [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: response.allHeaderFields as! [String : String], for: response.url!)
        for cookie in cookies {
            cookieDic[cookie.name] = cookie.properties
        }
        userDefaults.setValue(cookieDic, forKey: self.urlHost!)
        decisionHandler(.allow)
        
    }
    
    deinit {
            self.webView?.removeObserver(self, forKeyPath: "estimatedProgress")
            self.webView?.uiDelegate = nil
            self.webView?.navigationDelegate = nil
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
}



