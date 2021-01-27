//
//  TaJobDetailViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 7/12/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
import IDMPhotoBrowser
import SDWebImage
enum STATUS_TYPE : Int{
    case finish = 1
    case noFinish = 0
}
class TaJobDetailViewController: BaseViewController {
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewMoneyAuth: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnPhoneHr: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lbTrangThai: UILabel!
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDecs: UILabel!
    @IBOutlet weak var lbMota: UILabel!
    @IBOutlet weak var lbHinhAnh: UILabel!
    @IBOutlet weak var lbDieuKien: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbNameHR: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnDone: UIButton!
//    @IBOutlet weak var lbMoneyThanhToans: UILabel!
//    @IBOutlet weak var lbThanhToan: UILabel!
    @IBOutlet weak var btnPhoneHR: UIButton!
    @IBOutlet weak var lbPhoneHR: UILabel!
    @IBOutlet weak var lbProGress: UILabel!
    @IBOutlet weak var lbProgress: UIProgressView!
    @IBOutlet weak var lbStaff: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbFeild: UILabel!
    @IBOutlet weak var lbWork: UILabel!
    @IBOutlet weak var clViewDetail: UICollectionView!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var btnDungcongviec: UIButton!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var btnNhanCongViec: UIButton!
    @IBOutlet weak var clViewAva: UICollectionView!
    /// view của table view user work
    @IBOutlet weak var viewUserWork: UIView!
    /// view của điểu kiện đặc biệt
    @IBOutlet weak var viewDieuKienDacBiet: UIView!
    /// view của giấy tờ tuỳ thân
    @IBOutlet weak var viewGiayToTuyThan: UIView!
    @IBOutlet weak var stButton: UIStackView?
    @IBOutlet weak var ctHeightTbCondition:NSLayoutConstraint?
    @IBOutlet weak var tbTime: UITableView!
    @IBOutlet weak var viewHeightTbTime: NSLayoutConstraint!
    @IBOutlet weak var lbCurrentPrice: UILabel!
    @IBOutlet weak var lbRealPrice: UILabel!
     @IBOutlet weak var viewPhoneHR: UIView!
    var refreshControl = UIRefreshControl()
    var user = [UserObj]()
    var jobObj:TAJobObj?
    var jobId:String?
    var condition = [ConditionObj]()
    var conditionSelect = [ConditionObj]()
    var userWork = [UserWorkers]()
    var currentStore:UserObj?
    var typeBid:TYPE_BID = .NORMAL
    ///đc chuyển từ màn nào
    var fromVC:UIViewController?
    var isOnline = false
    var superView:TAHomeViewController?
    var superViewJob:TAJobViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeader = true
        isShowNoti = true
        isHiddenBottomBar = true
        self.title = "Chi tiết công việc"
//        lbThanhToan.adjustsFontSizeToFitWidth = true
        lbMota.adjustsFontSizeToFitWidth = true
        lbHinhAnh.adjustsFontSizeToFitWidth = true
        lbDieuKien.adjustsFontSizeToFitWidth = true
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(UINib.init(nibName: "TaTbSpecialConditionTableViewCell", bundle: nil), forCellReuseIdentifier: "TaTbSpecialConditionTableViewCell")
        tbTime.dataSource = self
        tbTime.delegate = self
        tbTime.register(UINib.init(nibName: "TaTimeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "TaTimeDetailTableViewCell")
        clViewDetail.dataSource = self
        clViewDetail.delegate = self
        clViewDetail.register(UINib.init(nibName: "TaClDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaClDetailCollectionViewCell")
        clViewAva.dataSource = self
        clViewAva.delegate = self
        clViewAva.register(UINib.init(nibName: "TaClAvaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaClAvaCollectionViewCell")
        if #available(iOS 10.0, *) {
            self.scrollView?.refreshControl = refreshControl
        } else {
            self.scrollView?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        getInfoJob()

        // Do any additional setup after loading the view.
    }
    @objc func reloadData()  {
        getInfoJob()
    }
    @IBAction func onCallPhoneHR(_ sender: Any) {
       Utilitys.call(phoneNumber: jobObj?.hr_phone ?? "")
    }
    @IBAction func onCallPhone(_ sender: Any) {
        Utilitys.call(phoneNumber: jobObj?.user?.phone ?? "")
    }
    @IBAction func onAddress(_ sender: Any) {
        let mapVC:TaMapViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaMapViewController") as! TaMapViewController
        mapVC.jobObj = jobObj
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    @IBAction func onDone(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn nhận hoàn thành công việc không?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
            self.resolvedJob(isDone: true)
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    @IBAction func onCancel(_ sender: Any) {
        
            self.cancelWorder()
        
    }
    func getInfoJob(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getjobDetail(id:jobObj?.internalIdentifier ?? jobId ?? ""){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            if errorCode == SUCCESS_CODE{
                self.jobObj = response as? TAJobObj ?? TAJobObj()
                self.fillDataJob()
                self.checkShowBtn()
                self.tbView.reloadData()
                self.clViewAva.reloadData()
                self.clViewDetail.reloadData()
                self.tbTime.reloadData()
                // công thức tính height bằng số cell cho table
                
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
    @IBAction func onStopJob(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn dừng công việc không?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
            self.resolvedJob(isDone: false)
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    func resolvedJob(isDone:Bool){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.resolvedJob(jid: self.jobObj?.internalIdentifier ?? "", isDone: isDone) { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                self.getInfoJob()
                self.superViewJob?.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func onAccepJob(_ sender: Any) {
        let firstTime = self.jobObj?.timeWork?.first
        let minTime = NSCalendar.current.date(byAdding: .minute, value: -10, to: firstTime?.timeWork.startDate ?? Date()) ?? Date()
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn nhận việc không?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
            
            if minTime <= Date() {
                self.view.showToast(message: "Bạn đã quá thời gian nhận công việc", position: .top)
            }else{
                self.bid()
            }
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func bid(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.bidRequest(jid: self.jobObj?.internalIdentifier ?? "", decs: self.lbDecs.text ?? ""){ (response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, delay: 0, duration: 2.0).show()
            if error == SUCCESS_CODE
            {
                self.btnNhanCongViec.isHidden = true
                self.superView?.reloadData()
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
    }
    @IBAction func btnToProfile(_ sender: Any) {
        let profileVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TAProfileHrViewController") as! TAProfileHrViewController
        // truyền thông tin công việc sang profile
        profileVC.detailJob = jobObj
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    func checkShowBtn()
    {
        if fromVC is TAHomeViewController
        {
            // xem chi tiết công việc từ màn HOME
             btnNhanCongViec.isHidden = !self.isOnline
            btnPhoneHr.isHidden = true
            lbPhone.isHidden = true
            // return - khi thực hiện xong back ra khỏi hàm
            return
        }
        //Công việc mới
        switch jobObj!.statusJob {
        case .NEW:
            //Công việc mới và đã nhận
            if jobObj?.isBid ?? false{
                //show nút hủy
                btnCancel.isHidden = false
            }
                //Công việc mới và chưa nhận
            else{
                //Show nút nhận công việc
                btnNhanCongViec.isHidden = false
            }
                break
        case STATUS_JOB.InProgress:
            btnDungcongviec.isHidden = false
            btnDone.isHidden = false
            break
        case STATUS_JOB.CANCEL:
            
            break
        case STATUS_JOB.DONE:
             // thêm dấu sao để đánh giá và không show nút gì
            
            break
        default:
            break
        }
    }
    fileprivate func cancelWork(reason:String,idWorker:[String]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.cancelWorker(jid:self.jobObj?.category?.internalIdentifier ?? ""){(response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if error == SUCCESS_CODE{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func cancelWorder(){
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn hủy công việc không?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Services.shareInstance.cancelWorker(jid: self.jobObj?.internalIdentifier ?? ""){ (response, message, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                Toast.init(text: message, delay: 0, duration: 2.0).show()
                if error == SUCCESS_CODE{
                    self.superViewJob?.reloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func fillDataJob(){
        if jobObj != nil{
            if jobObj?.status == 1 && jobObj?.isBid == false{
                viewMoneyAuth.isHidden = true
            }else if jobObj?.status == 3{
                viewMoneyAuth.isHidden = true
            }else{
                viewMoneyAuth.isHidden = false
            }
            var checkTime = ""
            lbNameHR.text = self.jobObj?.hr_name ?? ""
            lbPhoneHR.text = self.jobObj?.hr_phone ?? ""
            lbPhone.text = self.jobObj?.user?.phone ?? ""
            lbWork.text = self.jobObj?.name ?? ""
            lbStaff.text = "Nhân sự :\(self.jobObj?.personBid ?? 0)"
            lbFeild.text = self.jobObj?.category?.name ?? ""
            lbMoney.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(jobObj?.total_price ?? 0)" as AnyObject)) VNĐ"
            for time in self.jobObj?.timeWork ?? [TimeWork](){
                if checkTime == ""{
                    checkTime = "• \(time.startTime ?? "") - \(time.endTime ?? "")"
                }else{
                    checkTime = "\(checkTime)\n• \(time.startTime ?? "") - \(time.endTime ?? "")"
                }
            }
            viewStatus.backgroundColor = UIColor.init(hexString: self.jobObj?.status_color ?? "")
            lbTime.text = checkTime
            lbName.text = self.jobObj?.user?.name ?? ""
            imgAva.sd_setImage(with: URL.init(string: self.jobObj?.user?.avatar ?? "") , placeholderImage: nil, options: .refreshCached, completed: nil)
            lbProGress.text = "Tiến độ :\(self.jobObj?.percentCompleted ?? 0)%"
            lbDecs.text = self.jobObj?.content ?? ""
//            txtDecs.isEditable = false
            lbProgress.progress = Float(self.jobObj?.percentCompleted ?? 0 ) / 100
            if jobObj?.status == 2{
            lbTrangThai.text = "\(self.jobObj?.status_text ?? "") \((self.jobObj?.percentCompleted ?? 0 ))%"
            }else{
                lbTrangThai.text = "\(self.jobObj?.status_text ?? "")"
            }
            lbTrangThai.textColor = UIColor.init(hexString:  self.jobObj?.status_text_color ?? "")
            self.ctHeightTbCondition?.constant = CGFloat(self.jobObj?.condition?.count ?? 0) * TaTbSpecialConditionTableViewCell.heightCell
            self.viewHeightTbTime.constant = CGFloat(HEIGHT_CELL_TIME_DETAIL * (self.jobObj?.timeWork?.count ?? 0))
//            lbMoneyThanhToans.text = self.jobObj?.price ?? ""
            if jobObj?.status == 1 || jobObj?.status == 2 {
                if jobObj?.isBid == true||jobObj?.status == 2 {
                    lbPhone.isHidden = false
                    btnPhoneHr.isHidden = false
                    lbAddress.text = self.jobObj?.address ?? ""
                    imgAddress.isHidden = false
                    btnAddress.isHidden = false
                    viewPhone.isHidden = false
                    viewPhoneHR.isHidden = false
                    btnPhoneHR.isHidden = false
                    lbPhoneHR.isHidden = false
                }else{
                    lbPhone.isHidden = true
                    btnPhoneHr.isHidden = true
                    lbAddress.text = self.jobObj?.sub_address ?? ""
                    imgAddress.isHidden = true
                    viewPhone.isHidden = true
                    btnAddress.isHidden = true
                    viewPhoneHR.isHidden = true
                    btnPhoneHR.isHidden = true
                    lbPhoneHR.isHidden = true
                }
            }
            else{
                lbPhone.isHidden = true
                btnPhoneHr.isHidden = true
                lbAddress.text = self.jobObj?.sub_address ?? ""
                imgAddress.isHidden = true
                btnAddress.isHidden = true
                viewPhone.isHidden = true
                viewPhoneHR.isHidden = true
                btnPhoneHR.isHidden = true
                lbPhoneHR.isHidden = true
            }
        }
        clViewDetail.reloadData()
        if self.jobObj?.images?.count ?? 0 == 0 {
            self.viewGiayToTuyThan.isHidden = true
        }else{
            self.clViewDetail.reloadData()
        }
        
        if self.jobObj?.condition?.count ?? 0 == 0 {
            self.viewDieuKienDacBiet.isHidden = true
        }else{
            self.tbView.reloadData()
        }
        
        if self.jobObj?.userWorkers?.count ?? 0 == 0 {
            self.viewUserWork.isHidden = true
        }else{
            self.clViewAva.reloadData()
        }
        checkShowBtn()
        let currentUserWork = jobObj?.userWorkers?.filter{$0.internalIdentifier == DataCenter.sharedInstance.currentUser?.internalIdentifier}.first
        let realPrice = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(currentUserWork?.price ?? 0)" as AnyObject)) VNĐ"
        lbCurrentPrice.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(currentUserWork?.price_progress ?? 0)" as AnyObject)) VNĐ"
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: realPrice)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lbRealPrice.attributedText = attributeString
    }
    func showFullImg(img:UIImage)
    {
        if let idmImg = IDMPhoto.init(image: img)
        {
            let idmPhoto = IDMPhotoBrowser(photos: [idmImg] as [Any])
            idmPhoto?.displayToolbar = false
            self.present(idmPhoto ?? UIViewController(), animated: true, completion: nil)
        }
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
extension TaJobDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbView{
            return jobObj?.condition?.count ?? 0
        }else if tableView == tbTime {
            return jobObj?.timeWork?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaTbSpecialConditionTableViewCell", for: indexPath) as! TaTbSpecialConditionTableViewCell
            cell.selectionStyle = .none
            cell.fillData(obj: jobObj?.condition?[indexPath.row] ?? ConditionObj())
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaTimeDetailTableViewCell", for: indexPath) as! TaTimeDetailTableViewCell
        cell.selectionStyle = .none
        cell.setupData(obj: jobObj?.timeWork?[indexPath.row] ?? TimeWork(), indexCellTime: indexPath.row)
        return cell
    }
    // tính height table = số cell
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return TaTbSpecialConditionTableViewCell.heightCell
//    }
}
extension TaJobDetailViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clViewAva{
            return jobObj?.userWorkers?.count ?? 0
        }else if collectionView == clViewDetail{
            return jobObj?.images?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clViewAva{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaClAvaCollectionViewCell", for: indexPath) as! TaClAvaCollectionViewCell
            cell.fillData(obj: jobObj?.userWorkers?[indexPath.row] ?? UserWorkers())
            return cell
        }else if collectionView == clViewDetail{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaClDetailCollectionViewCell", for: indexPath) as! TaClDetailCollectionViewCell
            cell.fillDataDetail(obj: jobObj?.images?[indexPath.row] ?? ImageObj())
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 0
        var width:CGFloat = 0
        if collectionView == clViewDetail{
            height = self.clViewDetail.frame.height
            width = height
        }
        else if collectionView == clViewAva
        {
            height = self.clViewAva.frame.height
            width = height
        }
        return CGSize(width: height, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clViewDetail{
            let cell = collectionView.cellForItem(at: indexPath) as! TaClDetailCollectionViewCell
            if let img =  cell.imaDetail.image
            {
                self.showFullListImg(arrImg: jobObj?.images ?? [ImageObj](), index: indexPath.row)
            }
        }else if collectionView == clViewAva{
            
        }
        
    }
    
}

