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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    @IBOutlet weak var txtPhone: SSTextField!
    @IBOutlet weak var txtEmail: SSTextField!
    @IBOutlet weak var txtBirthday: SSTextField!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbJobCate: UILabel!
    @IBOutlet weak var viewColection: UIView!
    @IBOutlet weak var viewEdit: UIView!
    //    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var ClProfile: UICollectionView!
    @IBOutlet weak var btnBirthday: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewClProfile: UIView!
    @IBOutlet weak var lbAccount: UILabel!
      @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var stackViewData: UIStackView!
    @IBOutlet weak var stackViewBT: UIStackView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lbGioiTinh: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbCodeUser: UILabel!
    var profile:UserObj?
     var imgRealWork = [ImageObj]()
    var numberRequest = 0
    var imageSelected:UIImage?
    var birthday:Date = Date()
    var refreshControl = UIRefreshControl()
    var heightVC:CGFloat = 350
    override func viewDidLoad() {
        super.viewDidLoad()
        //isShowMenuButton = true
        if #available(iOS 10.0, *) {
            self.scrollView?.refreshControl = refreshControl
        } else {
            self.scrollView?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        ClProfile.register(UINib(nibName: "TAProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAProfileCollectionViewCell")
        ClProfile.delegate = self
        ClProfile.dataSource = self
        isShowNoti = true
        isShowHeader = true
        self.title = "Thông tin"
        isHiddenBottomBar = false
        //getDetaiUser()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
        if DataCenter.sharedInstance.currentUser?.status == 1{
            self.lbStatus.isHidden = true
            self.viewEdit.isHidden = true
        }else{
            self.lbStatus.isHidden = false
            self.viewEdit.isHidden = false
        }
        stackViewData.isHidden = true
        viewEdit.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        arrTxtEdit = [txtEmail,txtBirthday,txtPhone]
        self.profile = DataCenter.sharedInstance.currentUser
        if self.profile == nil
        {
            getDetaiUser()
        }
        else
        {
            setupData()
        }
        
        
        
    }
    @IBAction func onViewAll(_ sender: Any) {
        btnViewAll.isSelected = !btnViewAll.isSelected
        if btnViewAll.isSelected{
            
            stackViewData.isHidden = false
            stackViewBT.isHidden = true
//            viewEdit.isHidden = false
        }else{
            stackViewData.isHidden = true
            stackViewBT.isHidden = false
            viewEdit.isHidden = true
        }
    }
    @IBAction func onRequestMoney(_ sender: Any) {
        let requestVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TaPopUpBankInFoViewController") as! TaPopUpBankInFoViewController
        requestVC.profile = profile
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
        customPresentViewController(presenter, viewController: requestVC, animated: true)
    }
    @IBAction func onPhoneInfo(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn đang yêu cầu trợ giúp,liên hệ với The Ant theo số \(DataCenter.sharedInstance.currentUser?.hotline ?? "") để được trợ giúp?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Huỷ ", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Liên hệ", style: .default, handler: { (alertView) in
            self.call(phoneNumber: DataCenter.sharedInstance.currentUser?.hotline ?? "")
        })
        )
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func onInfoBank(_ sender: Any) {
        let bankInfoVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TaBankInfoViewController") as! TaBankInfoViewController
        bankInfoVC.profile = profile
        self.navigationController?.pushViewController(bankInfoVC, animated: true)
    }
    @IBAction func onHistoryPayment(_ sender: Any) {
        let historyPayMentVC = QuandaStoryBoard.instantiateViewController(withIdentifier: "TaHistoryPayMentViewController") as! TaHistoryPayMentViewController
        self.navigationController?.pushViewController(historyPayMentVC, animated: true)
    }
    @IBAction func onChuyenKhoanTT(_ sender: Any) {
        let payATMVC:TaNewsDetailViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TaNewsDetailViewController") as! TaNewsDetailViewController
        payATMVC.isCheckVC = true
        self.navigationController?.pushViewController(payATMVC, animated: true)
    }
    @IBAction func aboutUs(_ sender: Any) {
        let aboutUsVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TAAboutUsViewController") as! TAAboutUsViewController
        self.navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    @IBAction func onChooseCate(_ sender: Any) {
        let cateVC = JobStoryBoard.instantiateViewController(withIdentifier: "TaCateViewController") as! TaCateViewController
        cateVC.profile = profile
        self.navigationController?.pushViewController(cateVC, animated: true)
    }
    @IBAction func logoutPress(_ sender: Any) {
            let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                Services.shareInstance.logout(block: { (response, message, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    Toast.init(text: message, delay: 0, duration: 2.0).show()
                    UserObj.removeDataUser()
                    DataCenter.sharedInstance.token = ""
                    let loginVC = MainStoryBoard.instantiateViewController(withIdentifier: "TALoginViewController") as! TALoginViewController
                    
                    AppDelegate.sharedInstance.mainNavigation?.viewControllers = [loginVC]
                })
                
            }))
            self.present(alertVC, animated: true, completion: nil)
    }
    
    func setupData(){
        if profile != nil{
            lbCodeUser.text = "Mã người dùng:\(self.profile?.code ?? "")"
            lbCode.text = self.profile?.code ?? ""
            lbName.text = self.profile?.name ?? ""
            lbStar.text = "\(self.profile?.rate ?? 0)"
            txtPhone.text = self.profile?.phone ?? ""
            txtEmail.text = self.profile?.email ?? ""
            txtBirthday.text = self.profile?.birthday ?? ""
            lbAddress.text = self.profile?.address ?? ""
            lbAccount.text = self.profile?.price ?? ""
            imgAva.sd_setImage(with: URL.init(string: profile?.avatar ?? ""), placeholderImage: nil, options: .refreshCached,  completed: nil)
            lbDesc.text = self.profile?.desc ?? ""
            lbGioiTinh.text = self.profile?.subType.des() 
        }
        for imgEdit in profile?.images ?? [ImageObj()]{
            imgRealWork.append(ImageObj.init(url: imgEdit ))
            ClProfile.reloadData()
        }
        if self.profile?.images?.count ?? 0 == 0
        {
            self.viewColection.isHidden = true
        }
        else
        {
            self.viewColection.isHidden = false
            self.ClProfile.reloadData()
        }
    }
    @objc func reloadData()  {
        getDetaiUser()
    }
     func getDetaiUser(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getMyProfileDetai{(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.ClProfile?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE
            {
                DataCenter.sharedInstance.currentUser = response as? UserObj ?? UserObj()
                self.profile = response as? UserObj ?? UserObj()
                if DataCenter.sharedInstance.currentUser?.status == 1{
                    self.lbStatus.isHidden = true
                    self.viewEdit.isHidden = true
                }else{
                    self.lbStatus.isHidden = false
                    self.viewEdit.isHidden = false
                }
                self.ClProfile.reloadData()
                self.setupData()
            }
            else
            {
                Toast(text: message, duration: 2).show()
            }
            
        }
    }
    @IBAction func btnChangePass(_ sender: Any) {
        let changePassVC:TAChangePassViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAChangePassViewController") as! TAChangePassViewController
        changePassVC.isChangePassword = true
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    @IBAction func statisticPress(_ sender: Any) {
        let staticalVC:TAStaticsViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAStaticsViewController") as! TAStaticsViewController
        self.navigationController?.pushViewController(staticalVC, animated: true)
    }
    @IBAction func editPress(_ sender: Any) {
        let editRegisterVC:TaEditProfileViewController = AccountStoryBoard.instantiateViewController(withIdentifier: "TaEditProfileViewController") as! TaEditProfileViewController
        editRegisterVC.profile = profile
        editRegisterVC.superView = self
        self.navigationController?.pushViewController(editRegisterVC, animated: true)
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
        return profile?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAProfileCollectionViewCell", for: indexPath) as! TAProfileCollectionViewCell
        cell.setupData(obj: profile?.images?[indexPath.row] ?? ImageObj())
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
