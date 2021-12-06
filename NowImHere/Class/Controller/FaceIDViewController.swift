//
//  FaceIDViewController.swift
//  NowImHere
//
//  Created by 韩云鹏 on 2020/9/22.
//  Copyright © 2020 杉田浩隆. All rights reserved.
//

import UIKit
import LocalAuthentication

@available(iOS 11.0, *)
@available(iOS 11.2, *)
class FaceIDViewController: UIViewController {

    @IBOutlet weak var faceIDSwitch: UISwitch!
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        switch self.justSupportBiometricsType() {
        case .faceID:
            touchIDSwitch.isEnabled = false
            if LoginTools.getIsUseFaceID() {
                self.faceIDSwitch.isOn = true
                self.touchIDSwitch.isOn = false
            }
            else{
                self.faceIDSwitch.isOn = false
                self.touchIDSwitch.isOn = false

            }
        case .touchID:
            faceIDSwitch.isEnabled = false
            if LoginTools.getIsUseFaceID() {
                self.faceIDSwitch.isOn = false
                self.touchIDSwitch.isOn = true
            }
            else{
                self.faceIDSwitch.isOn = false
                self.touchIDSwitch.isOn = false

            }
        default:
            touchIDSwitch.isEnabled = false
            faceIDSwitch.isEnabled = false
        }
        
//        if LoginTools.getIsUseFaceID() {
//            self.faceIDSwitch.isOn = true
//            self.touchIDSwitch.isOn = true
//        }
//        else{
//            self.faceIDSwitch.isOn = false
//            self.touchIDSwitch.isOn = false
//
//        }
        
    }
    
    @IBAction func faceIDAction(_ sender: Any) {
        if faceIDSwitch.isOn {
            LoginTools.saveIsUseFaceID(isUseFaceID: true)
        }
        else{
            LoginTools.saveIsUseFaceID(isUseFaceID: false)
        }
    }
    @IBAction func touchIDAction(_ sender: Any) {
        if touchIDSwitch.isOn {
            LoginTools.saveIsUseFaceID(isUseFaceID: true)
        }
        else{
            LoginTools.saveIsUseFaceID(isUseFaceID: false)
        }
    }
    
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
    
}
