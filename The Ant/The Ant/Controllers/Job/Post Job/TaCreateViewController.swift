//
//  TaCreateViewController.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import DatePickerDialog
import AVFoundation
import DropDown
import MBProgressHUD
import Toaster
import Toast_Swift
import SwiftyJSON
import IDMPhotoBrowser
import MapKit
import YPImagePicker
let HEIGHT_TABLE_TIME = 147
let DEFAULT_LB_ADDRESS = "Chọn địa chỉ"
let DEFAULT_TEXT_COMMENT = "Viết mô tả cho công việc này"
class TaCreateViewController: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var txtPhoneManager: SSTextField!
    @IBOutlet weak var txtManagerName: SSTextField!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbSTPTT: UILabel!
    @IBOutlet weak var txtDecs: UITextView!
    @IBOutlet weak var lbMTT: UILabel!
    @IBOutlet weak var clViewAvatar: UICollectionView!
    @IBOutlet weak var lbHATT: UILabel!
    @IBOutlet weak var txtAmount: SSTextField!
    @IBOutlet weak var tbViewTime: UITableView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    ///linhvuc
    @IBOutlet weak var lbField: SSTextField!
//    @IBOutlet weak var lbTask: UILabel!
    @IBOutlet weak var lbTask: SSTextField!
    @IBOutlet weak var lbDKDB: UILabel!
    @IBOutlet weak var lbSpecialConditions: UILabel!
    @IBOutlet weak var tbSpecialConditions: UITableView!
    @IBOutlet weak var viewFooterTbTime: UIView!
    @IBOutlet weak var tbSpecialConditionsHeight: NSLayoutConstraint!
    @IBOutlet weak var tbTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var btnTaoDon: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    var birthday:Date = Date()
//    var currentLoc:CLLocation?
    public var arrStartTime = [TimeHour]()
    public var arrEndTime = [TimeHour]()
    var condition = [ConditionObj]()
    var conditionObj:ConditionObj?
    var conditionSelect = [ConditionObj]()
    var timeWordData:[TimeWorkObj] = [TimeWorkObj]()
    /// lưu time cho phần chỉnh sửa
    var timeWordDataSelected:[TimeWorkObj] = [TimeWorkObj]()
    var cates = [CateObj]()
    var timeWord = [TimeWork]()
    var imageObj:ImageObj?
    var user:UserObj?
    var cate:CateObj?
    var place:GGPlaceObj?
    let imagePicker = UIImagePickerController()
    var imgRealWork = [ImageObj]()
    var refreshControl = UIRefreshControl()
    var imageSelected:UIImage?
    var indexSelect:Int = 0
    var currentPrice:PriceObj?
    var listPrice = [PriceObj]()
    var listIDImageUpload = [String]()
    ///biến này để check số ảnh đã đc upload
    var countCheckUpLoadImg:Int = 0
    /// số những ảnh mới đc update
    var countUpLoadImg:Int = 0
    /// id của lĩnh vực
    var cid:String = ""
    /// địa chỉ nơi làm việc
    var address:String = ""
    var lat:Double = 0.0
    var long:Double = 0.0
    /// id của job
    var idJob:String = ""
    var minTimeValue = TimeHour.init(hourValue: 1, minuteValue: 0)
    public var startTime = TimeHour(hourValue: 6, minuteValue: 0)
    public var endTime = TimeHour(hourValue: 20, minuteValue: 0)
    public var minTime: Float = 1
    var isStartTime = false
    var isEdit: Bool = false
    var profile:TAJobObj?
    var curentTime:TimeWorkObj?
    var curentTrangthai:JOB_TRANGTHAI = .Acctive
    var superView:TaJobDetailViewController?
	var homeVC:TAHomeViewController?
    var isEditting = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowHeader = true
        isShowBackButton = true
        isHiddenBottomBar = true
        self.title = "Đăng Công Việc"
        clViewAvatar.dataSource = self
        clViewAvatar.delegate = self
        clViewAvatar.register(UINib.init(nibName: "TaClPostJobCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaClPostJobCollectionViewCell")
        tbSpecialConditions.dataSource = self
        tbSpecialConditions.delegate = self
        tbViewTime.dataSource = self
        tbViewTime.delegate = self
        tbViewTime.register(UINib.init(nibName: "TaPostJobTableViewCell", bundle: nil), forCellReuseIdentifier: "TaPostJobTableViewCell")
        timeWordData.append(TimeWorkObj())
        tbViewTime.reloadData()
        tbTimeHeight.constant = CGFloat(HEIGHT_TABLE_TIME * timeWordData.count) + 30
        tbSpecialConditions.register(UINib.init(nibName: "TaTbSpecialConditionPostJobTableViewCell", bundle: nil), forCellReuseIdentifier: "TaTbSpecialConditionPostJobTableViewCell")
        condition.append(ConditionObj())
        tbSpecialConditions.reloadData()
        tbViewTime.tableFooterView = viewFooterTbTime
        txtDecs.text = DEFAULT_TEXT_COMMENT
        txtDecs.delegate = self
        txtDecs.textColor = UIColor.lightGray
        lbSTPTT.adjustsFontSizeToFitWidth = true
        lbMoney.adjustsFontSizeToFitWidth = true
        imagePicker.delegate = self
        txtAmount.delegate = self
        txtAmount.returnKeyType = .done
        lbAddress.textColor = UIColor.lightGray
        lbAddress.font = UIFont.init(name: "Muli-Regular", size: 14)
        txtPhoneManager.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(setStartPoint), name: NSNotification.Name.init("setStartPoint"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(setEditing), name: NSNotification.Name.init("setEndPoint"), object: nil)
        self.getCondition()
        //setDataTime()
        if cate != nil{
            lbField.text = cate?.name ?? ""
        }
//        if #available(iOS 10.0, *) {
//            self.tbSpecialConditions?.refreshControl = refreshControl
//        } else {
//            self.tbSpecialConditions?.addSubview(refreshControl)
//        }
//        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        if isEdit{
            fillData()
            timeWordDataSelected = timeWordData
            timeWordData.removeAll()
            timeWordData.append(TimeWorkObj())
            tbTimeHeight.constant = CGFloat(HEIGHT_TABLE_TIME * (timeWordData.count ?? 0)) + 30
            tbViewTime.reloadData()
            btnTaoDon.setTitle("Lưu", for: .normal)
        }else if profile != nil{
            btnTaoDon.setTitle("Đăng lại", for: .normal)
            fillData()
            timeWordDataSelected = timeWordData
            timeWordData.removeAll()
            timeWordData.append(TimeWorkObj())
            tbTimeHeight.constant = CGFloat(HEIGHT_TABLE_TIME * (timeWordData.count ?? 0)) + 30
            tbViewTime.reloadData()
        }
        txtManagerName.text = DataCenter.sharedInstance.currentUser?.name ?? ""
        txtPhoneManager.text = DataCenter.sharedInstance.currentUser?.phone ?? ""
    }
    override func tapLeft() {
        self.view.endEditing(true)
        if checkIsEditting(){
            let alert = UIAlertController(title: "Thông báo", message: "Việc quay lại sẽ xoá hết các thông tin bạn đã nhập. Bạn có chắc chắn muốn quay lại không?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Đồng ý", style: .default, handler: { (action) in
                self.profile?.timeWorkData = self.timeWordDataSelected
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction.init(title: "Bỏ qua", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func checkIsEditting() -> Bool{
        if lbTask.text != ""{
            return true
        }
        if lbField.text != ""{
            return true
        }
        if lbAddress.text != DEFAULT_LB_ADDRESS{
            return true
        }
        if txtAmount.text != ""{
            return true
        }
        if txtDecs.text != DEFAULT_TEXT_COMMENT{
            return true
        }
        if timeWordData.count > 0 {
            for item in timeWordData {
                if item.startDate != nil || item.endDate != nil{
                    return true
                }
            }
        }
//        if txtManagerName.text != ""{
//            return true
//        }
//        if txtPhoneManager.text != ""{
//            return true
//        }
//        if txtPhoneManager.text != "" {
//            return true
//        }
        return false
    }
    @IBAction func onCheckBox(_ sender: Any) {
        btnCheck.isSelected = !btnCheck.isSelected
        if btnCheck.isSelected {
            curentTrangthai = .InAcctive
            
        }else{
            curentTrangthai = .Acctive
        }
    }
    func isValidate() -> Bool{
        if lbTask.text == ""{
            self.view.showToast(message: "Mời bạn Nhập Tên công việc.", position: .top)
            lbTask.becomeFirstResponder()
            return false
        }
        if lbField.text == ""{
            self.view.showToast(message: "Mời bạn Nhập Lĩnh Vực Công Việc.", position: .top)
            lbField.becomeFirstResponder()
            return false
        }
        if lbAddress.text == DEFAULT_LB_ADDRESS{
            self.view.showToast(message: "Mời bạn nhập vào địa chỉ.", position: .top)
            //lbAddress.becomeFirstResponder()
            return false
        }
        if txtAmount.text == ""{
            self.view.showToast(message: "Mời bạn nhập vào số lượng người cần tuyển.", position: .top)
            txtAmount.becomeFirstResponder()
            return false
        }
        if txtDecs.text == DEFAULT_TEXT_COMMENT{
            self.view.showToast(message: "Mời bạn nhập vào mô tả thêm.", position: .top)
            txtDecs.becomeFirstResponder()
            return false
        }
        if timeWordData.count == 0 {
            self.view.showToast(message: "Bạn chưa chọn ca làm", position: .top)
            return false
        }
        for item in timeWordData {
            if item.startDate == nil || item.endDate == nil{
                self.view.showToast(message: "Bạn chưa chọn ca làm", position: .top)
                return false
            }
        }
        if txtManagerName.text == ""{
            self.view.showToast(message: "Mời bạn nhập tên nhà tuyển dụng", position: .top)
            txtManagerName.becomeFirstResponder()
            return false
        }
        if txtPhoneManager.text == ""{
            self.view.showToast(message: "Mời bạn nhập số điện thoại nhà tuyển dụng", position: .top)
            txtPhoneManager.becomeFirstResponder()
            return false
        }
        if txtPhoneManager.text?.count != 10 {
            self.view.showToast(message: "Số điện thoại không đúng", position: .top)
            txtPhoneManager.becomeFirstResponder()
            return false
        }
        return true
    }
    @IBAction func onAddress(_ sender: Any) {
        self.view.endEditing(true)
        let addressVC:GGChooisePlaceViewController = MapStoryBoard.instantiateViewController(withIdentifier: "GGChooisePlaceViewController") as! GGChooisePlaceViewController
        addressVC.delegate = self
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    func isValiEstimatedPrice() -> Bool{
        if lbField.text == ""{
            return false
        }
        if txtAmount.text == ""{
            return false
        }
        if timeWordData.count == 0 {
            //self.view.showToast(message: "Bạn chưa chọn ca làm", position: .top)
            return false
        }
        for item in timeWordData {
            if item.startDate == nil || item.endDate == nil{
                //self.view.showToast(message: "Bạn chưa chọn ca làm", position: .top)
                return false
            }
        }
        return true
    }
    
    func setDataTime(){
        let totalMinute:Int = Int((minTime ?? 0) * 60)
        let minTimeHour:Int = totalMinute / 60
        let minTimeMinute:Int = totalMinute % 60
        
        minTimeValue = TimeHour.init(hourValue: minTimeHour, minuteValue: minTimeMinute)
        
        var start = startTime
        var end = endTime.add(hourValue: -minTimeHour, minuteValue: -minTimeMinute)
        
        for i in start.hour...end.hour{
            var tmpTime = TimeHour.init(hourValue: i, minuteValue: 0)
            if start <= tmpTime && tmpTime <= end{
                arrStartTime.append(tmpTime)
            }
            
            tmpTime = TimeHour.init(hourValue: i, minuteValue: 30)
            if (start <= tmpTime && tmpTime <= end){
                arrStartTime.append(tmpTime)
            }
        }
        start =  startTime.add(hourValue: minTimeHour, minuteValue: minTimeMinute)
        end = endTime
        for i in start.hour...end.hour {
            var tmpTime = TimeHour.init(hourValue: i, minuteValue: 0)
            if start <= tmpTime && tmpTime <= end{
                arrEndTime.append(tmpTime)
            }
            
            tmpTime = TimeHour.init(hourValue: i, minuteValue: 30)
            if start <= tmpTime && tmpTime <= end{
                arrEndTime.append(tmpTime)
            }
        }
    }
    func showAlertTime(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel) { (Action) in
            alert.removeFromParent()
        }
        
        var arrData = isStartTime ? arrStartTime : arrEndTime
        for i in arrData {
            let action = UIAlertAction(title: i.show(), style: .default) { (Action) in
                self.setTime(value: i)
            }
            alert.addAction(action)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    func setTime(value:TimeHour) {
        if isStartTime {
            //time bat dau
            timeWordData[indexSelect].startTime = value

        } else {
            //time ket thuc
            timeWordData[indexSelect].endTime = value
        }
        self.jobEstimatedPrice()
        tbViewTime.reloadData()
        
    }

    @IBAction func onTime(_ sender: Any) {
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show(
            "Thời gian",
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            minimumDate:Date(),
            datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    self.birthday = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.lbTime.text = formatter.string(from: dt)
                }
        }
    }
    @IBAction func onDropDown(_ sender: Any) {
        self.view.endEditing(true)
        if cates.count == 0
        {
            getCate()
        }
        else
        {
            self.showDropdown(data: cates.map{$0.name ?? ""}, target: self.lbField, selectIndex: nil)
        }
    }
    @IBAction func onTaoDon(_ sender: Any) ->Void {
    self.view.endEditing(true)
       if isValidate(){
         btnTaoDon.isEnabled = false
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        let listNewImage = imgRealWork.filter{$0.internalIdentifier == nil}
        imgRealWork.removeAll { (obj) -> Bool in
            obj.internalIdentifier == nil
        }
        countUpLoadImg = listNewImage.count
            if countUpLoadImg > 0{
                MBProgressHUD.showAdded(to: self.view, animated: true)
                for image in listNewImage{
                    upLoadImage(image: image.image ?? UIImage())
                }
            }else{
                if profile?.status == STATUS_JOB.DONE.rawValue{
                    //xử lí đăng lại
                    btnTaoDon.isEnabled = true
                    if self.profile?.userWorkers?.count == 0{
                        jobCreate()
                    }else{
                        TAPopupChoiseWorkerViewController.show(mainVC: self, type: .RECREATE, dataWorker: profile?.userWorkers)
                    }
                    
                }
                else if isEdit{
                    editJob()
                }
                else{
                    jobCreate()
                }
            }
        }
    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // do stuff
//        if txtAmount == textField{
//            self.jobEstimatedPrice()
//        }
//        return true
//    }
   
    @IBAction func addSelfTableTime(_ sender: Any) {
        self.view.endEditing(true)
        timeWordData.append(TimeWorkObj())
        tbTimeHeight.constant = CGFloat(HEIGHT_TABLE_TIME * timeWordData.count) + 30
        for item in timeWordData {
            if item.startDate != nil || item.endDate != nil{
            jobEstimatedPrice()
            }
        }
        if timeWordData.count == 0 {
            jobEstimatedPrice()
        }
        //jobEstimatedPrice()
        tbViewTime.reloadData()
        //tbTimeHeight.constant = CGFloat(42 * timeWordData.count) + 30
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = DEFAULT_TEXT_COMMENT
            textView.textColor = UIColor.lightGray
        }
    }
    func choiseImg() {

        let alert = UIAlertController(title: "Bạn có thể chụp hoặc tải ảnh có sẵn trên máy", message: "", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Tải hình từ điện thoại", style: .default) { (ACTION) in
            self.showLibrary()
        }
        
        let photo = UIAlertAction(title: "Chụp ảnh", style: .default) { (ACTION) in
            self.checkAccessCamera()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (ACTION) in
            
        }
        alert.addAction(library)
        alert.addAction(photo)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    func showLibrary()  {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    func checkAccessCamera()  {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.showCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (newStatus) in
                if newStatus {
                    DispatchQueue.main.async(execute: {
                        self.showCamera()
                    });
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        let alert = UIAlertController(title: "Cho phép truy cập camera của bạn!", message: "", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Cài đặt", style: .default) { (ACTION) in
                            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                        }
                        let cancel = UIAlertAction(title: "Hủy", style: .destructive) { (ACTION) in
                            self.view.showToast(message: "Bạn chưa cho phép truy cập camera!")
                        }
                        alert.addAction(ok)
                        alert.addAction(cancel)
                        self.present(alert, animated: true)
                    });
                }
            }
        }
    }
    func showDropdown(data:[String],target:UITextField?,selectIndex:Int?) {
        let dropDown = DropDown()
        dropDown.anchorView = target
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height) ?? 0)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height ?? 0.0))
        if selectIndex != nil && selectIndex ?? 0 < data.count
        {
            dropDown.selectRow(selectIndex ?? 0)
        }
        
        if let font = UIFont.init(name: "Muli-Regular", size: 14.0){
            dropDown.textFont = font
        }
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            target?.text = item
            self.cate = self.cates[index]
            self.cid = self.cates[index].internalIdentifier ?? ""
            self.jobEstimatedPrice()
        }
        dropDown.show()
        
    }
    func jobCreate(idCheck:String? = nil){
        if isValidate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.create(
        name: lbTask.text ?? "",
        cid: cate?.internalIdentifier ?? cid,
        person: Int(txtAmount.text ?? "") ?? 0,
        address:place?.toStringJson() ?? address,
        content: txtDecs.text ?? "",
        condition:conditionSelect ,  //phải là list
        pictures: imgRealWork,//phải là list
        timeWork: timeWordData,
        list_invite: idCheck,
        status:curentTrangthai,
        lat:place?.lat ?? lat,// Double("\(currentLoc?.coordinate.latitude ?? 0.0)") as! Double,
        lng:place?.long ?? long,
        hr_name: txtManagerName.text ?? "",
        hr_phone: txtPhoneManager.text ?? "",
        address_component: self.place?.adressComponent?.array != nil ? Utilitys.jsonParser(parameters: self.place?.adressComponent?.arrayObject ?? [Any]()) : (profile?.address_component ?? "")
        ){(response, message, errorCode) in
            self.btnTaoDon.isEnabled = true
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                if !self.isEdit && self.profile != nil// check cho đăng lại
                {
                    self.superView?.jobObj = response as? TAJobObj
                    self.superView?.loadData()
                    self.superView?.initData()
//                    if (self.navigationController?.viewControllers.count ?? 0) >= 3{
//                        self.navigationController?.popToViewController(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 0) - 3] ?? UIViewController(), animated: true)
//                    }
                    self.goJobDetail()
                }else{
                    self.goJobDetail()
                    
                    
                }
                
            }
        }
        }
    }
    func jobEstimatedPrice(){
        if isValiEstimatedPrice(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.jobPrice(
        cid: cate?.internalIdentifier ?? cid,
        person: Int(txtAmount.text ?? "") ?? 0,
        condition: conditionSelect,
        timeWork: timeWordData){ (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            //Toast.init(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                //self.lbMoney.text = "\(Utilitys.getDefaultStringPrice(originString: Float((response as? Int64) ?? 0) as AnyObject) ) VNĐ"
                //self.lbMoney.text = "\(Utilitys.getDefaultStringPrice(originString: "\(self.price?.totalMoney ?? 0 )" as AnyObject) ) VNĐ"
                self.currentPrice = response as? PriceObj
                
                for timeWord in self.timeWordData{
                    for eachTime in self.currentPrice?.eachMoney ?? [EachMoney](){
                        let startTimeWord = Utilitys.getDateFromText("yyyy-MM-dd HH:mm", Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", timeWord.startDate))
                        let endTimeWord = Utilitys.getDateFromText("yyyy-MM-dd HH:mm", Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", timeWord.endDate))
                        if  startTimeWord == Utilitys.getDateFromText("yyyy-MM-dd HH:mm", eachTime.startTime)  && endTimeWord == Utilitys.getDateFromText("yyyy-MM-dd HH:mm", eachTime.endTime){
                            timeWord.price_shift = eachTime.price_shift
                        }
                    }
                }
                self.lbMoney.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(self.currentPrice?.totalMoney ?? 0)" as AnyObject) ) VNĐ/h"
                self.tbViewTime.reloadData()
                }
            }
        }
    }
    func editJob(){
        if isValidate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.editJob(
            id:profile?.internalIdentifier ?? idJob,
            name: lbTask.text ?? "",
            cid: cate?.internalIdentifier ?? cid,
            //day_work: Utilitys.stringToDate(withFormat: "YYYY-MM-dd", strDate: lbTime.text ?? "") ?? Date(),
            person: Int(txtAmount.text ?? "") ?? 0,
            address:place?.toStringJson() ?? address,
            content: txtDecs.text ?? "",
            condition:conditionSelect ,  //phải là list
            pictures: imgRealWork,//phải là list
            timeWork: timeWordData,
            status: curentTrangthai,
            lat:place?.lat ?? lat,// Double("\(currentLoc?.coordinate.latitude ?? 0.0)") as! Double,
            lng:place?.long ?? long,
            hr_name: txtManagerName.text ?? "",
            hr_phone: txtPhoneManager.text ?? "",
            address_component:self.place?.adressComponent?.array != nil ? Utilitys.jsonParser(parameters: self.place?.adressComponent?.arrayObject ?? [Any]()) : (profile?.address_component ?? "") )
            {(response, message, errorCode) in
                self.btnTaoDon.isEnabled = true
                MBProgressHUD.hide(for: self.view, animated: true)
                self.profile = response as? TAJobObj
                Toast(text: message, duration: 2.0).show()
                if errorCode == SUCCESS_CODE{
                    self.superView?.jobObj = self.profile
                    self.superView?.loadData()
                    self.superView?.initData()
                    if (self.navigationController?.viewControllers.count ?? 0) >= 3{
                        self.navigationController?.popToViewController(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 0) - 3] ?? UIViewController(), animated: true)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    func fillData(){
        if profile != nil{
            lbTask.text = self.profile?.name ?? ""
            lbAddress.text = self.profile?.address ?? ""
            if lbAddress.text != "" {
                lbAddress.textColor = UIColor.black
                lbAddress.font = UIFont.init(name: "Muli-Bold", size: 14)
            }
            //txtAmount.text = "\(self.profile?.person ?? 0)"
            lbField.text = self.profile?.category?.name ?? ""
            lbMoney.text = self.profile?.price ?? ""
            txtDecs.text = self.profile?.content ?? ""
            self.timeWordData = profile?.timeWork?.map({ (time) -> TimeWorkObj in
                return time.timeWork
            }) ?? [TimeWorkObj]()
            tbTimeHeight.constant = CGFloat(HEIGHT_TABLE_TIME * timeWordData.count) + 30
            tbViewTime.reloadData()
            imgRealWork.removeAll()
            for imgString in profile?.images ?? [ImageObj](){
                imgRealWork.append(ImageObj.init(url: imgString))
            }
            clViewAvatar.reloadData()
            self.timeWordData = profile?.timeWork?.map{$0.timeWork} ?? [TimeWorkObj]()
            
            tbViewTime.reloadData()
            cid = profile?.cid ?? ""
            address = profile?.address ?? ""
            lat = profile?.lat ?? 0
            long = profile?.lng ?? 0
            idJob = profile?.internalIdentifier ?? ""
        }
    }
    func upLoadImage(image:UIImage){
        Services.shareInstance.uploadImg(selectedImages: image) { (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                self.imgRealWork.append((response as? ImageObj ?? ImageObj()))
            }
            self.countCheckUpLoadImg += 1
            self.checkUploadImg()
            //Toast.init(text: message, duration: 2.0).show()
        }
    }
    func checkUploadImg(){
        if countCheckUpLoadImg == countUpLoadImg{
            MBProgressHUD.hide(for: self.view, animated: true)
            if isEdit{
                editJob()
            }else{
                jobCreate()
            }
            countCheckUpLoadImg = 0
        }
    }
    func getCondition(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getCondition(block : { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.condition = response as? [ConditionObj] ?? [ConditionObj]()
                self.profile?.condition?.forEach({ (target) in
                    if let i = self.condition.firstIndex(where: { (condition) -> Bool in
                        return condition.internalIdentifier == target.internalIdentifier
                    })
                    {
                        self.selecCondition(i)
                    }
                })
                self.jobEstimatedPrice()
                self.tbSpecialConditions.reloadData()
                self.tbSpecialConditionsHeight.constant = CGFloat(HEIGHT_CELL_SPE_CODIONTION * self.condition.count)
            }else{
                Toast(text: message, duration: 2).show()
            }
        })
    }
    func getCate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getCate(uid: nil){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
               self.cates = response as? [CateObj] ?? [CateObj]()
                self.jobEstimatedPrice()
                self.showDropdown(data: self.cates.map{$0.name ?? ""}, target: self.lbField, selectIndex: nil)
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
    func goJobDetail(){
		if AppDelegate.sharedInstance.mainTabbar?.selectedIndex == 0
		{
			DataCenter.sharedInstance.listJobVC?.bntRecruiting(UIButton())
			homeVC?.toListJob()
			self.navigationController?.popViewController(animated: true)
		}
		else
		{
			if (self.navigationController?.viewControllers.count ?? 0) >= 3{
			self.navigationController?.popToViewController(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 0) - 3] ?? UIViewController(), animated: true)
				//chon tab dang tuyen o man list
				self.superView?.superView?.bntRecruiting(UIButton())
			}
		}
    }
    func pickIMG(){
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        config.library.defaultMultipleSelection = true
        config.showsPhotoFilters = false
        config.library.skipSelectionsGallery = true
        config.startOnScreen = YPPickerScreen.library
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items
            {
                switch item {
                case .photo(let photo):
                    let imgObj = ImageObj()
                    imgObj.image = photo.image
                    self.imgRealWork.insert(imgObj, at: 0)
                case .video(let v):
                    return
                }
            }
            self.clViewAvatar.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    func showFullListImg(arrImg:[ImageObj],index:Int){
        var arrIdmImg = [IDMPhoto]()
        if arrImg.isEmpty{
            return
        }
        arrImg.forEach { (img) in
            if let idmImg = IDMPhoto.init(image:img.image)
            {
                arrIdmImg.append(idmImg)
            }
        }
        
        let idmPhoto = IDMPhotoBrowser(photos: arrIdmImg as [Any])
        idmPhoto?.setInitialPageIndex(UInt(index))
        idmPhoto?.displayToolbar = false
        self.present(idmPhoto ?? UIViewController(), animated: true, completion: nil)
    }
    
}
extension TaCreateViewController:UITableViewDataSource,UITableViewDelegate,ReportTimeCellDelegate{
    func deleteTime(indexTime: Int?) {
        if indexTime != nil && (indexTime ?? 0) < timeWordData.count
        {
            timeWordData.remove(at: indexTime ?? 0)
            if timeWordData.count == 0{
                self.lbMoney.text = ""
            }
            jobEstimatedPrice()
            tbTimeHeight.constant = CGFloat(HEIGHT_TABLE_TIME * timeWordData.count) + 30
            tbViewTime.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbViewTime{
            //return timeWordData.count
                return timeWordData.count
        }else if tableView == tbSpecialConditions{
            return condition.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbViewTime{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaPostJobTableViewCell", for: indexPath) as! TaPostJobTableViewCell
            cell.setup(obj:timeWordData[indexPath.row],indexCellTime:indexPath.row, isHiddenTime:false)
            cell.delegate = self
            cell.index = indexPath
            cell.delegateTimeCell = self
            return cell
        } else if tableView == tbSpecialConditions {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "TaTbSpecialConditionPostJobTableViewCell", for: indexPath) as! TaTbSpecialConditionPostJobTableViewCell
            cell.selectionStyle = .none
            cell.setup(obj: condition[indexPath.row])
           
            return cell
        }
        return UITableViewCell()
    }

    fileprivate func selecCondition(_ index: Int) {
        condition[index].isSelected = !condition[index].isSelected
        if condition[index].isSelected{
            conditionSelect.append(condition[index])
        }else{
            conditionSelect.removeAll { (obj) -> Bool in
                obj.internalIdentifier == condition[index].internalIdentifier
            }
        }
        self.tbSpecialConditions.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbViewTime{
//            for item in timeWordData{
//                if Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", item.startDate) == "Thời gian bắt đầu" || Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", item.endDate) == "Thời gian kết thúc"{
//                    tbViewTime.reloadData()
//                }else{
//                   return
//                }
//            }

        }
        else if tableView == tbSpecialConditions{
            selecCondition(indexPath.row)
            jobEstimatedPrice()
        }
    }
}
extension TaCreateViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ReportIMGCellDelegate{
    func deleteIMG(indexImg: Int?) {
        if indexImg != nil && (indexImg ?? 0) < imgRealWork.count
        {
            imgRealWork.remove(at: indexImg ?? 0)
            clViewAvatar.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgRealWork.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaClPostJobCollectionViewCell", for: indexPath) as! TaClPostJobCollectionViewCell
        //imgRealWork.count
        if indexPath.row == 0{
            //icon anh them
            cell.imgPostJob.image = UIImage.init(named: "ic_add_cl")
            cell.btnDelete.isHidden = true
        }
        else
        {
            //ảnh trong list
            cell.setup(img: imgRealWork[indexPath.row - 1],indexCell: indexPath.row - 1,isHidden: false)
            cell.delegate = self
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 123
        var width:CGFloat = 132
        return CGSize.init(width: width, height: height)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! TaClPostJobCollectionViewCell
//        if let img =  cell.imgPostJob.image
//        {
//            self.showFullImg(img: img)
//        }
        if indexPath.row == 0{
            //self.choiseImg()
            pickIMG()
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! TaClPostJobCollectionViewCell
            if let _ =  cell.imgPostJob.image
            {
                self.showFullListImg(arrImg: imgRealWork, index: indexPath.row)
            }
        }
            

    }
    
    ///check cac ca khong trung lên nhau
    func validateTime(date:Date, isChooseEnd:Bool, index:Int) -> Bool{
        for i in 0 ..< timeWordData.count{
            let time = timeWordData[i]
            if i != index{
                if date > (time.startDate ?? Date()) && date < (time.endDate ?? Date()){
                    self.view.showToast(message: "Khoảng thời gian giữa các ca không được trùng nhau.", position: .top)
                    return false
                }
                if isChooseEnd{
                    if date >= (time.endDate ?? Date()) && (timeWordData[index].startDate ?? Date()) <= (time.startDate ?? Date()){
                        self.view.showToast(message: "Khoảng thời gian giữa các ca không được trùng nhau.",position: .top)
                        return false
                    }
                }else{
                    if time.startDate != nil && date == (time.startDate ?? Date()){
                        self.view.showToast(message: "Khoảng thời gian giữa các ca không được trùng nhau.",position: .top)
                        return false
                    }
                }
            }
            else{
                if (time.startDate ?? Date()) > (date) && isChooseEnd {
                    self.view.showToast(message: "Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc.", position: .top)
                    return false
                }
            }
        }
        
        return true
    }
    
}
extension TaCreateViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let imgObj = ImageObj()
            imgObj.image = pickedImage.fixedOrientation()
//            imgRealWork.append(imgObj)
            imgRealWork.insert(imgObj, at: 0)
            clViewAvatar.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension TaCreateViewController:choiceTimeDelege
{
    func choiceTime(index: IndexPath, isChoiceStart: Bool) {
        self.indexSelect = index.row
        self.isStartTime = isChoiceStart
        //self.showAlertTime()
    }
    func choiceDate(valuaDate: Date?, index: IndexPath, isChoiceStart: Bool) {
        if index.row < timeWordData.count {
            if validateTime(date: valuaDate ?? Date(), isChooseEnd: !isChoiceStart, index: index.row){
                if isChoiceStart{
                    timeWordData[index.row].startDate = valuaDate
                }else{
                    timeWordData[index.row].endDate = valuaDate
                }
                jobEstimatedPrice()
                tbViewTime.reloadData()
            }
        }
    }
}
extension TaCreateViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtAmount
        {
            //check phone number
            if Int(string) == nil && string != "" {
                return false
            }
            //kiểm tra so dien thoai ko lon hon 11 so
            if textField.text?.count == 11 && string != "" {
                return false
            }
        }else if textField == txtPhoneManager {
            if textField.text?.count == 9 && string != ""{
                //show nút v
                //CheckPhone.isHidden = false
            }
            if textField.text?.count == 10 && string != ""{
                return false
            }
            if textField.text?.count == 10 && string == ""{
                //CheckPhone.isHidden = true
            }
            return true
        }
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtAmount == textField{
            self.jobEstimatedPrice()
        }
    }
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension TaCreateViewController:ChooisePlaceDelegate
{
    func chooiceStartPoint(data: GGPlaceObj) {
        lbAddress.text = data.addr ?? ""
        lbAddress.textColor = UIColor.black
        lbAddress.font = UIFont.init(name: "Muli-Bold", size: 14)
        //currentLoc = CLLocation.init(latitude: data.lat ?? 0, longitude: data.long ?? 0)
        place = data
    }
    func chooiceEndPoint(data: GGPlaceObj) {
        lbAddress.text = data.addr ?? ""
        place = data
        lbAddress.font = UIFont.init(name: "Muli-Bold", size: 14)
        lbAddress.textColor = UIColor.black
    }
}
extension TaCreateViewController:ChoiseWorkerDelegate
{
    func choiseSuccess(worker: [UserWorkers], reason: String?) {
        var idCheck = [String]()
        if !worker.isEmpty
        {
            idCheck = worker.filter { (item) -> Bool in
                return item.isChecked
                }.map{$0.internalIdentifier ?? ""}
        }
        
        jobCreate(idCheck: Utilitys.jsonParser(parameters: idCheck))
            //self.doneWork(idWorker: idCheck)
    }
}
