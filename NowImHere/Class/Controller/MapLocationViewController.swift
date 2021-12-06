//
//  MapLocationViewController.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/10/31.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import MapKit

class MapLocationController: UIViewController ,CLLocationManagerDelegate,MKMapViewDelegate{
    
    
    // 自定义 PickerView
    lazy var mapView : MKMapView = {
        var mapViewY : CGFloat = 0
        if UIApplication.shared.statusBarFrame.height == 44 || UIApplication.shared.statusBarFrame.height == 47{
            mapViewY = 88
        }
        else{
            mapViewY = 64
        }
        let mapView = MKMapView(frame: CGRect(x: 0, y: mapViewY, width: self.view.width, height: 300))
        mapView.delegate = self
        self.view.addSubview(mapView)
        return mapView
    }()
    
    lazy var locationLabel : UILabel = {
        let locationLabel = UILabel(frame: CGRect(x: 5, y: mapView.bottom+21, width: self.view.width-10, height: 30))
        locationLabel.numberOfLines = 0
        self.view.addSubview(locationLabel)
        return locationLabel
    }()
    
    lazy var locationNameLabel : UILabel = {
        let locationNameLabel = UILabel(frame: CGRect(x:5, y: locationLabel.bottom+21, width: self.view.width-10, height: 50))
        locationNameLabel.numberOfLines = 0
        self.view.addSubview(locationNameLabel)
        return locationNameLabel
    }()
    
    var East : Double!
    var Noth : Double!
    var Address : String!
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        DispMap()
        //        if CLLocationManager.locationServicesEnabled() {
        //            locationManager = CLLocationManager()
        //            locationManager.delegate = self
        //            locationManager.startUpdatingLocation()
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
    }
    
    func DispMap(){
        // 緯度・軽度を設定
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.East,self.Noth)
        
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
        locationLabel.text="経度：".appendingFormat("%.8f", East)+"   "+"緯度：".appendingFormat("%.8f", Noth)
        
//        //创建一个大头针对象
//        let objectAnnotation = MKPointAnnotation()
//        //设置大头针的显示位置
//        objectAnnotation.coordinate = CLLocation(latitude: self.East,
//                                                 longitude: self.Noth).coordinate
//        //设置点击大头针之后显示的标题
//        objectAnnotation.title = self.Address
//        //设置点击大头针之后显示的描述
////        objectAnnotation.subtitle = "南京市秦淮区秦淮河北岸中华路"
//        //添加大头针
//        mapView.addAnnotation(objectAnnotation)
//        locationNameLabel.text = "場所：" + Address
        getLocationName()
    }
    //地理信息反编码
    func getLocationName() {
        let currentLocation = CLLocation(latitude: self.East, longitude: self.Noth)
        
        let geoCoder = CLGeocoder()
        let locationName = String()
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard placemarks != nil else {return}
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
                self.locationNameLabel.text  = "場所：" +
                    " \(placeMark?.locality ?? "")"    +
                    " \(placeMark?.thoroughfare ?? "")"
            }else if (error == nil && placemarks?.count == 0){
                print("没有地址返回");
            }
            else if ((error) != nil){
                print("location error\(String(describing: error))");
            }
        }
        self.locationNameLabel.text  = locationName
    }
    //    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    //        if userLocation.location != nil {
    //            let location : CLLocation = userLocation.location!
    //            let geocoder  = CLGeocoder()
    //            geocoder .reverseGeocodeLocation(location) { (placemarks, error) in
    //                let mark : CLPlacemark = (placemarks?.first)!
    //                userLocation.title = mark.locality
    //                userLocation.subtitle = mark.thoroughfare
    //            }
    //        }
    //
    //    }
    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //        switch status {
    //        case .notDetermined:
    //            locationManager.requestWhenInUseAuthorization()
    //        case .restricted, .denied:
    //            break
    //        case .authorizedAlways, .authorizedWhenInUse:
    //            break
    //        default: break
    //        }
    //    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        guard let newLocation = locations.last else {
    //            locationLabel.text="経度：---  緯度：---"
    //            return
    //        }
    ////        East = self.East
    ////        Noth = self.Noth
    //        locationLabel.text="経度：".appendingFormat("%.8f", East)+"   "+"緯度：".appendingFormat("%.8f", Noth)
    //
    //        locationManager.stopUpdatingLocation()
    //        let changeLocation:NSArray =  locations as NSArray
    //        let currentLocation = changeLocation.lastObject as! CLLocation
    //        let geoCoder = CLGeocoder()
    //        let locationName = String()
    //        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
    //            if((placemarks?.count)! > 0){
    //                let placeMark = placemarks?.first
    //                if let currentCity = placeMark?.locality {
    //                    print("=============\(currentCity)")
    //                }
    //                print(placeMark?.country ?? "")
    //                print(placeMark?.subAdministrativeArea ?? "")
    //                print(placeMark?.subLocality ?? "")
    //                print(placeMark?.thoroughfare ?? "")
    //                print(placeMark?.name ?? "")
    ////                locationName = "場所\(placeMark?.country ?? "") + \(placeMark?.locality ?? "") + \(placeMark?.subLocality ?? "") + \(placeMark?.thoroughfare ?? "") + \(placeMark?.name ?? "")"
    //                self.locationNameLabel.text  = "場所：" + " \(placeMark?.locality ?? "")" + " \(placeMark?.subLocality ?? "")" + " \(placeMark?.thoroughfare ?? "")"
    //
    //            }else if (error == nil && placemarks?.count == 0){
    //                print("没有地址返回");
    //            }
    //            else if ((error) != nil){
    //                print("location error\(String(describing: error))");
    //            }
    //
    //        }
    //        self.locationNameLabel.text = locationName
    //    }
}
