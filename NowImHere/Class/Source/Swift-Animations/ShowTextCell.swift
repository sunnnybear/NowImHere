//
//  ShowTextCell.swift
//  Swift-Animations
//
//  Created by YouXianMing on 16/8/30.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

enum EShowTextCellType : Int {
    
    case normalType, expendType
}

private let heitiSC       : UIFont = UIFont.HeitiSC(18)
private let titleFont     : UIFont = UIFont.HeitiSC(21)
private let timeFont     : UIFont = UIFont.HeitiSC(16)
private let numberOfLines : Int    = 3

class ShowTextCell: CustomCell {
    
    fileprivate var titleLabel  : UILabel!
    fileprivate var timeLabel  : UILabel!
    fileprivate var expendLabel : UILabel!
    fileprivate var normalLabel : UILabel!
    fileprivate var lineView    : UIView!
    fileprivate var redView     : UIView!
    
    override func buildSubview() {
        
        titleLabel           = UILabel(frame: CGRect.zero)
        titleLabel.font      = titleFont
        addSubview(titleLabel)
        
        timeLabel           = UILabel(frame: CGRect.zero)
        timeLabel.font      = timeFont
        addSubview(timeLabel)
        
        normalLabel           = UILabel(frame: CGRect.zero)
        normalLabel.font      = heitiSC
        normalLabel.textColor = UIColor.gray.alpha(0.5)
        addSubview(normalLabel)
        
        expendLabel           = UILabel(frame: CGRect.zero)
        expendLabel.font      = heitiSC
        addSubview(expendLabel)
        
        redView                 = UIView(frame: CGRect(x: 0, y: 20, width: 2, height: 14))
        redView.backgroundColor = UIColor.red
        addSubview(redView)
        
        lineView = UIView.CreateLine(CGRect(x: 0, y: 0, width: Screen.Width, height: 0.5), lineColor: UIColor.black.alpha(0.1))
        addSubview(lineView)
    }
    
    override func loadContent() {
        
        (indexPath as NSIndexPath?)?.row == 0 ? (lineView.isHidden = true) : (lineView.isHidden = false)
        changeStateWithCellType((dataAdapter?.cellType!)!)
    }
    
    fileprivate func changeStateWithCellType(_ type : Int) {
        
        let model = data as! ShowTextModel
        
        titleLabel.sizeToFitWithString(model.inputTitleString!, width: Screen.Width - 30, numberOfLines: 0)
        titleLabel.left = 15
        titleLabel.top  = 15
        
        timeLabel.sizeToFitWithString(model.inputDateString!, width: Screen.Width - 30, numberOfLines: 1)
        timeLabel.left = 15
        timeLabel.top   = 20 + (model.inputTitleString?.heightWithFont(titleFont, fixedWidth: Screen.Width - 30))!
        
        normalLabel.sizeToFitWithString(model.inputString!, width: Screen.Width - 30, numberOfLines: numberOfLines)
        normalLabel.left = 15
        normalLabel.top  = 30 + (model.inputTitleString?.heightWithFont(titleFont, fixedWidth: Screen.Width - 30))! + (model.inputDateString?.heightWithFont(timeFont, fixedWidth: Screen.Width - 30))!
        
        expendLabel.sizeToFitWithString(model.inputString!, width: Screen.Width - 30, numberOfLines: 0)
        expendLabel.left = 15
        expendLabel.top  = 30 + (model.inputTitleString?.heightWithFont(titleFont, fixedWidth: Screen.Width - 30))! + (model.inputDateString?.heightWithFont(timeFont, fixedWidth: Screen.Width - 30))!
        
        if type == EShowTextCellType.normalType.rawValue {
            
            expendLabel.alpha       = 0
            normalLabel.alpha       = 1
            redView.backgroundColor = UIColor.gray
            
        } else if type == EShowTextCellType.expendType.rawValue {
            
            expendLabel.alpha       = 1
            normalLabel.alpha       = 0
            redView.backgroundColor = UIColor.red
        }
    }
    
    override func selectedEvent() {
        
        let model = data as! ShowTextModel
        
        if dataAdapter?.cellType == EShowTextCellType.normalType.rawValue {
            
            self.dataAdapter?.cellType = EShowTextCellType.expendType.rawValue
            self.updateWithNewCellHeight(model.expendStringHeight!)
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.normalLabel.alpha       = 0
                self.expendLabel.alpha       = 1
                self.redView.backgroundColor = UIColor.red
            })
            
        } else if dataAdapter?.cellType == EShowTextCellType.expendType.rawValue {
            
            self.dataAdapter?.cellType = EShowTextCellType.normalType.rawValue
            self.updateWithNewCellHeight(model.normalStringHeight!)
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.normalLabel.alpha       = 1
                self.expendLabel.alpha       = 0
                self.redView.backgroundColor = UIColor.gray.alpha(0.5)
            })
        }
    }
    
    override class func HeightWithData(_ data : AnyObject?) -> CGFloat {
        
        let model                = data as! ShowTextModel
        model.expendStringHeight = 25 + (model.inputString?.heightWithFont(heitiSC, fixedWidth: Screen.Width - 30))! + 15 + (model.inputTitleString?.heightWithFont(titleFont, fixedWidth: Screen.Width - 30))! + (model.inputTitleString?.heightWithFont(timeFont, fixedWidth: Screen.Width - 30))!
        model.normalStringHeight = 25 + String.HeightWithFont(heitiSC) * CGFloat(numberOfLines) + 15 + (model.inputTitleString?.heightWithFont(titleFont, fixedWidth: Screen.Width - 30))! + (model.inputTitleString?.heightWithFont(timeFont, fixedWidth: Screen.Width - 30))!
        if model.normalStringHeight! > model.expendStringHeight! {
            model.normalStringHeight = model.expendStringHeight!
            model.expendStringHeight! += 10
        }
        return model.normalStringHeight!
    }
}

