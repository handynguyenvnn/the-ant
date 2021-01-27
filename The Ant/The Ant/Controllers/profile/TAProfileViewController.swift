//
//  TAProfileViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/2/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
import SwiftyJSON
import DatePickerDialog
import Presentr
import IDMPhotoBrowser
class TAProfileViewController: BaseViewController {
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var txtPhone: SSTextField!
    @IBOutlet weak var txtEmail: SSTextField!
    @IBOutlet weak var txtBirthday: SSTextField!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbJobCate: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var ClProfile: UICollectionView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBirthday: UIButton!
    @IBOutlet weak var btnHuy: UIButton!
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewBirthday: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var stackviewData: UIStackView!
    @IBOutlet weak var stackviewBT: UIStackView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lbGroup: UILabel!
    @IBOutlet weak var scrollViewReLoad: UIScrollView!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbCodeUser: UILabel!
    var profile:UserObj?
    var numberRequest = 0
    var imageSelected:UIImage?
    var birthday:Date = Date()
    var imgRealWork = [ImageObj]()
    var heightVC:CGFloat = 368
    /// số những ảnh mới đc update
    var countUpLoadImg:Int = 0
    var refreshControl = UIRefreshControl()
//    var isEdit = false
//    {
//        didSet
//        {
//            btnEdit.isSelected = isEdit
//            updateUIEdit()
//        }
//    }
    var arrTxtEdit = [SSTextField]()
    override func viewDidLoad() {
        super.viewDidLoad()
        isHiddenBottomBar = false
        ClProfile.register(UINib(nibName: "TAProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAProfileCollectionViewCell")
        ClProfile.delegate = self
        ClProfile.dataSource = self
        isShowNoti = true
        isHeaderProfile = true
        //btnBirthday.isHidden = true
        self.title = "Thông tin"
//        fillData()
        //getDetaiUser()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
        stackviewData.isHidden = true
        viewEdit.isHidden = true
//        if profile?.status == 1 {
//            btnEdit.isHidden = true
//        }else{
//            btnEdit.isHidden = false
//        }
        if #available(iOS 10.0, *) {
            self.scrollViewReLoad?.refreshControl = refreshControl
        } else {
            self.scrollViewReLoad?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
    }
    @objc func reloadData()  {
        getDetaiUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrTxtEdit = [txtEmail,txtBirthday]
        self.profile = DataCenter.sharedInstance.currentUser
        if self.profile == nil
        {
            getDetaiUser()
        }
        else
        {
            fillData()
        }
    }
    
    @IBAction func onPhoneInfo(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn đang yêu cầu trợ giúp,liên hệ với The Ant theo số \(DataCenter.sharedInstance.currentUser?.hotline ?? "") để được trợ giúp?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Huỷ ", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Liên hệ", style: .default, handler: { (alertView) in
            Utilitys.call(phoneNumber: DataCenter.sharedInstance.currentUser?.hotline ?? "")
        })
        )
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func onBtViewHeader(_ sender: Any) {
        btnViewAll.isSelected = !btnViewAll.isSelected
        if btnViewAll.isSelected{
            stackviewData.isHidden = false
            stackviewBT.isHidden = true
            viewEdit.isHidden = false
        }else{
            stackviewData.isHidden = true
            stackviewBT.isHidden = false
            viewEdit.isHidden = true
        }
        
    }
    @IBAction func onHistoryPayment(_ sender: Any) {
        let historyPaymentVC = QuanStoryBoard.instantiateViewController(withIdentifier: "TaHistoryPayMentViewController") as! TaHistoryPayMentViewController
        self.navigationController?.pushViewController(historyPaymentVC, animated: true)
    }
    @IBAction func btnAboutUs(_ sender: Any) {
        let AboutUsVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TAAboutUsViewController") as! TAAboutUsViewController
        self.navigationController?.pushViewController(AboutUsVC, animated: true)
    }
    @IBAction func onCancel(_ sender: Any) {
    }
    func checkData() -> Bool{
        for txt in arrTxtEdit {
            if (txt.isEmpTy()) && (txt.isRequired){
                self.view.showToast(message: txt.msgWhenEmpty, position: .top)
                return false
            }
        }
        return true
    }
    @IBAction func onRate(_ sender: Any) {
        let rateVC:TaListRateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaListRateViewController") as! TaListRateViewController
        rateVC.profile = profile
        self.navigationController?.pushViewController(rateVC, animated: true)
    }
    @IBAction func onEdit(_ sender: Any) {
        let editProfileVC:TaEditProfileViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaEditProfileViewController") as! TaEditProfileViewController
        editProfileVC.profile = profile
        editProfileVC.superView = self
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    @IBAction func logoutPress(_ sender: Any) {
            let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                Services.shareInstance.logout(block: { (response, message, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    Toast.init(text: message, delay: 0, duration: 1.5).show()
                    UserObj.removeDataUser()
                    DataCenter.sharedInstance.token = ""
                    let loginVC = MainStoryBoard.instantiateViewController(withIdentifier: "TALoginViewController") as! TALoginViewController
                    
                    AppDelegate.sharedInstance.mainNavigation?.viewControllers = [loginVC]
                })
                
            }))
            self.present(alertVC, animated: true, completion: nil)
    }
    func fillData(){
        if profile != nil {
        lbCode.text = self.profile?.code ?? ""
        lbName.text = self.profile?.name ?? ""
        lbStar.text = "\(self.profile?.rate ?? 0)"
        txtPhone.text = self.profile?.phone ?? ""
        txtEmail.text = self.profile?.email ?? ""
        txtBirthday.text = self.profile?.birthday ?? ""
        lbAddress.text = self.profile?.address ?? ""
        lbBalance.text = self.profile?.price ?? ""
            lbCodeUser.text = "Mã người dùng :\(self.profile?.code ?? "")"
        imgAva.sd_setImage(with: URL.init(string: profile?.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options:.queryDiskDataSync, completed: nil)
        lbDesc.text =  self.profile?.decs ?? ""
        lbGroup.text = self.profile?.subType.des()
        for imgEdit in profile?.images ?? [ImageObj()]{
            imgRealWork.append(ImageObj.init(url: imgEdit ))
            ClProfile.reloadData()
            }
        }
        if self.profile?.images?.count ?? 0 == 0 {
            self.viewCollection.isHidden = true
        }else{
             self.viewCollection.isHidden = false
            self.ClProfile.reloadData()
        }
    }
    func getDetaiUser(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getMyProfileDetai{(response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            if error == SUCCESS_CODE
            {
                self.profile = response as? UserObj ?? UserObj()
                self.fillData()
            }
            else
            {
                Toast(text: message, duration: 2).show()
            }
            
        }
    }
    @IBAction func onLinhVuc(_ sender: Any) {
        let CateFavVC:TaCateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaCateViewController") as! TaCateViewController
        self.navigationController?.pushViewController(CateFavVC, animated: true)
    }
    //birthday: Utilitys.stringToDate(withFormat: "YYYY-MM-dd", strDate: txtBirthday.text ?? "") ?? Date()
    @IBAction func onStatical(_ sender: Any) {
        let StaticalVC:TAStaticsViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAStaticsViewController") as! TAStaticsViewController
        self.navigationController?.pushViewController(StaticalVC, animated: true)
    }
 
    @IBAction func onChangePass(_ sender: Any) {
        let changePassVC:TAChangePassViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAChangePassViewController") as! TAChangePassViewController
        changePassVC.isChangePassword = true
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    @IBAction func theAntInfoPress(_ sender: Any) {
//        let detailPopUpVc:TAEvaluateViewController = QuanStoryBoard.instantiateViewController(withIdentifier: "TAEvaluateViewController") as! TAEvaluateViewController
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
    }
    @IBAction func statisticPress(_ sender: Any) {
        let CateVC:TaCateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaCateViewController") as! TaCateViewController
        self.navigationController?.pushViewController(CateVC, animated: true)
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
extension TAProfileViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile?.images?.count ?? +1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAProfileCollectionViewCell", for: indexPath) as! TAProfileCollectionViewCell
        cell.setupData(obj:profile?.images?[indexPath.row] ?? ImageObj())
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ClProfile.frame.height, height: ClProfile.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TAProfileCollectionViewCell
        if let img =  cell.imgAva.image
        {
            self.showFullListImg(arrImg: profile?.images ?? [ImageObj](), index: indexPath.row)
        }
    }
    
}
extension TAProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgAva.image = pickedImage
            imageSelected = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
