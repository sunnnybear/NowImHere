//
//  MapController.swift
//  NowImHere
//
//  Created by HanYunpeng on 2019/9/2.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var East=0.0
    var Noth=0.0
    
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispMap()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           let nav = self.navigationController?.navigationBar
           nav?.barStyle = UIBarStyle.default
           nav?.tintColor = UIColor.black
           nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
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

    }
    
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
        East=newLocation.coordinate.latitude
        Noth=newLocation.coordinate.longitude
        locationLabel.text="経度：".appendingFormat("%.8f", East)+"   "+"経度：".appendingFormat("%.8f", Noth)

        locationManager.stopUpdatingLocation()
        let changeLocation:NSArray =  locations as NSArray
        let currentLocation = changeLocation.lastObject as! CLLocation
        let geoCoder = CLGeocoder()
        let locationName = String()
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
                self.locationNameLabel.text  = "\(placeMark?.country ?? "")" + " \(placeMark?.locality ?? "")" + " \(placeMark?.subLocality ?? "")" + " \(placeMark?.thoroughfare ?? "")" + " \(placeMark?.name ?? "")"
            }else if (error == nil && placemarks?.count == 0){
                print("没有地址返回");
            }
            else if ((error) != nil){
                print("location error\(String(describing: error))");
            }
            
        }
        self.locationNameLabel.text = locationName
    }
}
