//
//  GGChoiseFromMapViewController.swift
//  Go2Go
//
//  Created by Khiem on 2018-09-18.
//  Copyright © 2018 SuSoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class GGChoiseFromMapViewController: BaseViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var viewTF: UIView!
    @IBOutlet weak var tfAdrress: UITextView!
    var locationManager = CLLocationManager()
    var place = GGPlaceObj()
    var curentPlace = GGPlaceObj()
    var marker = GMSMarker()
    var currentPlace:GGPlaceObj?
    var isEditStock = false
    var delegate:ChooisePlaceDelegate?
    var dataPlace = [GGPlaceObj]()
    var index:Int = 0
    var isFirst = true
    enum loadInfo {
        case loading
        case none
    }
    var type:Int? //1 diem nhan hang, 2 diem tra hang
    var isLoadInfo:loadInfo = .none
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowBackButton = true
        self.isHeaderMap = true
        self.title = "Chọn địa điểm"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initUI() {
        
        btnDone.layer.cornerRadius = CGFloat(CORNER_RADIUS)
        viewTF.layer.cornerRadius = CGFloat(CORNER_RADIUS)
        viewMap.delegate = self
        
        locationManager.delegate = self
        self.viewMap.settings.compassButton = true
        self.viewMap.isMyLocationEnabled = true
        self.viewMap.settings.myLocationButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let lat = place.lat,let long = place.long{
            viewMap.camera = GMSCameraPosition.camera(withLatitude: Double(lat), longitude: Double(long), zoom: 15)
        }else {
            self.setCurentPlace()
        }
    }
    func setCurentPlace(){
        if CLLocationManager.authorizationStatus() == .denied {
            allowLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func  allowLocation()  {
        let alert = UIAlertController(title: "Cho phép truy cập vị trí của bạn để lấy vị trí hiện tại!", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cài đặt", style: .default) { (ACTION) in
            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
        }
        let cancel = UIAlertAction(title: "Hủy", style: .destructive) { (ACTION) in
            print("cancel")
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func getInfo()  {
        if isLoadInfo == .none{
            //isLoadInfo = .loading
            let lat:String = "\(self.place.lat ?? 0.0 )"
            let long:String = "\(self.place.long ?? 0.0 )"
            Services.shareInstance.getInfoPlaceByGeoCodeGGM(lat: lat, log: long) { (response, message, errorCode) in
                self.isLoadInfo = .none
                if errorCode == SUCCESS_CODE {
                    self.place = response as! GGPlaceObj
//                    Utilitys.jsonParser(parameters: self.place.adressComponent?.arrayObject ?? [Any]())
                    self.tfAdrress.text = self.place.addr
                } else {
                    self.place = GGPlaceObj()
                    self.tfAdrress.text = ""
                }
            }
        }
        
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.chooiceEndPoint!(data: self.place)
        }
        if (navigationController?.viewControllers.count ?? 0) >= 3{
        self.navigationController?.popToViewController(navigationController?.viewControllers[(navigationController?.viewControllers.count ?? 0) - 3] ?? UIViewController(), animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
extension GGChoiseFromMapViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
        print("tap")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if self.isFirst{
            isFirst = false
            return
        }
        self.place.lat = Double(mapView.camera.target.latitude)
        self.place.long = Double(mapView.camera.target.longitude)
        self.getInfo()
    }
}

extension GGChoiseFromMapViewController : CLLocationManagerDelegate{
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.isMyLocationEnabled = true
            viewMap.settings.myLocationButton = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.place.lat = Double(location.coordinate.latitude)
            self.place.long = Double(location.coordinate.longitude)
            self.curentPlace.lat = Double(location.coordinate.latitude)
            self.curentPlace.long = Double(location.coordinate.longitude)
            self.getInfo()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.place.lat = self.curentPlace.lat
        self.place.long = self.curentPlace.long
        self.getInfo()
        return false
    }
}
