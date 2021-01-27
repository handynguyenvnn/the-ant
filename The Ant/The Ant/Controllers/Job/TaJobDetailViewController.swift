//
//  TaJobDetailViewController.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
import Presentr
import IDMPhotoBrowser
enum TypeCompleteWork:Int {
    case DONE_100_PERCENT = 1
    case DONE_AT_NOW = 0
    case CANCEL = 2
    /// đăng lại công việc
    case RECREATE = 5
}
class TaJobDetailViewController: BaseViewController {

    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbManagerName: UILabel!
    @IBOutlet weak var txtDecs: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lbTrangThai: UILabel!
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbMota: UILabel!
    @IBOutlet weak var lbHinhAnh: UILabel!
    @IBOutlet weak var lbDieuKien: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnReUpJob: UIButton!
    @IBOutlet weak var lbMoneyThanhToans: UILabel!
    @IBOutlet weak var lbThanhToan: UILabel!
    @IBOutlet weak var lbProGress: UILabel!
    @IBOutlet weak var lbStaff: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbFeild: UILabel!
    @IBOutlet weak var lbWork: UILabel!
    @IBOutlet weak var clViewDetail: UICollectionView!
    @IBOutlet weak var btnPublishJob: UIButton!
    @IBOutlet weak var lbNameHR: UILabel!
    @IBOutlet weak var tbHeightTbView: NSLayoutConstraint!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var lbPhoneHr: UILabel!
    @IBOutlet weak var viewHeightClAva: NSLayoutConstraint!
    @IBOutlet weak var clViewAva: UICollectionView!
    @IBOutlet weak var viewHeightTbTime: NSLayoutConstraint!
    @IBOutlet weak var viewHeightTbUserWorker: NSLayoutConstraint!
    @IBOutlet weak var lbSTPTT: UILabel!
    @IBOutlet weak var lbProgress: UIProgressView!
    @IBOutlet weak var btnDungViec: UIButton!
    /// view của table view user work
    @IBOutlet weak var viewUserWork: UIView!
    /// view của điểu kiện đặc biệt
    @IBOutlet weak var viewDieuKienDacBiet: UIView!
    /// view của giấy tờ tuỳ thân
    @IBOutlet weak var viewGiayToTuyThan: UIView!
    @IBOutlet weak var tbTime: UITableView!
    @IBOutlet weak var tbUserWorker: UITableView!
    @IBOutlet weak var viewFoodter : UIView!
    @IBOutlet weak var lbTongSoTien: UILabel!
    @IBOutlet weak var lbCurrentPrice: UILabel!
    @IBOutlet weak var lbRealPrice: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewMoneyAll: UIView!
    @IBOutlet weak var btnPhoneHR: UIButton!
    var jobObj:TAJobObj?
    var jobId:String?
    var condition = [ConditionObj]()
    var userWork = [UserWorkers]()
    var cate:CateObj?
    var profile:UserObj?
    var typeDone:TypeCompleteWork?
    var isSelectedUser:Int = 0
    var heightVC:CGFloat = 368
    var superView:TAJobViewController?
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowHeader = true
        //isShowNoti = true
        isHiddenBottomBar = true
        isShowBackButton = true
        self.title = "Chi tiết công việc"
        lbThanhToan.adjustsFontSizeToFitWidth = true
        lbMota.adjustsFontSizeToFitWidth = true
        lbHinhAnh.adjustsFontSizeToFitWidth = true
        lbDieuKien.adjustsFontSizeToFitWidth = true
        lbSTPTT.adjustsFontSizeToFitWidth = true
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(UINib.init(nibName: "TaTbSpecialConditionTableViewCell", bundle: nil), forCellReuseIdentifier: "TaTbSpecialConditionTableViewCell")
        clViewDetail.dataSource = self
        clViewDetail.delegate = self
        clViewDetail.register(UINib.init(nibName: "TaClDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaClDetailCollectionViewCell")
        clViewAva.dataSource = self
        clViewAva.delegate = self
        clViewAva.register(UINib.init(nibName: "TaClAvaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaClAvaCollectionViewCell")
        tbTime.dataSource = self
        tbTime.delegate = self
        tbTime.register(UINib.init(nibName: "TaTimeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "TaTimeDetailTableViewCell")
        tbUserWorker.dataSource = self
        tbUserWorker.delegate = self
        tbUserWorker.register(UINib.init(nibName: "TaUserWorkerTableViewCell", bundle: nil), forCellReuseIdentifier: "TaUserWorkerTableViewCell")
        if jobObj?.statusJob == STATUS_JOB.DONE || jobObj?.statusJob == STATUS_JOB.InProgress {
            btnStar.isHidden = false
            imgStar.isHidden = false
        }else{
            btnStar.isHidden = true
            imgStar.isHidden = true
        }
        self.viewHeightTbTime.constant = CGFloat(HEIGHT_CELL_TIME_DETAIL * (self.jobObj?.timeWork?.count ?? 0))
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            self.scrollView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        getInfoUser()
    }
    
    
    @objc func reloadData()  {
        self.getInfoUser()
    }
    override func initUI() {
        //txtDecs.isEn = false
        btnReUpJob.isHidden = false
        btnDone.isHidden = false
        btnUpdate.isHidden = false
        btnCancel.isHidden = false
        btnPublishJob.isHidden = false
        btnDungViec.isHidden = false
        /// check từ đơn nháp vào
        if jobObj?.statusJob == STATUS_JOB.DRAFF {
            btnReUpJob.isHidden = true
            btnDone.isHidden = true
            btnCancel.isHidden = true
            btnDungViec.isHidden = true
            //btnUpdate.isHidden = true
        /// check từ hoạt động
        }else if jobObj?.statusJob == STATUS_JOB.InProgress{
            btnReUpJob.isHidden = true
            btnUpdate.isHidden = true
            btnPublishJob.isHidden = true
            //btnDone.isHidden = true
            btnCancel.isHidden = true
        }else if jobObj?.statusJob == STATUS_JOB.DONE || jobObj?.statusJob == STATUS_JOB.CANCEL {
            btnDone.isHidden = true
            btnPublishJob.isHidden = true
            btnCancel.isHidden = true
            btnUpdate.isHidden = true
            btnDungViec.isHidden = true
            //viewStatus.isHidden = true
            //btnReUpJob.isHidden = true
        }
        else if jobObj?.statusJob == STATUS_JOB.NEW {
            btnDone.isHidden = true
            btnPublishJob.isHidden = true
            btnUpdate.isHidden = true
            btnReUpJob.isHidden = true
            btnDungViec.isHidden = true
        }
//        if jobObj?.status == 1 {
//            btnUpdate.isHidden = true
//        }else{
//            btnUpdate.isHidden = false
//            //viewStatus.isHidden = false
//        }
    }
    // pictures: jobObj?.images ?? [ImageObj](), status: JOB_TRANGTHAI.Acctive
    @IBAction func onCallPhoneHR(_ sender: Any) {
    }
    @IBAction func onUserWorker(_ sender: Any) {
        let userWorker:TaListUserWorkerViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaListUserWorkerViewController") as! TaListUserWorkerViewController
        userWorker.jobObj = jobObj
        userWorker.detaiJobVC = self
        self.navigationController?.pushViewController(userWorker, animated: true)
    }
    @IBAction func onRateHistory(_ sender: Any) {
        let rateHistoryVC:TaListRateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaListRateViewController") as! TaListRateViewController
        rateHistoryVC.jobObj = jobObj
        self.navigationController?.pushViewController(rateHistoryVC, animated: true)
    }
    @IBAction func onDungViec(_ sender: Any) {
        let woker = self.jobObj?.userWorkers?.filter({ (item) -> Bool in
            return item.status == 2
        })
            self.typeDone = .DONE_AT_NOW
            TAPopupChoiseWorkerViewController.show(mainVC: self,type: .DONE_AT_NOW,dataWorker: woker)
//        }
//        alert.addAction(reup)
//        self.present(alert, animated: true)
    }
    @IBAction func onPublishJob(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn xoá công việc này không?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Không", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Đồng ý", style: .default, handler: { (alertView) in
            self.jobDelete()
        })
        )
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func onEdit(_ sender: Any) {
        let createJob:TaCreateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaCreateViewController") as! TaCreateViewController
        createJob.isEdit = true
        createJob.superView = self
        createJob.profile = jobObj
        self.navigationController?.pushViewController(createJob, animated: true)
    }
    @IBAction func onDangTuyenLai(_ sender: Any) {
        let createJob:TaCreateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaCreateViewController") as! TaCreateViewController
        createJob.profile = jobObj
        createJob.superView = self
        self.navigationController?.pushViewController(createJob, animated: true)
    }
    @IBAction func onDone(_ sender: Any) {
//        let alert = UIAlertController(title: "Chọn loại", message: "", preferredStyle: .actionSheet)
//        let done = UIAlertAction(title: "Hoàn thành công việc", style: .default) { (ACTION) in
        let woker = self.jobObj?.userWorkers?.filter({ (item) -> Bool in
            return item.status == 2
        })
            self.typeDone = .DONE_100_PERCENT
            TAPopupChoiseWorkerViewController.show(mainVC: self,type: .DONE_100_PERCENT,dataWorker: woker)
//        }
//        //self.jobObj?.userWorkers
//        let cancel = UIAlertAction(title: "Bỏ qua", style: .cancel) { (ACTION) in
//            print("cancel")
//        }
//        alert.addAction(done)
//        alert.addAction(cancel)
//        //alert.addAction(cancel)
//        
//        self.present(alert, animated: true)

    }
    fileprivate func cancelWork(reason:String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.CancelHR(jid:self.jobObj?.internalIdentifier ?? ""){(response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if error == SUCCESS_CODE{
                //self.superView?.reloadData()
                self.loadData()
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    func publishJob() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.publishJob(id: jobObj?.internalIdentifier ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                self.superView?.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func doneWork(idWorker:[String])  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.resolveJob(
            idJob: self.jobObj?.internalIdentifier ?? "",
        idWorker: idWorker,
        type: self.typeDone ??  .DONE_100_PERCENT) { (response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if error == SUCCESS_CODE{
                self.reloadData()
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn huỷ việc này không?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Không", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Đồng ý", style: .default, handler: { (alertView) in
            self.typeDone = .CANCEL
//            if self.jobObj?.userWorkers?.count == 0{
                self.cancelWork(reason: self.txtDecs.text ?? "")
            //}
            //TAPopupChoiseWorkerViewController.show(mainVC: self,type: .CANCEL,dataWorker: self.jobObj?.userWorkers)
        })
    )
        self.present(alertVC, animated: true, completion: nil)
    }
    func jobDelete(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.deleteJob(jid: jobObj?.internalIdentifier ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE {
                self.superView?.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func getInfoUser(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getjobDetail(id:jobObj?.internalIdentifier ?? jobId ?? ""){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            if errorCode == SUCCESS_CODE{
                self.jobObj = response as? TAJobObj ?? TAJobObj()
                self.initUI()
                self.loadData()
                self.tbView.reloadData()
                self.clViewAva.reloadData()
                self.tbUserWorker.reloadData()
                self.tbTime.reloadData()
                self.clViewDetail.reloadData()
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
    func loadData(){
        if jobObj != nil{
            var checkTime = ""
                //lbTongSoTien.text = ""
            lbPhoneHr.text = self.jobObj?.hr_phone ?? ""
            lbNameHR.text = self.jobObj?.hr_name ?? ""
            lbWork.text = self.jobObj?.name ?? ""
            lbName.text = jobObj?.user?.name ?? ""
            lbPhone.text = jobObj?.user?.phone ?? ""
            lbAddress.text = self.jobObj?.address ?? ""
            lbStaff.text = "Nhân sự :\(self.jobObj?.personBid ?? 0)/\(self.jobObj?.person ?? 0)"
            lbFeild.text = self.jobObj?.category?.name ?? ""
            lbMoney.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(jobObj?.total_price ?? 0)" as AnyObject))VNĐ"
            for time in self.jobObj?.timeWork ?? [TimeWork](){
                if checkTime == ""{
                    checkTime = "• \(time.startTime ?? "") - \(time.endTime ?? "")"
                }else{
                    checkTime = "\(checkTime)\n• \(time.startTime ?? "") - \(time.endTime ?? "")"
                }
            }
            viewStatus.backgroundColor = UIColor.init(hexString: self.jobObj?.status_color ?? "")
            //lbTime.text = checkTime
            imgAva.sd_setImage(with: URL.init(string: self.jobObj?.user?.avatar ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
            lbProGress.text = "Tiến độ :\(self.jobObj?.percentCompleted ?? 0)%"
            txtDecs.text = self.jobObj?.content ?? ""
            lbProgress.progress = Float(self.jobObj?.percentCompleted ?? 0 ) / 100
            // từ đơn nháp vào detail
            if jobObj?.statusJob == .DRAFF{
                viewStatus.isHidden = true
            }else{
                viewStatus.isHidden = false
                lbTrangThai.textColor = UIColor.init(hexString:  self.jobObj?.status_text_color ?? "")
            }
            // từ màn lịch sử xem công việc hoàn thành bao nhiêu %
            if jobObj?.statusJob == .DONE{
                lbTrangThai.text = "\(self.jobObj?.status_text ?? "") \((self.jobObj?.percentCompleted ?? 0 ))%"
            }else{
                lbTrangThai.text = "\(self.jobObj?.status_text ?? "")"
            }
            lbMoneyThanhToans.text = self.jobObj?.price ?? ""
            let realPrice = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(jobObj?.priceAll ?? 0)" as AnyObject))VNĐ"
            lbCurrentPrice.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(jobObj?.priceProgress ?? 0)" as AnyObject))VNĐ"
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: realPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            lbRealPrice.attributedText = attributeString
            // check list người lao
            if jobObj?.userWorkers?.count ?? 0 <= 4{
                tbUserWorker.tableFooterView = nil
                self.viewHeightTbUserWorker.constant = CGFloat(HEIGHT_CELL_USERWORKER * (self.jobObj?.userWorkers?.count ?? 0))
            }else{
                self.viewHeightTbUserWorker.constant = CGFloat((HEIGHT_CELL_USERWORKER * 4) + 30)
                tbUserWorker.tableFooterView = viewFoodter
            }
            self.tbHeightTbView.constant = CGFloat(HEIGHT_CELL_CODIONTION * (self.jobObj?.condition?.count ?? 0 ))
            self.viewHeightTbTime.constant = CGFloat(HEIGHT_CELL_TIME_DETAIL * (self.jobObj?.timeWork?.count ?? 0))
            if jobObj?.userWorkers?.count ?? 0 == 0{
                viewMoneyAll.isHidden = true
            }else{
                viewMoneyAll.isHidden = false
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
    }
}
extension TaJobDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbView{
        return jobObj?.condition?.count ?? 0
        }else if tableView == tbTime {
            return jobObj?.timeWork?.count ?? 0
        }else if tableView == tbUserWorker {
            if jobObj?.userWorkers?.count ?? 0 <= 4{
                return jobObj?.userWorkers?.count ?? 0
            }else{
                return 4
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// data điều kiện đặc biệt
        if tableView == tbView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaTbSpecialConditionTableViewCell", for: indexPath) as! TaTbSpecialConditionTableViewCell
        cell.selectionStyle = .none
        cell.fillData(obj: jobObj?.condition?[indexPath.row] ?? ConditionObj())
        return cell
        } else if tableView == tbTime{
            /// data của thời gian
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaTimeDetailTableViewCell", for: indexPath) as! TaTimeDetailTableViewCell
            cell.selectionStyle = .none
            cell.setupData(obj: jobObj?.timeWork?[indexPath.row] ?? TimeWork(), indexCellTime: indexPath.row)
            return cell
        }
        else if tableView == tbUserWorker{
            /// data list người lao động
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaUserWorkerTableViewCell", for: indexPath) as! TaUserWorkerTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            //if indexPath.row < jobObj?.userWorkers?.count ?? 0{
            cell.setupData(obj: jobObj?.userWorkers?[indexPath.row ] ?? UserWorkers(),isCheckStar: (jobObj?.userWorkers?[indexPath.row].status ?? -1 ) == STATUS_JOB.DONE.rawValue,indexStar: indexPath.row)
            //}
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbView{
            
        }else if tableView == tbTime{
            
        }else if tableView == tbUserWorker{
            let profileVC:TaProfileUserViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaProfileUserViewController") as! TaProfileUserViewController
            profileVC.curentUserWork = jobObj?.userWorkers?[indexPath.row]
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
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
            //cell.delegate = self
            cell.fillData(obj: jobObj?.userWorkers?[indexPath.row] ?? UserWorkers(),isCheckStar: jobObj?.statusJob == .DONE,indexStar: indexPath.row) //jobObj?.statusJob != .DONE
            return cell
        }else if collectionView == clViewDetail{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaClDetailCollectionViewCell", for: indexPath) as! TaClDetailCollectionViewCell
             cell.fillData(obj: jobObj?.images?[indexPath.row] ?? ImageObj())
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clViewAva{
        let profileVC:TaProfileUserViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaProfileUserViewController") as! TaProfileUserViewController
            profileVC.curentUserWork = jobObj?.userWorkers?[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
        }else if collectionView == clViewDetail{
            let cell = collectionView.cellForItem(at: indexPath) as! TaClDetailCollectionViewCell
            if let img =  cell.imaDetail.image
            {
                self.showFullListImg(arrImg: jobObj?.images ?? [ImageObj](), index: indexPath.row)
            }
        }
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
            height = (self.clViewAva.frame.height/2) - 10
            width = height
        }
        return CGSize(width: height, height: width)
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
//extension TaJobDetailViewController:choiceStarDelege{
//    func choiceStar(index: Int?) {
//
//        let detailPopUpVc:TAEvaluateViewController = QuanStoryBoard.instantiateViewController(withIdentifier: "TAEvaluateViewController") as! TAEvaluateViewController
//        detailPopUpVc.jobObj = jobObj
//        detailPopUpVc.currentUserRate = jobObj?.userWorkers?[index ??  0 ]
//        let yVC = (AppDelegate.sharedInstance.window?.center.y ?? 0) - heightVC/2
//        let presenter: Presentr = {
//            let width = ModalSize.custom(size: Float(self.view.frame.width) * (5/6))
//            let height = ModalSize.custom(size: Float(heightVC)) //ModalSize.fluid(percentage: 0.20)
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
//
//    }
//
//
//}
extension TaJobDetailViewController:choiceStarDelegateDetail,RateDelegete{
    func rateSuccess() {
        tbUserWorker.reloadData()
    }
    
    func choiceStarDetail(index: Int?) {
        
        let detailPopUp:TAEvaluateViewController = QuanStoryBoard.instantiateViewController(withIdentifier: "TAEvaluateViewController") as! TAEvaluateViewController
        detailPopUp.jobObj = jobObj
        detailPopUp.superView = self
        detailPopUp.delegate = self
        detailPopUp.currentUserRate = jobObj?.userWorkers?[index ??  0 ]
        let yVC = (AppDelegate.sharedInstance.window?.center.y ?? 0) - heightVC/2
        let presenter: Presentr = {
            let width = ModalSize.custom(size: Float(self.view.frame.width) * (5/6))
            let height = ModalSize.custom(size: Float(heightVC)) //ModalSize.fluid(percentage: 0.20)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: self.view.frame.width * (1/12), y: yVC))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType =  TransitionType.coverVertical
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.backgroundColor = .black
            customPresenter.backgroundOpacity = 0.3
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .bottom
            customPresenter.cornerRadius = 10
            return customPresenter
        }()
        customPresentViewController(presenter, viewController: detailPopUp, animated: true)
        
    }
    
    
}
extension TaJobDetailViewController:ChoiseWorkerDelegate
{
    func choiseSuccess(worker: [UserWorkers], reason: String?) {
        if self.typeDone == .CANCEL
        {
            self.cancelWork(reason: reason ?? "")
        }
        else
        {
            let idCheck = worker.filter { (item) -> Bool in
                return item.isChecked
            }.map{$0.internalIdentifier ?? ""}
            self.doneWork(idWorker: idCheck)
        }
    }
}

