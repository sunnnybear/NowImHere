//
//  HomePickerView.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/4.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

protocol HomePickerViewDelegate : class {
    func cancelButtonAction()
    func doneButtonAction()
}

class HomePickerView: UIView {
    
    @IBOutlet weak var pickerView: UIPickerView!

    @IBOutlet weak var toolbar: UIToolbar!
    
    weak var delegate : HomePickerViewDelegate?
    
    var buttonAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame.size = CGSize(width: 280.0, height: 230.0)
        self.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        self.toolbar.layer.cornerRadius = 8
        self.toolbar.layer.borderWidth = 0
        self.toolbar.layer.masksToBounds = true

    }
    
    func setActionHandler(actionType: String, handler: @escaping () -> ()) {
        
        if actionType == "cancle" {
            buttonAction = handler
        }else {
            buttonAction = handler
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.cancelButtonAction()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.delegate?.doneButtonAction()
//        self.buttonAction!()
    }
    
}
