//
//  LoginController.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/8/27.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//
import TransitionButton
import UIKit
import LocalAuthentication
import SCLAlertView

class LoginController: UIViewController{
    
    @IBOutlet weak var nextLoginText    : UILabel!
    @IBOutlet weak var line2            : UIView!
    @IBOutlet weak var line1            : UIView!
    
    @IBOutlet weak var logoImageView    : UIImageView!
    @IBOutlet weak var logoLabel        : UILabel!
    @IBOutlet weak var faceIDBtn        : UIButton!
    @IBOutlet weak var loginButton      : TransitionButton!
    
    @IBOutlet weak var usernameField    : UITextField!
    
    @IBOutlet weak var passwordField    : UITextField!
    
    @IBOutlet weak var passwordWithLoginBtn: NSLayoutConstraint!
    
    @IBOutlet weak var selectBorderView : UIView!
    
    @IBOutlet weak var selectBtn        : UIButton!
    
    var isAutoLogin : Bool = true
    var kScreenSize : CGSize {
        let rv = UIApplication.shared.keyWindow! as UIWindow
        let sz = rv.frame.size
        return sz
    }
    override func viewDidLoad() {
        
        self.launchAnimation()
        self.setupTextfield()
        self.setupIsAutoLoginBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 自动登陆
        if LoginTools.getLoginState() && LoginTools.getIsAutoLogin(){
            LoginViewModel.requestDataWithUserNameAndPassword(Username: LoginTools.getUsername(), Password: LoginTools.getPassword()){_ in 
                let homeNaviController = UIStoryboard(name: "Main", bundle: Bundle.main)
                    .instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
                homeNaviController.modalPresentationStyle = .fullScreen
                self.present(homeNaviController, animated: true, completion: nil)
            }
        }
        else {
            self.passwordField.text = ""
        }
        self.setupIsUseFaceID()
        
    }
    
    
    //播放启动画面动画
    private func launchAnimation() {
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) {
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -(Screen.Height/2-125-70))
            self.logoLabel.transform = CGAffineTransform(translationX: 0, y: -(Screen.Height/2-125-70))
            
            self.line1.alpha            = 0.5
            self.line2.alpha            = 0.5
            self.nextLoginText.alpha    = 1
            self.selectBorderView.alpha = 1
            self.loginButton.alpha      = 1
            self.usernameField.alpha    = 1
            self.passwordField.alpha    = 1
            self.faceIDBtn.alpha        = 1
        } completion: { (finished) in }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 设置textfield
    func setupTextfield() {
        usernameField.attributedPlaceholder = NSAttributedString(string:"ユーザーID",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordField.attributedPlaceholder = NSAttributedString(string:"パスワード",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        usernameField.text = LoginTools.getUsername()
        passwordField.text = LoginTools.getPassword()
    }
    
    func setupIsAutoLoginBtn() {
        selectBorderView.layer.borderColor = UIColor.lightGray.cgColor
        selectBorderView.layer.borderWidth = 1
        selectBorderView.layer.masksToBounds = true
        if LoginTools.getIsAutoLogin() {
            self.selectBtn.backgroundColor = UIColor(red: 67/255, green: 29/255, blue: 143/255, alpha: 1)
        }
        else {
            self.selectBtn.backgroundColor = UIColor.white
        }
    }
    
    func setupIsUseFaceID(){
        if LoginTools.getIsUseFaceID() {
            self.faceIDBtn.isHidden = false
        }
        else{
            self.faceIDBtn.isHidden = true
        }
        if #available(iOS 11.211.2, *) {
            switch self.justSupportBiometricsType() {
            case .faceID:
                faceIDBtn.setTitle("FaceId ログイン", for: UIControl.State.normal)
            case .touchID:
                faceIDBtn.setTitle("TouchID ログイン", for: UIControl.State.normal)
            default: break
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @available(iOS 11.211.2, *)
    @available(iOS 11.2, *)
    func justSupportBiometricsType() -> LABiometryType {
        let context = LAContext()
        let error: NSErrorPointer = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: error) {
            guard error == nil else {
                return .none
            }
            
            return context.biometryType == .faceID ? .faceID : .touchID
            
        }
        return .none
    }
    // 下会自动登陆按钮
    @IBAction func selectbtnAction(_ sender: Any) {
        
        if LoginTools.getIsAutoLogin() {
            self.selectBtn.backgroundColor = UIColor.white
        }
        else {
            self.selectBtn.backgroundColor = UIColor(red: 67/255, green: 29/255, blue: 143/255, alpha: 1)
        }
        LoginTools.saveIsAutoLogin(isAutoLogin: !LoginTools.getIsAutoLogin())
    }
    
    @IBAction func faceIDAction(_ sender: Any) {
        // 創建 LAContext 實例
        let context = LAContext()
        // 設置取消按鈕標題
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = "Cancel"
        } else {
            // Fallback on earlier versions
        }
        // 宣告一個變數接收 canEvaluatePolicy 返回的錯誤
        var error: NSError?
        // 評估是否可以針對給定方案進行身份驗證
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // 描述使用身份辨識的原因
            let reason = "システムにログインする。"
            // 評估指定方案
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        LoginViewModel.requestDataWithUserNameAndPassword(Username: LoginTools.getUsername(), Password: LoginTools.getPassword()) { msg in
                            
                            if LoginTools.getLoginState() { // 登录成功
                                
                                self.loginButton.stopAnimation(animationStyle: .normal, completion: {
                                    
                                    let myNavigaiton = UIStoryboard(name: "Main", bundle: nil)
                                        .instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
                                    myNavigaiton.modalPresentationStyle = .fullScreen
                                    self.present(myNavigaiton, animated: true, completion: nil)
                                })
                            }
                            else{   // 登录失败
                                let appearance = SCLAlertView.SCLAppearance(
                                    kTitleTop : AVTitleTop,
                                    kTitleHeight : 30.0,
                                    kWindowWidth : self.kScreenSize.width-100,
                                    kTextHeight : 0.0,
                                    kTextViewdHeight : 0.0,
                                    kButtonHeight : 65,
                                    kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: AVTitleFontSize)!,
                                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
                                    showCloseButton: false,
                                    showCircularIcon: true,
                                    shouldAutoDismiss: true,
                                    hideWhenBackgroundViewIsTapped: true
                                )
                                let alert = SCLAlertView(appearance: appearance)
                                _ = alert.showError(msg, subTitle: "")
                                self.loginButton.stopAnimation(animationStyle: .normal, completion: {
                                    self.loginButton.setTitle("ログイン", for: UIControl.State.normal)
                                    
                                })
                            }
                        }
                        
                    }
                } else {
                    //                    DispatchQueue.main.async { [unowned self] in
                    //                        //                        self.showMessage(title: "Login Failed", message: error?.localizedDescription)
                    //                    }
                }
            }
        } else {
            //            showMessage(title: "Failed", message: error?.localizedDescription)
        }
    }
    // 登录按钮点击"
    @IBAction func loginAction(_ button: TransitionButton)  {
        //        let myNavigaiton = UIStoryboard(name: "Main", bundle: nil)
        //            .instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
        //        myNavigaiton.modalPresentationStyle = .fullScreen
        //        self.present(myNavigaiton, animated: true, completion: nil)
        
        button.startAnimation() // 2: Then start the animation when the user tap the button
        guard self.usernameField.text != "" else {button.stopAnimation(animationStyle: .shake, completion: {
            
        })
        return
        
        }
        guard self.passwordField.text != "" else {button.stopAnimation(animationStyle: .shake, completion: {
            
        })
        return
        
        }
        LoginViewModel.requestDataWithUserNameAndPassword(Username: self.usernameField.text ?? "", Password: self.passwordField.text ?? "") { msg in
            
            if LoginTools.getLoginState() { // 登录成功
                
                button.stopAnimation(animationStyle: .normal, completion: {
                    
                    let myNavigaiton = UIStoryboard(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
                    myNavigaiton.modalPresentationStyle = .fullScreen
                    self.present(myNavigaiton, animated: true, completion: nil)
                })
            }
            else{   // 登录失败
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleTop : AVTitleTop,
                    kTitleHeight : 30.0,
                    kWindowWidth : self.kScreenSize.width-100,
                    kTextHeight : 0.0,
                    kTextViewdHeight : 0.0,
                    kButtonHeight : 65,
                    kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: AVTitleFontSize)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
                    showCloseButton: false,
                    showCircularIcon: true,
                    shouldAutoDismiss: true,
                    hideWhenBackgroundViewIsTapped: true
                )
                let alert = SCLAlertView(appearance: appearance)
                _ = alert.showError(msg, subTitle: "")
                button.stopAnimation(animationStyle: .normal, completion: {
                    
                })
            }
        }
    }
    
    func loginSuccessOrFail(message : String) {
        if LoginTools.getLoginState() {     // 登录成功
            self.loginButton.stopAnimation(animationStyle: .normal, completion: {
            })
            let myNavigaiton = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
            myNavigaiton.modalPresentationStyle = .fullScreen
            self.present(myNavigaiton, animated: true, completion: nil)
        }
        else{       // 登录失败
            self.loginButton.stopAnimation(animationStyle: .normal, completion: {
            })
            let appearance = SCLAlertView.SCLAppearance(
                kTitleTop : AVTitleTop,
                kTitleHeight : 30.0,
                kWindowWidth : self.kScreenSize.width-100,
                kTextHeight : 0.0,
                kTextViewdHeight : 0.0,
                kButtonHeight : 65,
                kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: AVTitleFontSize)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
                showCloseButton: false,
                showCircularIcon: true,
                shouldAutoDismiss: true,
                hideWhenBackgroundViewIsTapped: true
            )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.showError(message, subTitle: "")
        }
    }
}

// MARK:- textField 代理方法
extension LoginController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options:[] , animations: {
            self.passwordWithLoginBtn.constant += 115
            self.view.layoutIfNeeded()
        })
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options:[] , animations: {
            self.passwordWithLoginBtn.constant -= 115
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.usernameField.resignFirstResponder()
            self.passwordField.becomeFirstResponder()
        }
        else{
            self.passwordField.resignFirstResponder()
            self.loginButton.startAnimation() // 2: Then start the animation when the user tap the button
            guard self.usernameField.text != "" else {self.loginButton.stopAnimation(animationStyle: .shake, completion: {
                
            })
            return false
            
            }
            guard self.passwordField.text != "" else {self.loginButton.stopAnimation(animationStyle: .shake, completion: {
                
            })
            return false
            
            }
            LoginViewModel.requestDataWithUserNameAndPassword(Username: self.usernameField.text ?? "", Password: self.passwordField.text ?? "") {msg in
                self.loginSuccessOrFail(message: msg)
            }
        }
        return true
    }
}

