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
class TaMapViewController: BaseViewController {
    var currentLoc:CLLocation?
    @IBOutlet weak var mapView: MKMapView!
    var jobObj:TAJobObj?
    let regionRadius: CLLocationDistance = 100
    var isFisrt = false
    var manager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.title = "Đường đến nơi làm việc"
        isShowBackButton = true
        isShowHeaderFillter = true
        isHiddenBottomBar = true
        
        
        // Do any additional setup after loading the view.
        
    }
    override func initData() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    func getRoutes(fromLat: Double, fromLong: Double, toLat: Double, toLong: Double) {
        self.setPoint(lat: fromLat, long: fromLong, isStart: true)
        self.setPoint(lat: toLat, long: toLong, isStart: false)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: fromLat, longitude: fromLong), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: toLat, longitude: toLong), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        MBProgressHUD.showAdded(to: AppDelegate.sharedInstance.window ?? UIView(), animated: true)
        directions.calculate { [unowned self] response, error in
            MBProgressHUD.hide(for: AppDelegate.sharedInstance.window ?? UIView(), animated: true)
            if let unwrappedResponse = response{
                for route in unwrappedResponse.routes {
                    if self.mapView != nil{
                        self.mapView.addOverlay(route.polyline)
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    }
                }
            } else {
//                                let alert = UIAlertController(title: nil,
//                                                              message: "Tuyến đường không được hỗ trợ trên bản đồ.", preferredStyle: .alert)
//                                let okButton = UIAlertAction(title: "OK",
//                                                             style: .cancel) { (alert) -> Void in
//                                                                self.navigationController?.popViewController(animated: true)
//                                }
//                                alert.addAction(okButton)
//                                self.present(alert, animated: true,
//                                             completion: nil)
            }
            
            
        }
    }
    func setPoint(lat:Double,long:Double,isStart:Bool)  {
        let position = CLLocationCoordinate2D(latitude:lat, longitude: long)
        let annotion = ImagePlaceAnnotation(coordinate: position)
        if isStart{
            annotion.stringId = "start"
        }
        //        annotion.coordinate = position
        mapView.addAnnotation(annotion)
        //        let marker = GMSMarker(position: position)
        //
        //        marker.icon = pointIcon
        //        marker.tracksViewChanges = true
        //        marker.map = self.viewMap
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TaMapViewController:MKMapViewDelegate{
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.init(hexString: "#0099cc")
//        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.red
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
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
        if (annotation as? ImagePlaceAnnotation)?.stringId == "start"{
            annotationView?.image = UIImage.init(named: "ic_other_loc")
        }
        else{
            annotationView?.image = UIImage.init(named: "map_pin")
        }
        
        return annotationView
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
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.currentLoc = locations.first
        if !isFisrt
        {
            //            fakeData()
            
            //loadDataMaps()
            isFisrt = true
            //self.loadData()
            self.centerMapOnLocation(location: self.currentLoc!)
            //self.loadData()
            let span = MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (currentLoc?.coordinate.latitude)!, longitude: (currentLoc?.coordinate.longitude)!), span: span)
            mapView.setRegion(region, animated: true)
            getRoutes(fromLat: currentLoc?.coordinate.latitude ?? 0, fromLong: currentLoc?.coordinate.longitude ?? 0, toLat: Double(jobObj?.lat ?? 0), toLong: Double(jobObj?.lng ?? 0))
        }
    }
}
