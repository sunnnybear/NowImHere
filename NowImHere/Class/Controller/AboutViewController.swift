//
//  AboutViewController.swift
//  NowImHere
//
//  Created by 韩云鹏 on 2020/9/23.
//  Copyright © 2020 杉田浩隆. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }

}
