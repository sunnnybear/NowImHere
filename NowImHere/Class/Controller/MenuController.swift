//
//  MenuController.swift
//  NowImHere
//
//  Created by 韩云鹏 on 2020/9/16.
//  Copyright © 2020 杉田浩隆. All rights reserved.
//

import UIKit
import SCLAlertView

class MenuController: UIViewController{
    var articleArray          : Array<[String:String]>?
    var userName : String?
    var userCompany : String?
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var clientNameLabel: UILabel!
    var kScreenSize : CGSize {
        let rv = UIApplication.shared.keyWindow! as UIWindow
        let sz = rv.frame.size
        return sz
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameLabel.text = LoginTools.getMenuName()
        self.clientNameLabel.text = LoginTools.getClientName()
    }
    
    @IBAction func messageBtnAction(_ sender: Any) {
        let vc = ArticleViewController()
        vc.articleArray = self.articleArray
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
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
            showCloseButton: true,
            showCircularIcon: false,
            shouldAutoDismiss: true,
            hideWhenBackgroundViewIsTapped: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let color1 = UIColor.init(red: 89/255, green: 95/255, blue: 144/255, alpha: 1)
        let icon = UIImage(named:"yonghu.png")
        let color = UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        _ = alert.addButton("はい", backgroundColor:color1) {
            LoginTools.logout()
            let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login_ID")
            loginController.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true, completion: nil)
            
        }
        _ = alert.showCustom("ログインを終了しますか？", subTitle: "", color: color, icon: icon!, closeButtonTitle:"いいえ")
    }
}

