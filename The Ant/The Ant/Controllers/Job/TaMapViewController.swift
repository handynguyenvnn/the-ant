//
//  TaMapViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 8/30/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import Toaster
class TaMapViewController: BaseViewController {
    var currentLoc:CLLocation?
    @IBOutlet weak var mapView: MKMapView!
    var jobObj:TAJobObj?
    let regionRadius: CLLocationDistance = 100
    var isFisrt = false
    var manager:CLLocationManager!
    var listByWorker = [WorkerByRadiusObj]()
    var listAnnotation = [PlaceAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.title = "Bản đồ công việc"
        isShowBackButton = true
        isShowHeaderJobDetail = true
        isHiddenBottomBar = true
        getByWorker()
        
        // Do any additional setup after loading the view.
        
    }
    override func initData() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        let annotationJob = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(jobObj?.lat ?? 0), longitude: CLLocationDegrees(jobObj?.lng ?? 0)))
        annotationJob.stringId = "job_loc"
        mapView.addAnnotation(annotationJob)
        
    }
    func setPoint(lat:Double,long:Double,isStart:Bool)  {
        let position = CLLocationCoordinate2D(latitude:lat, longitude: long)
        let annotion = ImagePlaceAnnotation(coordinate: position)
        if isStart{
            annotion.stringId = "start"
        }
        mapView.addAnnotation(annotion)
    }
    
    func getByWorker(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getWorkerByRadius(jid: jobObj?.internalIdentifier ?? "") {(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE {
                self.listByWorker = response as? [WorkerByRadiusObj] ?? [WorkerByRadiusObj]()
                self.loadDataMaps()
            }else{
                Toast.init(text: message, duration: 2.0).show()
            }
        }
    }
    func loadDataMaps(){
//        mapView.removeAnnotations(listAnnotation)
//        listByWorker.removeAll()
        for store in listByWorker{
            let annotationWorker = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(store.lat ?? 0), longitude: CLLocationDegrees(store.lng ?? 0)))
            annotationWorker.stringId = "woker_loc"
            //listAnnotation.append(annotation)
            mapView.addAnnotation(annotationWorker)
        }
    }
    
}
extension TaMapViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    manager.startUpdatingLocation()
                }
            }
        }
    }
    func centerMapOnLocation(location: CLLocation?) {
        if location != nil
        {
            let coordinateRegion = MKCoordinateRegion(center: (location?.coordinate)!,
                                                      latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    // các hàm locationManager để lấy ra địa điểm hiện tại
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.currentLoc = locations.first
        if !isFisrt
        {
            //            fakeData()
            
            //loadDataMaps()
            isFisrt = true
            //self.loadData()
            self.centerMapOnLocation(location: CLLocation.init(latitude: jobObj?.lat ?? 0, longitude: jobObj?.lng ?? 0))
            //self.loadData()
//            let span = MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125)
//            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (jobObj?.lat ?? 0)!, longitude: (jobObj?.lat ?? 0)!), span: span)
//            mapView.setRegion(region, animated: true)
//            getRoutes(fromLat: currentLoc?.coordinate.latitude ?? 0, fromLong: currentLoc?.coordinate.longitude ?? 0, toLat: Double(jobObj?.lat ?? 0), toLong: Double(jobObj?.lng ?? 0))
        }
    }
}
extension TaMapViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        if (annotation as? PlaceAnnotation)?.stringId == "job_loc"{
            annotationView?.image = UIImage.init(named: "map_pin")
        }
        else{
            annotationView?.image = UIImage.init(named: "ic_other_loc")
        }

        
        return annotationView
    }
//    func mapView(_ mapView: MKMapView,
//                 didSelect view: MKAnnotationView)
//    {
//        if view.annotation is MKUserLocation
//        {
//            return
//        }
//        let starbucksAnnotation = view.annotation as! PlaceAnnotation
////        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
////        let calloutView = views?[0] as! CustomCalloutView
////        calloutView.delegate = self
////        calloutView.fillData(obj: starbucksAnnotation.currentStore)
////        calloutView.lbSoLuong.text = "\(starbucksAnnotation.currentStore?.person ?? 0)"
////        calloutView.lbName.text = starbucksAnnotation.currentStore?.name
//        //calloutView.lbName.text = DataCenter.sharedInstance.currentUser?.name ?? ""
//        //calloutView.image_Post.sd_setImage(with: URL(string: starbucksAnnotation.stringImage!), placeholderImage: UIImage(named: "img_nopic"))
//        //calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
//        //view.addSubview(calloutView)
//        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
//        view.image = UIImage(named: "ic_maker") // selected
//
//    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "ic_maker") //default
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
}
