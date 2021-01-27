//
//  TAHomeViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MapKit
import Presentr
import MBProgressHUD
import Toaster
class TAHomeViewController: BaseViewController{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tbJob: UITableView!
    @IBOutlet weak var clCate: UICollectionView!
    let regionRadius: CLLocationDistance = 2000
    var manager:CLLocationManager!
    var currentLoc:CLLocation?
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var isFisrt = false
    var centerMap: CLLocation = CLLocation()
    var currentCate:CateObj?
    var listCates = [CateObj]()
    var listCatesSelected = [CateObj]()
    var listJob = [TAJobObj]()
    var currentJob:TAJobObj?
    //var listStatus = [STATUS_JOB.NEW,STATUS_JOB.InProgress,STATUS_JOB.CANCEL,STATUS_JOB.DONE]
    var currentStatus :STATUS_JOB = .NEW
    var noName:String?
    var btFilter:UIButton?
    var btInvite:UIButton?
    /// đây là biến chọn cate
    var IndexSeclecCate = 0
    var listAnnotation = [PlaceAnnotation]()
    var isOnl = true
    {
        //didSet chạy khi thằng onl đc gán giá trị
        didSet
        {
            btSwitch.isOn = isOnl
             //clCate.isHidden = !isOnl
        }
    }
    var listStore = [UserObj]()
    let btSwitch = UISwitch()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isShowHeader = true
        isHiddenBottomBar = false
        mapView.delegate = self
        tbJob.register(UINib.init(nibName: "TAJobTableViewCell", bundle: nil), forCellReuseIdentifier: "TAJobTableViewCell")
        tbJob.delegate = self
        tbJob.dataSource = self
        clCate.delegate = self
        clCate.dataSource = self
        clCate.register(UINib.init(nibName: "TAHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAHomeCollectionViewCell")
        isShowLeftTitle = true
        self.navigationItem.title = "Trực tuyến"
        mapView.delegate = self
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        //setRightNavButton(withImage: UIImage.init(named: "ic_filter")!)
        tbJob?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbJob?.finishInfiniteScroll()
            }
        }
        if #available(iOS 10.0, *) {
            self.tbJob?.refreshControl = refreshControl
        } else {
            self.tbJob?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        getData()
        if DataCenter.sharedInstance.currentUser == nil{
            getDetaiUser()
        }
        else{
            checkStatusUser()
        }
        self.getCountNotif()
        tbJob.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if btFilter == nil{
            self.addRightButton()
            //self.addRightBt()
            
        }
        
    }
    override func setupLeftTitle(){
        let viewLeft = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width * (1/2), height: 44)))
        let lbTitle = UILabel()
        lbTitle.frame = CGRect.init(x: 0, y: 0, width: viewLeft.frame.width, height: 25)
        lbTitle.center.y = viewLeft.center.y
        lbTitle.font = UIFont.init(name: "AvenirNext-Bold", size: 25)
        lbTitle.textColor = UIColor.white
        if saveTitle == ""{
            saveTitle = self.navigationItem.title ?? ""
            self.navigationItem.title = ""
        }
        lbTitle.text = saveTitle
        viewLeft.addSubview(lbTitle)
        let itemsContainer = UIBarButtonItem(customView: viewLeft)
        self.navigationItem.leftBarButtonItems = [itemsContainer]
        //        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btMore),self.btNoti] as? [UIBarButtonItem]
    }
    func getDetaiUser(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getMyProfileDetai{(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE
            {
                DataCenter.sharedInstance.currentUser = response as? UserObj ?? UserObj()
                self.checkStatusUser()
                self.setStateForBTNInvite()
                AppDelegate.sharedInstance.getCountNotif()
            }
            else
            {
                Toast(text: message, duration: 2).show()
            }
            
        }
    }
   
    func getCate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getCate(uid: "\(DataCenter.sharedInstance.currentUser?.internalIdentifier ?? "")"){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.clCate?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE{
                let cateAll = CateObj()
                cateAll.name = "Tất cả"
                cateAll.imgDes = UIImage(named:  "ic_All")
                self.listCates = response as? [CateObj] ?? [CateObj]()
                self.listCates.insert(cateAll, at: 0)
                DataCenter.sharedInstance.listCate = self.listCates
                //self.getData()
                self.clCate.reloadData()
                self.loadDataMaps()
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
    
    func checkStatusUser()  {
        isOnl =  DataCenter.sharedInstance.currentUser?.isOnline == 1 ? true: false
        if isOnl{
            AppDelegate.sharedInstance.startTracking()
            
        }
        else{
            AppDelegate.sharedInstance.stopTracking()
            
        }
        checkSwitchStatus()
        if DataCenter.sharedInstance.currentUser?.status == 0{
            AppDelegate.sharedInstance.mainTabbar?.selectedIndex = 3
        }
        else{
            self.getCate()
        }
    }
    
    func setStateForBTNInvite() {
        self.btInvite?.isSelected = DataCenter.sharedInstance.currentUser?.totalJobInvite != 0
    }
    
    override func initData() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func fakeData(){
        let annotation = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude:currentLoc?.coordinate.latitude ?? 0 , longitude: currentLoc?.coordinate.longitude ?? 0))
        annotation.stringId = "current_loc"
        let annotation2 = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude:(currentLoc?.coordinate.latitude ?? 0) - 0.02 , longitude: (currentLoc?.coordinate.longitude ?? 0) - 0.015))
        let annotation3 = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude:(currentLoc?.coordinate.latitude ?? 0) + 0.012 , longitude: (currentLoc?.coordinate.longitude ?? 0) + 0.02))
        mapView.addAnnotation(annotation)
        mapView.addAnnotation(annotation2)
        mapView.addAnnotation(annotation3)
    }
    func addRightButton(){
//
        btFilter = UIButton()
        var posXFilter:CGFloat = 0
        var posXSwitch:CGFloat = 0
        var viewWidth:CGFloat = 0
        if UIScreen.main.bounds.height > HEIGHT_5S{
            posXFilter = 44
            posXSwitch = 12
            viewWidth = 300
        }
        else{
            posXFilter = 34
            posXSwitch = 0
            viewWidth = 88
        }
        
        btFilter?.frame = CGRect.init(origin: CGPoint.init(x: posXFilter, y: 0), size: CGSize.init(width: 30, height: 30))
        btFilter?.setImage(UIImage.init(named: "ic_list"), for: .normal)
        btFilter?.setImage(UIImage.init(named: "ic_maps"), for: .selected)
        btFilter?.addTarget(self, action: #selector(self.filterPress), for: .touchUpInside)
        let viewRight = UIView(frame: CGRect(origin: .zero, size: CGSize(width: viewWidth, height: 44)))
        viewRight.backgroundColor = .red
        viewRight.addSubview(btFilter!)
        btInvite = UIButton()
        btInvite?.frame = CGRect.init(origin: CGPoint.init(x: posXFilter, y: 0), size: CGSize.init(width: 30, height: 30))
        btInvite?.center.x = viewRight.center.x - 20
        //btReject?.backgroundColor = UIColor.red
        btInvite?.setImage(UIImage.init(named: "ic_reject_default"), for: .normal)
        btInvite?.setImage(UIImage.init(named: "ic_reject"), for: .selected)
        
        btInvite?.addTarget(self, action: #selector(self.filterPressInvite), for: .touchUpInside)
        //viewRight.backgroundColor = UIColor.red
        viewRight.addSubview(btInvite!)
//        viewRight.backgroundColor = .red
        btSwitch.frame =  CGRect.init(origin: CGPoint.init(x: posXSwitch, y: 0), size: CGSize.init(width: 30, height: 20))
//        btSwitch.transform = CGAffineTransform(scalX: 0.75, y: 0.75)
        btSwitch.center.y = viewRight.center.y
        btSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        btSwitch.onTintColor = UIColor.clear
        btSwitch.tintColor = UIColor.white
        btSwitch.cornerRadius = 16
//        btSwitch.thumbTintColor = UIColor.lightGray
        btSwitch.borderColor = UIColor.white
        btSwitch.borderWidth = 2
        //btSwitch.isOn = isOnl
//        viewRight.addSubview(btSwitch)
        let SpacerBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let SpacerBarButton1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let naviSwitch = UIBarButtonItem(customView: btSwitch)
        let naviReject = UIBarButtonItem(customView: btInvite ?? UIView())
        let naviFilter = UIBarButtonItem(customView: btFilter ?? UIView())
        //        self.btNoti?.addBadge(number: 100)
//        navigationItem.rightBarButtonItem = naviSwitch
        navigationItem.rightBarButtonItems = [naviFilter,naviReject,naviSwitch] as? [UIBarButtonItem]
        let itemsContainer = UIBarButtonItem(customView: viewRight)
//        self.navigationController?.navigationBar.addSubview(<#T##view: UIView##UIView#>)
//        self.navigationItem.rightBarButtonItems = [itemsContainer]
//        self.navigationItem.rightBarButtonItem = itemsContainer
        //        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btMore),self.btNoti] as? [UIBarButtonItem]
    }
    override func onPressRightNavButton() {
        
    }
//    func addRightBt(){
//        btReject = UIButton()
//        btReject?.frame = CGRect.init(origin: CGPoint.init(x: -30, y: 5), size: CGSize.init(width: 44, height: 44))
//        btReject?.setImage(UIImage.init(named: "ic_reject"), for: .normal)
//        btReject?.setImage(UIImage.init(named: "ic_reject"), for: .selected)
//        btReject?.addTarget(self, action: #selector(self.filterPressInvite), for: .valueChanged)
//        let viewRightReject = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
//        viewRightReject.backgroundColor = UIColor.red
//        viewRightReject.addSubview(btReject!)
//        let itemsContainer = UIBarButtonItem(customView: viewRightReject)
//        self.navigationItem.rightBarButtonItems = [itemsContainer]
//    }
    @objc func filterPressInvite(){
        let inviteVC:TaListInviteViewController=QuandaStoryBoard.instantiateViewController(withIdentifier: "TaListInviteViewController") as! TaListInviteViewController
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
    func checkSwitchStatus(){
        btSwitch.isOn = isOnl
        if !btSwitch.isOn {
            btSwitch.thumbTintColor = UIColor.lightGray
        }
        else{
            btSwitch.thumbTintColor = UIColor.white
        }
    }
    @objc func filterPress(){
        btFilter?.isSelected = !(btFilter?.isSelected ?? false)
        tbJob.isHidden = !(btFilter?.isSelected ?? false)
//        print("filter press")
//        let detailPopUpVc:TaBoLocViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaBoLocViewController") as! TaBoLocViewController
//        detailPopUpVc.listCateSelected = self.listCatesSelected
//        detailPopUpVc.currentCate = self.currentCate
////        detailPopUpVc.currentStatus = self.currentStatus
//        detailPopUpVc.noName = self.noName ?? ""
//        detailPopUpVc.superView = self
//        detailPopUpVc.listCate = self.listCates
////        self.navigationController?.pushViewController(detailPopUpVc, animated: true)
//        //        detailPopUpVc.showPopupVC = self
//        let yVC = (AppDelegate.sharedInstance.window?.center.y ?? 0) - 400/2
//        let presenter: Presentr = {
//            let width = ModalSize.custom(size: Float(self.view.frame.width) * (5/6))
//            let height = ModalSize.custom(size: Float(400)) //ModalSize.fluid(percentage: 0.20)
//            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: self.view.frame.width * (1/12), y: yVC))
//            let customType = PresentationType.custom(width: width, height: height, center: center)
//            let customPresenter = Presentr(presentationType: customType)
//            customPresenter.transitionType =  TransitionType.coverVertical
//            customPresenter.dismissTransitionType = .crossDissolve
//            customPresenter.roundCorners = true
//            customPresenter.backgroundColor = .black
//            customPresenter.backgroundOpacity = 0.3
//            customPresenter.dismissOnSwipe = true
//            customPresenter.dismissOnSwipeDirection = .bottom
//            customPresenter.cornerRadius = 10
//            return customPresenter
//        }()
//        customPresentViewController(presenter, viewController: detailPopUpVc, animated: true)

    }
    @objc func switchChange(_ sender:UISwitch){
        // nếu là true - 1, false - 0
        let status =  sender.isOn ? 1 : 0
        isOnl = sender.isOn
        checkSwitchStatus()
       
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.checkOnline(online: status) { (response, message, errorCode) in
//            Toast(text: message, duration: 2.0).show()
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                DataCenter.sharedInstance.currentUser?.isOnline = status
                self.reloadData()
                if self.isOnl{
                    AppDelegate.sharedInstance.startTracking()
                    self.btInvite?.isHidden = false
                }
                else{
                    AppDelegate.sharedInstance.stopTracking()
                    self.btInvite?.isHidden = true
                }
            }
        }
        
        //print("switch change")
    }
    func getData(){
        // nếu là off thì không đc load data
        var listStatus = [STATUS_JOB]()
        listStatus.append(currentStatus ?? .NONE)
        if currentStatus == .DONE{
            listStatus.append(.CANCEL)
        }
//currentStatus.rawValue
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListJob(page: currentPage, cate: currentCate?.internalIdentifier, status:listStatus , type: 1, name: (noName == "" || noName == nil) ? nil : noName) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.clCate?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE{
                if self.currentPage == 1{
                    self.listJob = response as? [TAJobObj] ?? [TAJobObj]()
                }
                else{
                    self.listJob += response as? [TAJobObj] ?? [TAJobObj]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                self.loadDataMaps()
                self.tbJob.reloadData()
            }
            else{
                Toast(text: message, duration: 2.0).show()
            }
        }
    }
    @objc func reloadData()  {
        listJob.removeAll()
        tbJob?.reloadData()
        self.isLoadMore = true
        currentPage = 1
        getData()
        }
    func loadDataMaps(){
        mapView.removeAnnotations(listAnnotation)
        listAnnotation.removeAll()
        for store in listJob{
            let annotation = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(store.lat ?? 0), longitude: CLLocationDegrees(store.lng ?? 0)))
            annotation.currentStore = store
            listAnnotation.append(annotation)
            mapView.addAnnotation(annotation)
        }
//
//            let currentStore = MQStoreObj.init()
//            currentStore.address = "Chung cư An Bình, 232 Phạm Văn Đồng, Hà Nội"
//            currentStore.timeOpen = "8:00 - 22:00"
//            annotation.currentStore = currentStore
        
    }
    //hàm này để load giá trị cho các pin của của hàng
    func loadInitialData() {
        
        for i in 0 ..< listJob.count {
            let obj = listJob[i]
            let annotation = PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude: obj.lat ?? 0, longitude: obj.lng ?? 0))
            annotation.currentStore = obj
            mapView.addAnnotation(annotation)
        }
        
    }
    
    @IBAction func onTapMyLocation(_ sender:Any)
    {
        centerMapOnLocation(location: self.currentLoc)
    }
}
extension TAHomeViewController:CLLocationManagerDelegate{
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
            self.centerMapOnLocation(location: self.currentLoc!)
            //self.loadData()
            let span = MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (currentLoc?.coordinate.latitude)!, longitude: (currentLoc?.coordinate.longitude)!), span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}
extension TAHomeViewController:MKMapViewDelegate,TapStoreMakerDelegate{
    func didJobDetail(obj: TAJobObj?) {
        let detailVC:TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as! TaJobDetailViewController
        detailVC.jobObj = obj
        detailVC.isOnline = (DataCenter.sharedInstance.currentUser?.isOnline == 1)
        detailVC.fromVC = self
        self.navigationController?.pushViewController(detailVC, animated: true)
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
        if (annotation as? PlaceAnnotation)?.stringId == "current_loc"{
            annotationView?.image = UIImage.init(named: "ic_current_loc")
        }
        else{
            annotationView?.image = UIImage.init(named: "ic_other_loc")
        }

        return annotationView
    }
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            return
        }
        let starbucksAnnotation = view.annotation as! PlaceAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.delegate = self
        calloutView.fillData(obj: starbucksAnnotation.currentStore)
        calloutView.lbSoLuong.text = "\(starbucksAnnotation.currentStore?.person ?? 0)"
        calloutView.lbName.text = starbucksAnnotation.currentStore?.name
        //calloutView.lbName.text = DataCenter.sharedInstance.currentUser?.name ?? ""
        //calloutView.image_Post.sd_setImage(with: URL(string: starbucksAnnotation.stringImage!), placeholderImage: UIImage(named: "img_nopic"))
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        view.image = UIImage(named: "ic_maker") // selected
        
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "ic_other_loc") //default
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
}
extension TAHomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listJob.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TAJobTableViewCell", for: indexPath) as! TAJobTableViewCell
         cell.setup(obj: self.listJob[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailVC :TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as! TaJobDetailViewController
        jobDetailVC.jobObj = self.listJob[indexPath.row]
        jobDetailVC.fromVC = self
        jobDetailVC.superView = self
        jobDetailVC.isOnline = (DataCenter.sharedInstance.currentUser?.isOnline == 1)
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}
extension TAHomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAHomeCollectionViewCell", for: indexPath) as! TAHomeCollectionViewCell
        let isSelect = indexPath.row == IndexSeclecCate
     
        cell.setupData(obj: listCates[indexPath.row],isShowCheck: isSelect)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = clCate.frame.height
        var width:CGFloat = 0
        width = self.clCate.frame.width / 3
        
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != IndexSeclecCate
        {
           IndexSeclecCate = indexPath.row
            currentCate = listCates[IndexSeclecCate]
            reloadData()
            clCate.reloadData()
            
        }
    
    }
        
    
    
}
