//
//  HomeViewController.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/10/30.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SCLAlertView


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var topBgView: UILabel!
    @IBOutlet weak var LabelTime: UILabel!
    
    @IBOutlet weak var rightItem: UIBarButtonItem!
    
    @IBOutlet weak var LabelDatetime: UILabel!
    
    // 出勤
    @IBOutlet weak var BtnStart: Button_Custom!
    // 休息开始
    @IBOutlet weak var BtnReturn: Button_Custom!
    // 休息终了
    @IBOutlet weak var BtnBreak: Button_Custom!
    // 退勤
    @IBOutlet weak var BtnEnd: Button_Custom!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var LabelDatetimeStart: UILabel!
    
    @IBOutlet weak var LabelDatetimeEnd: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var timerForShowScrollIndicator: Timer?
    // 自定义 PickerView
    lazy var homepickerView : HomePickerView = {
        let pickerView = Bundle.main.loadNibNamed("HomePickerView", owner: nil, options: nil)?.first as! HomePickerView
        pickerView.delegate = self as HomePickerViewDelegate
        pickerView.pickerView.delegate = self as UIPickerViewDelegate
        
        self.view.addSubview(pickerView)
        return pickerView
    }()

    var kScreenSize : CGSize {
        let rv = UIApplication.shared.keyWindow! as UIWindow
        let sz = rv.frame.size
        return sz
    }
    
    
    var East : Double = 0.0
    var Noth : Double = 0.0
    
    var locationName = ""
    var location = ""
    
    var locationManager: CLLocationManager!
    
    let homeVM = HomeViewModel()
    let homeButtonVM = HomeButtonViewModel()
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupMap()
        self.requestData()
        self.setupSwip()
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: NSNotification.Name(rawValue:"applicationWillEnterForeground"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.flashScrollIndicators()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : MenuController = segue.destination as! MenuController
        if segue.identifier == "tomanu" {
            vc.articleArray = self.homeVM.articleArray
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        //        self.rightItem.imageInsets = UIEdgeInsets(top: 2, left: 40,bottom: -2, right: -40)
        //        self.rightItem.isEnabled = false
        
        //        textField.attributedPlaceholder = NSAttributedString(string: "作業内容を選択してください",
        //        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    private func setupTableView () {
        // 注册nib
        let nib = UINib.init(nibName: "HomeTimeCell", bundle: Bundle.main)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
        tableView.showsVerticalScrollIndicator = true
    }
    
    // MARK: - 请求数据
    @objc private func requestData() {
        print("*** 首页")
        self.homeVM.requestData {
            print("*** 网络请求")
            self.setupButtonState(state: self.homeVM.homeButtonState ?? "")
            self.setupViews()
            self.setupTopView()
        }
    }
    
    // MARK: - 初始化方法
    @objc private func setupViews(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        _ = formatter.string(from: Date())    //
        
        if self.homeVM.startTime == "" {
            //            self.LabelDatetimeStart.text = "出勤："
        }
        else{
            //            self.LabelDatetimeStart.text = "出勤：\(displayTime) \(self.homeVM.startTime)"
        }
        
        if self.homeVM.endTime == "" {
            //            self.LabelDatetimeEnd.text = "退勤："
        }
        else{
            //            self.LabelDatetimeEnd.text = "退勤：\(displayTime) \(self.homeVM.endTime)"
        }
        
        self.tableView.reloadData()
        
        //        stop()
    }
    private func setupTopView () {
        if self.homeVM.articleArray?.count == 0 {
                
            self.homeVM.articleArray? = [["date" : "" ,"content" : "", "title" : "まだお知らせがないです"]]
            
        }
        
        let content : String = self.homeVM.articleArray?[0]["content"] ?? ""
        print(content)
//        let characterSet = CharacterSet(charactersIn: "\r\n")
        let str2 = content.trimmingCharacters(in: .whitespacesAndNewlines)

        let dataArray = [self.homeVM.articleArray?[0]["date"] ?? "",self.homeVM.articleArray?[0]["title"] ?? "",str2.replacingOccurrences(of: "\r\n", with: "", options: .literal, range: nil)]
//        let dataArray = [self.homeVM.articleArray?[0]["content"] ?? ""]
//        let dataArray = ["AFNetworking is a delightful networking library for iOS and Mac OS X. "
//        ]
        var items: [GCMarqueeModel] = []
        
        for str in dataArray {
            let model = GCMarqueeModel(title: str)
            items.append(model)
        }

        let marqueeWidth: CGFloat = Screen.Width - 68 - 10
        let view3 = GCMarqueeView(frame: CGRect(x: 0, y: 0, width: marqueeWidth, height: 40), type: .rtl);
        view3.backgroundColor = UIColor(red: 232/255, green: 238/255, blue: 255/255, alpha: 1)
        view3.items = items
        topBgView.addSubview(view3)
    }
    
    private func setupMap() {
        //        DispMap()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.startUpdatingLocation()
        }
        let timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(displayClock),
            userInfo: nil,
            repeats: true)
        timer.fire()
    }
    
    private func setupButtonState(state: String) {
        
        switch state {
        case "-1": // 初始化状态
            BtnStart.isEnabled  = true
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled  = false
            BtnEnd.isEnabled    = false
        case "0": // 点击 出勤
            BtnStart.isEnabled  = false
            BtnReturn.isEnabled = true
            BtnBreak.isEnabled  = false
            BtnEnd.isEnabled    = true
        case "1": // 点击 休息开始
            BtnStart.isEnabled  = false
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled  = true
            BtnEnd.isEnabled    = false
        case "2": // 点击 休息终了
            BtnStart.isEnabled  = false
            BtnReturn.isEnabled = true
            BtnBreak.isEnabled  = false
            BtnEnd.isEnabled    = true
        case "3": // 点击 退勤
            BtnStart.isEnabled  = true
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled  = false
            BtnEnd.isEnabled    = false
        default:
            BtnStart.isEnabled  = false
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled  = false
            BtnEnd.isEnabled    = false
        }
        
        self.reloadInputViews()
    }
    
    @objc func displayClock() {
        // 現在時刻を「HH:MM:SS」形式で取得する
        let formatter = DateFormatter()
        let timeFormateter = DateFormatter()
        let week = getWeekDay()
        formatter.dateFormat = "yyyy年MM月dd日 (\(week))"
        timeFormateter.dateFormat = "HH:mm"
        let displayDate = formatter.string(from: Date())    // Date()だけで現在時刻を表す
        var displayTime = timeFormateter.string(from: Date())
        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        if displayTime.hasPrefix("0") {
            // 最初に見つかった0だけ削除(スペース埋め)される
            if let range = displayTime.range(of: "0") {
                displayTime.replaceSubrange(range, with: " ")
            }
        }
        
        // ラベルに表示
        LabelDatetime.text = displayDate
        LabelTime.text = displayTime
    }
    private func getWeekDay()->String{
        
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let displayTime = dateFmt.string(from: Date())
        let date = dateFmt.date(from: displayTime)
        let interval = Int(date!.timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 5)%7+7)%7
        let weekDays = ["日","月","火","水","木","金","土"]
        return weekDays[weekday]
    }
    private func setupHomeVM() {
        self.homeVM.startTime = self.homeButtonVM.startTime
        self.homeVM.endTime = self.homeButtonVM.endTime
        self.homeVM.homeGroupModel = self.homeButtonVM.homeGroupModel
    }
    
    // MARK: - 点击事件
    
    /// 出勤按钮点击
    @IBAction func TouchStart(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop : 0.0,
            kTitleHeight : 0.0,
            kWindowWidth : kScreenSize.width-100,
            kTextHeight : 0.0,
            kTextViewdHeight : 0.0,
            kButtonHeight : 65,
            kTitleFont: UIFont(name: "HelveticaNeue", size: AVTitleFontSize)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
            showCloseButton: false,
            showCircularIcon: false,
            shouldAutoDismiss: true,
            hideWhenBackgroundViewIsTapped: true
        )
        let color1 = UIColor.init(red: 26/255, green: 39/255, blue: 138/255, alpha: 1)
        let color2 = UIColor.init(red: 82/255, green: 38/255, blue: 138/255, alpha: 1)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("一般出勤", backgroundColor:color1) {
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
            
            let icon = UIImage(named:"yonghu.png")
            let color = UIColor.init(red: 89/255, green: 95/255, blue: 144/255, alpha: 1)

            _ = alert.showCustom("おはようございます！", subTitle: "", color: color, icon: icon!, closeButtonTitle:"確　認")
            
            // 改变按钮状态
            self.homeButtonVM.requestData(state: "0", workContent: "", position: self.location , positionLocal: self.locationName ,dkKind: "0") {
                self.setupHomeVM()
                self.setupViews()
            }
            self.setupButtonState(state: "0")
        }
        
        _ = alert.addButton("直　行", backgroundColor:color2) {
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
            
            let icon = UIImage(named:"yonghu.png")
            let color = UIColor.init(red: 89/255, green: 95/255, blue: 144/255, alpha: 1)

            _ = alert.showCustom("おはようございます！", subTitle: "", color: color, icon: icon!, closeButtonTitle:"確　認")
            // 改变按钮状态
            self.homeButtonVM.requestData(state: "0", workContent: "", position: self.location , positionLocal: self.locationName ,dkKind: "1") {
                self.setupHomeVM()
                self.setupViews()
            }
            self.setupButtonState(state: "0")
        }
        
        let icon = UIImage(named:"yonghu.png")
        let color = UIColor.orange
        _ = alert.showCustom("", subTitle: "", color: color, icon: icon!)
        
    }
    
    /// 休息开始按钮点击
    @IBAction func TouchReturn(sender: AnyObject) {
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
            // 改变按钮状态
            self.homeButtonVM.requestData(state: "1", workContent: "", position: self.location , positionLocal: self.locationName,dkKind: "3") {
                self.setupHomeVM()
                self.setupViews()
            }
            self.setupButtonState(state: "1")
        }
        _ = alert.showCustom("休憩開始\nよろしいですか?", subTitle: "", color: color, icon: icon!, closeButtonTitle:"いいえ")
        
    }
    
    /// 休息结束按钮点击
    @IBAction func TouchBreak(sender: AnyObject) {
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
            // 改变按钮状态
            self.homeButtonVM.requestData(state: "2", workContent: "", position: self.location , positionLocal: self.locationName, dkKind: "3") {
                //                MessageView.Setup(messageObject : "業務終了成功" as AnyObject,
                //                                  contentView   : UIWindow.getKeyWindow(),
                //                                  delegate      : self as? BaseMessageViewDelegate).show()
                self.setupHomeVM()
                self.setupViews()
            }
            self.setupButtonState(state: "2")
        }
        _ = alert.showCustom("休憩終了\nよろしいですか?", subTitle: "", color: color, icon: icon!, closeButtonTitle:"いいえ")
        
    }
    
    /// 退勤按钮点击
    @IBAction func TouchEnd(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop : 0.0,
            kTitleHeight : 0.0,
            kWindowWidth : kScreenSize.width-100,
            kTextHeight : 0.0,
            kTextViewdHeight : 0.0,
            kButtonHeight : 65,
            kTitleFont: UIFont(name: "HelveticaNeue", size: AVTitleFontSize)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: AVButtonFontSize)!,
            showCloseButton: false,
            showCircularIcon: false,
            shouldAutoDismiss: true,
            hideWhenBackgroundViewIsTapped: true
        )
        let color1 = UIColor.init(red: 138/255, green: 78/255, blue: 26/255, alpha: 1)
        let color2 = UIColor.init(red: 138/255, green: 38/255, blue: 38/255, alpha: 1)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("一般退勤", backgroundColor:color1) {
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
            let icon = UIImage(named:"yonghu.png")
            let color = UIColor.init(red: 89/255, green: 95/255, blue: 144/255, alpha: 1)
            _ = alert.showCustom("お疲れ様でした。", subTitle: "", color: color, icon: icon!, closeButtonTitle:"確　認")
            
            // 改变按钮状态
            self.homeButtonVM.requestData(state: "3", workContent: "", position: self.location , positionLocal: self.locationName, dkKind: "0") {
                self.setupHomeVM()
                self.setupViews()
            }
            self.setupButtonState(state: "3")
        }
        
        _ = alert.addButton("直  帰", backgroundColor:color2) {
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
            
            let icon = UIImage(named:"yonghu.png")
            let color = UIColor.init(red: 89/255, green: 95/255, blue: 144/255, alpha: 1)

            _ = alert.showCustom("お疲れ様でした。", subTitle: "", color: color, icon: icon!, closeButtonTitle:"確　認")
            
            // 改变按钮状态
            self.homeButtonVM.requestData(state: "3", workContent: "", position: self.location , positionLocal: self.locationName, dkKind: "1") {
                
                self.setupHomeVM()
                self.setupViews()
            }
            self.setupButtonState(state: "3")
        
        }
        
        let icon = UIImage(named:"yonghu.png")
        let color = UIColor.orange
        _ = alert.showCustom("", subTitle: "", color: color, icon: icon!)
        
        
    }
    // 工作内容点击事件
    @IBAction func workContentAction(_ sender: Any) {
        //        self.textField.becomeFirstResponder()
    }
    
    @IBAction func messageBtnAction(_ sender: Any) {
        let vc      =       ArticleViewController()
        vc.articleArray = self.homeVM.articleArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func setupSwip() {
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        //设置滑动方向
        //如果UISwipeGestureRecognizer在不指定方向的时候，默认向右滑动才会触发事件。如果要指定方向，需要设置direction属性
        swip.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swip)
    }
    
    //滑动手势
    @objc func swipeGesture() {
        print("开始滑动")
        //        let vc = MapLocationController()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func firstButton() {
        print("First button tapped")
    }
    
}

// MARK: - pickerView 代理方法&数据源
extension HomeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 這邊我們希望資料 row 長一點，所以不是回傳資料的數量，後面的方法會補上。
        return  self.homeVM.homeGroupModel.webDKContent?.count ?? 0
    }
    // 顯示內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.homeVM.homeGroupModel.contentModels[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        textField.text = self.homeVM.homeGroupModel.contentModels[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.homeVM.homeGroupModel.contentModels[row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    
}

// MARK: - textfield 代理方法
extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField && self.homeVM.homeGroupModel.contentModels.count>0 {
            self.textField.inputView = self.homepickerView
            self.homepickerView.isHidden = false
            self.homepickerView.removeFromSuperview()
            return true
        }
        else{
            MessageView.Setup(messageObject : "作業内容がございません" as AnyObject,
                              contentView   : UIWindow.getKeyWindow(),
                              delegate      : self as? BaseMessageViewDelegate).show()
            return false
        }
        
    }
    
}

// MARK: - PickerView 代理方法
extension HomeViewController : HomePickerViewDelegate {
    func doneButtonAction() {
        
        if textField.text == "" {
            textField.text = self.homeVM.homeGroupModel.contentModels[homepickerView.pickerView.selectedRow(inComponent: 0)].name
        }
        self.textField.resignFirstResponder()
    }
    
    func cancelButtonAction() {
        self.textField.text = ""
        self.textField.resignFirstResponder()
    }
}

// MARK: - TableView 代理方法
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.homeVM.homeGroupModel.detailListModels.count)
        return self.homeVM.homeGroupModel.detailListModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTimeCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! HomeTimeCell
        cell.model = self.homeVM.homeGroupModel.detailListModels[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var arrayStrings: [String] = []
        let arraySubstrings: [Substring] = self.homeVM.homeGroupModel.detailListModels[indexPath.row].position.split(separator: "/")
        for item in arraySubstrings {
            arrayStrings.append("\(item)")
        }
        guard arrayStrings.count != 0 else {
            cell.iconImageView.isHidden = true
            return cell
        }
        guard arrayStrings[0] != "" else {
            cell.iconImageView.isHidden = true
            return cell
        }
        guard arrayStrings[1] != "" else {
            cell.iconImageView.isHidden = true
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrayStrings: [String] = []
        let arraySubstrings: [Substring] = self.homeVM.homeGroupModel.detailListModels[indexPath.row].position.split(separator: "/")
        for item in arraySubstrings {
            arrayStrings.append("\(item)")
        }
        let vc = MapLocationController()
        guard arrayStrings.count != 0 else {
            return
        }
        guard arrayStrings[0] != "" else {
            return
        }
        guard arrayStrings[1] != "" else {
            return
        }
        vc.East     = Double(arrayStrings[0] )
        vc.Noth     = Double(arrayStrings[1] )
        vc.Address  = self.homeVM.homeGroupModel.detailListModels[indexPath.row].position_local
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - map代理方法
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        var location = String()
        East = newLocation.coordinate.latitude
        Noth = newLocation.coordinate.longitude
//        location="経度：".appendingFormat("%.8f", East)+" "+"経度：".appendingFormat("%.8f", Noth)
        location="".appendingFormat("%.8f", East)+"/".appendingFormat("%.8f", Noth)
        locationManager.stopUpdatingLocation()
        let changeLocation:NSArray =  locations as NSArray
        let currentLocation = changeLocation.lastObject as! CLLocation
        let geoCoder = CLGeocoder()
        print("坐标 --  \(location)")
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if((placemarks?.count)! > 0){
                let placeMark = placemarks?.first
                if let currentCity = placeMark?.locality {
                    print("=============\(currentCity)")
                }
                
                print("placeMark?.country = \(placeMark?.country ?? "")")
                print("placeMark?.subAdministrativeArea = \(placeMark?.subAdministrativeArea ?? "")")
                print("placeMark?.subLocality = \(placeMark?.subLocality ?? "")")
                print("placeMark?.thoroughfare = \(placeMark?.thoroughfare ?? "")")
                print("placeMark?.name = \(placeMark?.name ?? "")")
                self.locationName  = "" + " \(placeMark?.locality ?? "")" + " \(placeMark?.thoroughfare ?? "")"
            }else if (error == nil && placemarks?.count == 0){
                print("没有地址返回");
            }
            else if ((error) != nil){
                print("location error\(String(describing: error))");
            }
        }
        self.location = location
    }
}

