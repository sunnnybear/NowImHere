//
//  ViewController.swift
//  NowImHere
//
//  Created by 杉田浩隆 on 2019/06/24.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - 控制器的生命
class ViewController: UIViewController {
    
    @IBOutlet var LabelDatetime: UILabel!
   
    @IBOutlet var LabelDatetimeStart: UILabel!
    @IBOutlet var LabelDatetimeEnd: UILabel!
    
    @IBOutlet var BtnStart: UIButton!
    @IBOutlet var BtnEnd: UIButton!
    @IBOutlet var BtnBreak: UIButton!
    @IBOutlet var BtnReturn: UIButton!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var rightItem: UIBarButtonItem!
    

    // 自定义 PickerView
    lazy var homepickerView : HomePickerView = {
        let pickerView = Bundle.main.loadNibNamed("HomePickerView", owner: nil, options: nil)?.first as! HomePickerView
        pickerView.delegate = self as HomePickerViewDelegate
        pickerView.pickerView.delegate = self as UIPickerViewDelegate
    
        self.view.addSubview(pickerView)
        return pickerView
    }()
    
    var East=0.0
    var Noth=0.0
    
    var locationName = ""
    var location = ""
    
    var locationManager: CLLocationManager!
    
    let homeVM = HomeViewModel()
    let homeButtonVM = HomeButtonViewModel()
    
    let cellID = "cellID"
    
    // MARK: - CircleLoop
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        self.setupTableView()
        self.setupMap()
        self.requestData()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        self.rightItem.imageInsets = UIEdgeInsets(top: 2, left: 40,bottom: -2, right: -40)
        self.rightItem.isEnabled = false

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - 请求数据
    private func requestData() {
        play()
        homeVM.requestData {
            self.setupButtonState(state: self.homeVM.homeButtonState ?? "")
            self.setupViews()
        }
    }

    // MARK: - 初始化方法
    private func setupViews(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let displayTime = formatter.string(from: Date())    //
        self.LabelDatetimeStart.text = "出勤：\(displayTime) \(self.homeVM.startTime)"
        self.LabelDatetimeEnd.text = "退勤：\(displayTime) \(self.homeVM.endTime)"
        self.tableView.reloadData()
        
        stop()
    }
    
    private func setupMap() {
//        DispMap()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
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
        case "-1":
            BtnStart.isEnabled = true
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled = false
            BtnEnd.isEnabled = false
            self.stateLabel.text = "勤務終了"
        case "1":
            BtnStart.isEnabled = false
            BtnReturn.isEnabled = true
            BtnBreak.isEnabled = false
            BtnEnd.isEnabled = true
            self.stateLabel.text = "休憩中"
        case "2":
            BtnStart.isEnabled = true
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled = false
            BtnEnd.isEnabled = false
            self.stateLabel.text = "勤務終了"
        case "3":
            BtnStart.isEnabled = false
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled = true
            BtnEnd.isEnabled = false
            self.stateLabel.text = "勤務中"
        case "4":
            BtnStart.isEnabled = true
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled = false
            BtnEnd.isEnabled = false
            self.stateLabel.text = "勤務終了"
        default:
            BtnStart.isEnabled = false
            BtnReturn.isEnabled = false
            BtnBreak.isEnabled = false
            BtnEnd.isEnabled = false
            self.stateLabel.text = "------"
        }
        
        self.reloadInputViews()
    }
    
//    private func setupSwip() {
//        let swip = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
//        //设置滑动方向
//        //如果UISwipeGestureRecognizer在不指定方向的时候，默认向右滑动才会触发事件。如果要指定方向，需要设置direction属性
//        swip.direction = UISwipeGestureRecognizer.Direction.left
//        self.view.addGestureRecognizer(swip)
//    }
    
    private func setupTableView () {
        // 注册nib
        let nib = UINib.init(nibName: "HomeTimeCell", bundle: Bundle.main)
        tableView?.register(nib, forCellReuseIdentifier: cellID)
    }
    
    private func setupHomeVM() {
        self.homeVM.startTime = self.homeButtonVM.startTime
        self.homeVM.endTime = self.homeButtonVM.endTime
        self.homeVM.homeGroupModel = self.homeButtonVM.homeGroupModel
    }
    
    private func play() {
        activityIndicator.startAnimating()
    }
    
    private func stop() {
        activityIndicator.stopAnimating()
    }
 
    @objc func displayClock() {
        // 現在時刻を「HH:MM:SS」形式で取得する
        let formatter = DateFormatter()
        let week = getWeekDay()

//        formatter.dateFormat = "yyyy年MM月dd日 (\(week))\nHH:mm:ss"
        formatter.dateFormat = "yyyy年MM月dd日 (\(week))\nHH:mm"

        var displayTime = formatter.string(from: Date())    // Date()だけで現在時刻を表す

        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        if displayTime.hasPrefix("0") {
            // 最初に見つかった0だけ削除(スペース埋め)される
            if let range = displayTime.range(of: "0") {
                displayTime.replaceSubrange(range, with: " ")
            }
        }
        
        // ラベルに表示
        LabelDatetime.text = displayTime
        
    }
    
    // MARK: - 点击事件
    @IBAction func TouchStart(sender: AnyObject) {
//        let messageObject = AlertViewMessageObject.init(title             : "警告",
//                                                        content           : "不要轻信陌生电话,短信;不要轻易点击信息中的链接;不要按陌生电话,短信要求转账汇款;不要安装不了解的软件.",
//                                                        buttonTitles      : ["关闭", "更多信息"],
//                                                        buttonTitlesState : [AlertViewButtonType.Black, AlertViewButtonType.Red])
//        
//        AlertView.Setup(messageObject : messageObject as AnyObject,
//                        contentView   : UIWindow.getKeyWindow(),
//                        delegate      : self as? BaseMessageViewDelegate,
//                        autoHiden     : false).show()
        self.homeButtonVM.requestData(state: "1", workContent: self.textField.text ?? "", position: self.location , positionLocal: self.locationName, dkKind: nil) {
            MessageView.Setup(messageObject : "出勤成功" as AnyObject,
                              contentView   : UIWindow.getKeyWindow(),
                              delegate      : self as? BaseMessageViewDelegate).show()
            self.setupHomeVM()
            self.setupViews()
        }
        setupButtonState(state: "1")
    }
    @IBAction func TouchReturn(sender: AnyObject) {

        self.homeButtonVM.requestData(state: "3", workContent: self.textField.text ?? "", position: self.location , positionLocal: self.locationName, dkKind: nil) {
            MessageView.Setup(messageObject : "業務開始成功" as AnyObject,
                              contentView   : UIWindow.getKeyWindow(),
                              delegate      : self as? BaseMessageViewDelegate).show()
            self.setupHomeVM()
            self.setupViews()
        }
        setupButtonState(state: "3")
    }
    @IBAction func TouchBreak(sender: AnyObject) {

        self.homeButtonVM.requestData(state: "4", workContent: self.textField.text ?? "", position: self.location , positionLocal: self.locationName, dkKind: nil) {
            MessageView.Setup(messageObject : "業務終了成功" as AnyObject,
                              contentView   : UIWindow.getKeyWindow(),
                              delegate      : self as? BaseMessageViewDelegate).show()
            self.setupHomeVM()
            self.setupViews()
        }
        setupButtonState(state: "1")
    }
    @IBAction func TouchEnd(sender: AnyObject) {

        self.homeButtonVM.requestData(state: "2", workContent: self.textField.text ?? "", position: self.location , positionLocal: self.locationName, dkKind: nil) {
            MessageView.Setup(messageObject : "退勤成功" as AnyObject,
                              contentView   : UIWindow.getKeyWindow(),
                              delegate      : self as? BaseMessageViewDelegate).show()
            self.setupHomeVM()
            self.setupViews()
        }
        setupButtonState(state: "2")
    }
    // 工作内容点击事件
    @IBAction func workContentAction(_ sender: Any) {
        self.textField.becomeFirstResponder()
    }
    
    // 滑动手势
//    @objc func swipeGesture() {
//        print("开始滑动")
//        let myNavigaiton = UIStoryboard(name: "Main", bundle: nil)
//            .instantiateViewController(withIdentifier: "Map_ID")
//        self.navigationController?.pushViewController(myNavigaiton, animated: true)
//    }
    
    // MARK: - 私有方法
    private func DispMap(){
        // 緯度・軽度を設定
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.68154,139.752498)
        
        mapView.setCenter(location,animated:true)
        
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        
        mapView.setRegion(region,animated:true)
        
        // 表示タイプを航空写真と地図のハイブリッドに設定
        //mapView.mapType = MKMapType.hybrid
        mapView.mapType = MKMapType.standard
        // mapView.mapType = MKMapType.satellite
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
    }
    
    private func getWeekDay()->String{
        
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let displayTime = dateFmt.string(from: Date())
        let date = dateFmt.date(from: displayTime)
        let interval = Int(date!.timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 5)%7+7)%7
        let weekDays = ["日","月","金","木","水","火","土"]
        return weekDays[weekday]
    }
}

// MARK: - TableView 代理方法
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.homeVM.homeGroupModel.detailListModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTimeCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! HomeTimeCell
        cell.model = self.homeVM.homeGroupModel.detailListModels[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}

// MARK: - map代理方法
extension ViewController: CLLocationManagerDelegate {
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
        East=newLocation.coordinate.latitude
        Noth=newLocation.coordinate.longitude
        location="経度：".appendingFormat("%.8f", East)+"   "+"纬度：".appendingFormat("%.8f", Noth)
        
        locationManager.stopUpdatingLocation()
        let changeLocation:NSArray =  locations as NSArray
        let currentLocation = changeLocation.lastObject as! CLLocation
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if((placemarks?.count)! > 0){
                let placeMark = placemarks?.first
                if let currentCity = placeMark?.locality {
                    print("=============\(currentCity)")
                }
                print(placeMark?.country ?? "")
                print(placeMark?.subAdministrativeArea ?? "")
                print(placeMark?.subLocality ?? "")
                print(placeMark?.thoroughfare ?? "")
                print(placeMark?.name ?? "")

                self.locationName  = "場所：\(placeMark?.country ?? "")" + " \(placeMark?.locality ?? "")" + " \(placeMark?.subLocality ?? "")" + " \(placeMark?.thoroughfare ?? "")" + " \(placeMark?.name ?? "")"
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

// MARK: - pickerView 代理方法&数据源
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
        textField.text = self.homeVM.homeGroupModel.contentModels[row].name
    }
    
    
}

// MARK: - textfield 代理方法
extension ViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            self.textField.inputView = self.homepickerView
            self.homepickerView.isHidden = false
            self.homepickerView.removeFromSuperview()
        }
        return true
    }

}

// MARK: - PickerView 代理方法
extension ViewController : HomePickerViewDelegate {
    func doneButtonAction() {
        self.textField.resignFirstResponder()
    }
    
    func cancelButtonAction() {
        self.textField.text = ""
        self.textField.resignFirstResponder()
    }
}

// MARK: - 自定义button
@IBDesignable
class Button_Custom: UIButton {
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 1.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 1.0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
}

// MARK: - 自定义View
@IBDesignable
class View_Custom: UIView{
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 1.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 1.0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
}

