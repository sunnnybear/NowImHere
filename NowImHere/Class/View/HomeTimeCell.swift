//
//  HomeTimeCell.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/6.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

class HomeTimeCell: UITableViewCell {
    var model : WebDKDetailListModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.startLabel.text    = model.start_time
            self.endLabel.text      = model.button_kind
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
