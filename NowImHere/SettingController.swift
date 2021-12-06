//
//  SettingController.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/8/27.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import SCLAlertView

class SettingController: UIViewController{
    let KTitleTop : CGFloat = 45.0
    @IBOutlet weak var updateButton     : Button_Custom!
    @IBOutlet weak var usernameField    : UITextField!
    @IBOutlet weak var passwordField    : UITextField!
    @IBOutlet weak var rePasswordField  : UITextField!
    var kScreenSize : CGSize {
        let rv = UIApplication.shared.keyWindow! as UIWindow
        let sz = rv.frame.size
        return sz
    }
    override func viewDidLoad() {
        
        setupTextfield()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           let nav = self.navigationController?.navigationBar
           nav?.barStyle = UIBarStyle.default
           nav?.tintColor = UIColor.black
           nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
           
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func  setupTextfield() {
        usernameField.text = LoginTools.getUsername()
        usernameField.isUserInteractionEnabled = false
        passwordField.isUserInteractionEnabled = true
        rePasswordField.isUserInteractionEnabled = true
        
        self.passwordField.addTarget(self, action: #selector(self.textFiledEditingChanged), for: UIControl.Event.editingChanged)
        self.rePasswordField.addTarget(self, action: #selector(self.textFiledEditingChanged), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func updataPasswordAction(_ sender: Any) {
        self.view.endEditing(true)
//        let messageObject = AlertViewMessageObject.init(title             : "",
//                                                        content           : "パスワードを更新しますか？",
//                                                        buttonTitles      : ["はい", "いいえ"],
//                                                        buttonTitlesState : [AlertViewButtonType.Black, AlertViewButtonType.Red])
//
//        AlertView.Setup(messageObject : messageObject as AnyObject,
//                        contentView   : UIWindow.getKeyWindow(),
//                        delegate      : self,
//                        autoHiden     : false).show()
        guard passwordField.text == rePasswordField.text else {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleTop : KTitleTop,
                kTitleHeight : 30.0,
                kWindowWidth : self.kScreenSize.width-100,
                kWindowHeight: 100.0,
                kTextHeight : 0.0,
                kTextViewdHeight : 0.0,
                kButtonHeight : 0.0,
                kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: AVTitleFontSize)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
                showCloseButton: false,
                showCircularIcon: true,
                shouldAutoDismiss: true,
                hideWhenBackgroundViewIsTapped: true
            )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.showError("新パスワード確認と新パスワードが一致しません。", subTitle: "")
            
            return
        }
        guard passwordField.text!.count>=6 else {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleTop : KTitleTop,
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
            _ = alert.showError("6桁以上のパスワードを入力してください", subTitle: "")
            
            return
        }
        
        guard passwordField.text!.count <= 20 else {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleTop : KTitleTop,
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
            _ = alert.showError("20桁以下のパスワードを入力してください", subTitle: "")
            
            return
        }
        UpdatePasswordViewModel.requestData(newPassword: self.rePasswordField.text!, finishCallBack: {
//            LoginTools.logout()
//            LoginTools.saveIsUseFaceID(isUseFaceID: false)
            
//            let loginController = UIStoryboard(name: "Main", bundle: nil)
//                .instantiateViewController(withIdentifier: "Login_ID")
//            loginController.modalPresentationStyle = .fullScreen
            
            
//                self.dismiss(animated: false, completion: nil)
        })
//        LoginTools.logout()
//        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login_ID")
//        loginController.modalPresentationStyle = .fullScreen
////                self.present(loginController, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop : KTitleTop,
            kTitleHeight : 30.0,
            kWindowWidth : self.kScreenSize.width-100,
            kTextHeight : 0.0,
            kTextViewdHeight : 0.0,
            kButtonHeight : 65,
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: AVTitleFontSize)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
            showCloseButton: false,
            showCircularIcon: false,
            shouldAutoDismiss: true,
            hideWhenBackgroundViewIsTapped: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let color1 = UIColor.init(red: 89/255, green: 95/255, blue: 144/255, alpha: 1)
        let icon = UIImage(named:"yonghu.png")
        let color = UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        _ = alert.addButton("OK", backgroundColor:color1) {
            
            let rootVc = self.navigationController?.viewControllers[0]
            self.navigationController?.popToViewController(rootVc!, animated: true)
        }
        _ = alert.showCustom("パスワードを変更しました", subTitle: "", color: color, icon: icon!)
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
                let messageObject = AlertViewMessageObject.init(title             : "",
                                                                content           : "ログインを終了しますか？",
                                                                buttonTitles      : ["はい", "いいえ"],
                                                                buttonTitlesState : [AlertViewButtonType.Black, AlertViewButtonType.Red])
        
                AlertView.Setup(messageObject : messageObject as AnyObject,
                                contentView   : UIWindow.getKeyWindow(),
                                delegate      : self,
                                autoHiden     : false).show()
    }
    
    @objc func textFiledEditingChanged() {
        updateButton.isEnabled = true
    }
}

extension SettingController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.usernameField.resignFirstResponder()
            self.passwordField.becomeFirstResponder()
        }
        else{
            self.passwordField.resignFirstResponder()
        }
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("--textFieldDidBeginEditing--")
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
    
}


extension SettingController : BaseMessageViewDelegate {
    func baseMessageView(_ messageView: BaseMessageView, event: AnyObject?) {
        
        let mesgObj : AlertViewMessageObject = messageView.messageObject as! AlertViewMessageObject
        if mesgObj.content == "ログインを終了しますか？" {
            
            guard let num = event as? Int else {return}
            if num == 0 {
                
                LoginTools.logout()
                let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login_ID")
                loginController.modalPresentationStyle = .fullScreen
//                self.present(loginController, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            guard let num = event as? Int else {return}
            if num == 0 {
                
                guard passwordField.text!.count>=6 else {
                    return
                }
                guard rePasswordField.text!.count>=6 else {
                    return
                }
                guard passwordField.text == rePasswordField.text else {
                    return
                }
                
                UpdatePasswordViewModel.requestData(newPassword: rePasswordField.text!, finishCallBack: {
                    LoginTools.logout()
                    let loginController = UIStoryboard(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "Login_ID")
                    loginController.modalPresentationStyle = .fullScreen
//                    self.present(loginController, animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func baseMessageViewWillAppear(_ messageView: BaseMessageView) {
        
    }
    
    func baseMessageViewDidAppear(_ messageView: BaseMessageView) {
        
    }
    
    func baseMessageViewWillDisappear(_ messageView: BaseMessageView) {
        
    }
    
    func baseMessageViewDidDisappear(_ messageView: BaseMessageView) {
        
    }
    
    
}


