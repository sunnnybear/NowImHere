//
//  TapCellAnimationController.swift
//  Swift-Animations
//
//  Created by YouXianMing on 16/8/30.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

class ArticleViewController: NormalTitleViewController, UITableViewDelegate, UITableViewDataSource {
    
    var articleArray          : Array<[String:String]>?
    
    fileprivate var tableView : UITableView!
    fileprivate var datas     : [CellDataAdapter]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nav         = self.navigationController?.navigationBar
        nav?.barStyle   = UIBarStyle.default
        nav?.tintColor  = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.title      = "お知らせ"
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        datas = [CellDataAdapter]()
        
        tableView                = UITableView(frame: (contentView?.bounds)!)
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.separatorStyle = .none
        ShowTextCell.RegisterTo(tableView)
        contentView?.addSubview(tableView)
        
        func addText(_ string : String, title : String, date : String) {
            
            let model = ShowTextModel(string, inputTitle: title, inputDate: date)
            
            datas.append(ShowTextCell.Adapter(
                data       : model,
                cellHeight : ShowTextCell.HeightWithData(model),
                type       : EShowTextCellType.normalType.rawValue))
        }
        
        GCDQueue.Main.excuteAfterDelay(0.5) {
            guard let array = self.articleArray else { return }
            for articleDic in array {
                addText(articleDic["content"]!, title: articleDic["title"]!, date: articleDic["date"]!)
            }
            
            var indexPaths = [IndexPath]()
            for i in 0 ..< self.datas.count {
                
                indexPaths.append(IndexPath(item: i, section: 0))
            }
            self.tableView.insertRows(at: indexPaths, with: .fade)
            
            GCDQueue.Main.excuteAfterDelay(0.5, {
                
                let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! CustomCell
                cell.selectedEvent()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueCellAndLoadContentFromAdapter(datas[(indexPath as NSIndexPath).row], indexPath: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return datas[(indexPath as NSIndexPath).row].cellHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.selectedEventWithIndexPath(indexPath)
    }
}
