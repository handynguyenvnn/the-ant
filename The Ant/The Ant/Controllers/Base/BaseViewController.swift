//
//  HDHomeViewController.swift
//  HVN MACs
//
//  Copyright © 2018 ViniCorp. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    var isShowBackButton:Bool = false
    var isTransParentBar:Bool = true
    var isHiddenBottomBar = true
    var isSetupNavigation = false
    var isShowNoti = false
    var isBackgroundGray = false
    var isHideNavigation = false
    var isShowShare = false
    var titleString:String = ""
    var isShowHeader = false
    var isShowHeaderJobDetail = false
    var isShowMenuButton = false
    var isShowLeftTitle = false
    var saveTitle = ""
    var isHeaderProfile = false
    var isHeaderMap = false
    var isShowHeaderNoti = false
    var btNoti:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if UIDevice.current.userInterfaceIdiom == .pad{
            
        }
        self.initData()
        self.initUI()
//         if isShowNoti{
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = isHideNavigation
        AppDelegate.sharedInstance.currentViewController = self
        if isBackgroundGray{
            if #available(iOS 11.0, *) {
                self.view.backgroundColor = UIColor.init(named: "FFFFFF")
            } else {
                // Fallback on earlier versions
            }
        }
        if !isSetupNavigation{
            if self.isShowBackButton {
                let imgLeft = UIImage.init(named: "ic_back")
                self.LeftBarButtonWithImage(imgLeft!)
            }
            if self.isShowNoti {
                if AppDelegate.sharedInstance.totalNotif > 0 {
                    let imgRight = UIImage.init(named: "ic_noti_push")
                    self.addNotiBtnPush(imgRight!)
                }else{
                    let imgRight = UIImage.init(named: "ic_noti")
                    self.addNotiBtnPush(imgRight!)
                }
            }
            if self.isTransParentBar {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.view.backgroundColor = UIColor.clear
            }
//            else
//            {
//                self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
//                self.navigationController?.navigationBar.tintColor = .white
//                self.navigationController?.navigationBar.backgroundColor = DEFAULT_COLOR
//                self.navigationController?.navigationBar.isTranslucent = false
//                self.navigationController?.navigationBar.barTintColor = .clear
//                self.navigationController?.view.backgroundColor = DEFAULT_COLOR
//                self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topbar"), for: UIBarMetrics.default)
//            }
////            if isShowNoti{
//                self.addNotiBtn()
//            }
            
            if isShowShare{
                self.addShareBtn()
            }
            if isShowHeader{
                setupHeader()
            }
            if isShowHeaderNoti{
                setupHeaderNoti()
            }
            if isHeaderProfile{
                setupHeaderProfile()
            }
            if isShowHeaderJobDetail{
                setupHeaderJobDetail()
            }
            if isHeaderMap{
                setupHeaderMap()
            }
            if isShowMenuButton{
                if AppDelegate.sharedInstance.menuButton == nil{
                    setupMenuButton()
                }
                else{
                    AppDelegate.sharedInstance.menuButton?.isHidden = false
                }
            }
            else{
                AppDelegate.sharedInstance.menuButton?.isHidden = true
            }
            if isShowLeftTitle{
                setupLeftTitle()
            }
            self.tabBarController?.tabBar.isHidden = isHiddenBottomBar
//
        }
    }
    func setupLeftTitle(){
        let viewLeft = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width * (2/3), height: 44)))
        let lbTitle = UILabel()
        lbTitle.frame = CGRect.init(x: 0, y: 0, width: viewLeft.frame.width, height: 25)
        lbTitle.center.y = viewLeft.center.y
        lbTitle.font = UIFont.init(name: "Muli-Bold", size: 20)
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
    func setupMenuButton(){
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        AppDelegate.sharedInstance.menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "ic_menu")!, rotatedImage: UIImage(named: "ic_menu_selected")!)
        AppDelegate.sharedInstance.menuButton?.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0 - (self.tabBarController?.tabBar.frame.height ?? 0)/2)
        if AppDelegate.sharedInstance.window != nil{
            AppDelegate.sharedInstance.window?.addSubview(AppDelegate.sharedInstance.menuButton!)
        }
        else{
            self.view.addSubview(AppDelegate.sharedInstance.menuButton!)
        }
        
        let item1 = ExpandingMenuItem.init(size: menuButtonSize, title: "Đăng việc", titleColor: DEFAULT_COLOR, image: UIImage.init(named: "ic_menu_add_job")!, highlightedImage: nil, backgroundImage: nil, backgroundHighlightedImage: nil) {
            let Job:TaCreateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaCreateViewController") as! TaCreateViewController
			Job.homeVC = DataCenter.sharedInstance.homeVC
//			AppDelegate.sharedInstance.mainNavigation?.pushViewController(Job, animated: true)
			
			DataCenter.sharedInstance.homeVC?.navigationController?.pushViewController(Job, animated: true)
            
        }
        let item2 = ExpandingMenuItem.init(size: menuButtonSize, title: "Nạp ví ANT", titleColor: DEFAULT_COLOR, image: UIImage.init(named: "ic_menu_wallet")!, highlightedImage: nil, backgroundImage: nil, backgroundHighlightedImage: nil) {
            let ATM:TANewDetailViewController = MainStoryBoard.instantiateViewController(withIdentifier: "TANewDetailViewController") as! TANewDetailViewController
            ATM.isCheckVC = true
            AppDelegate.sharedInstance.mainNavigation?.pushViewController(ATM, animated: true)
            
        }
        let item3 = ExpandingMenuItem.init(size: menuButtonSize, title: "Tra cứu", titleColor: DEFAULT_COLOR, image: UIImage.init(named: "ic_menu_search")!, highlightedImage: nil, backgroundImage: nil, backgroundHighlightedImage: nil) {
            let listAskedVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TAAboutUsViewController") as!TAAboutUsViewController
            listAskedVC.isFAQ = true
            AppDelegate.sharedInstance.mainNavigation?.pushViewController(listAskedVC, animated: true)
            
        }
        let item4 = ExpandingMenuItem.init(size: menuButtonSize, title: "Xét duyệt", titleColor: DEFAULT_COLOR, image: UIImage.init(named: "ic_verify")!, highlightedImage: nil, backgroundImage: nil, backgroundHighlightedImage: nil) {
            let list:TaListRequestCompleteViewController = JobStoryBoard.instantiateViewController(withIdentifier:"TaListRequestCompleteViewController") as! TaListRequestCompleteViewController
            AppDelegate.sharedInstance.mainNavigation?.pushViewController(list, animated: true)
        }
        AppDelegate.sharedInstance.menuButton?.addMenuItems([item1, item2, item3,item4])
    }
    func setupHeader(){
        let viewHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.2894))//0.2894 là tỷ lệ vùng màu xanh so với  màn hình
        viewHeader.clipsToBounds = true
        viewHeader.backgroundColor = DEFAULT_COLOR
        viewHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 38.0)
        self.view.addSubview(viewHeader)
        self.view.sendSubviewToBack(viewHeader)
    }
    func setupHeaderJobDetail(){
        let viewHeaderJobDetail = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 109))//0.2894 là tỷ lệ vùng màu xanh so với  màn hình
        viewHeaderJobDetail.clipsToBounds = true
        viewHeaderJobDetail.tag = 300
        viewHeaderJobDetail.backgroundColor = DEFAULT_COLOR
        //viewHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 38.0)
        self.view.addSubview(viewHeaderJobDetail)
        self.view.sendSubviewToBack(viewHeaderJobDetail)
    }
    func setupHeaderProfile(){
        let viewHeaderProfile = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 211))//0.2894 là tỷ lệ vùng màu xanh so với  màn hình
        
        viewHeaderProfile.clipsToBounds = true
        viewHeaderProfile.backgroundColor = DEFAULT_COLOR
        //viewHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 38.0)
        self.view.addSubview(viewHeaderProfile)
        self.view.sendSubviewToBack(viewHeaderProfile)
    }
    func setupHeaderNoti(){
        let height = self.navigationController?.navigationBar.frame.maxY ?? 65
        let viewHeaderProfile = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))//0.2894 là tỷ lệ vùng màu xanh so với  màn hình
        viewHeaderProfile.clipsToBounds = true
        viewHeaderProfile.backgroundColor = DEFAULT_COLOR
        //viewHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 38.0)
        self.view.addSubview(viewHeaderProfile)
        self.view.sendSubviewToBack(viewHeaderProfile)
    }
    func setupHeaderMap(){
        let viewHeaderMap = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))//0.2894 là tỷ lệ vùng màu xanh so với  màn hình
        viewHeaderMap.clipsToBounds = true
        viewHeaderMap.backgroundColor = DEFAULT_COLOR
        //viewHeader.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 38.0)
        self.view.addSubview(viewHeaderMap)
        self.view.sendSubviewToBack(viewHeaderMap)
    }
    func initData()
    {
        
    }
    func initUI()
    {
        
    }
    public func LeftBarButtonWithImage(_ buttonImage: UIImage) {
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(buttonImage, for: .normal)
        btnLeft.frame = CGRect(x: -10, y: 0, width: 60, height: 60)
        btnLeft.addTarget(self, action: #selector(self.tapLeft), for: .touchUpInside)
        btnLeft.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        let leftButton = UIBarButtonItem(customView: btnLeft)
        navigationItem.leftBarButtonItem = leftButton
    }
    public func addNotiBtnPush(_ buttonImage: UIImage){
        if btNoti != nil{
            btNoti?.setImage(buttonImage,for: .normal)
            return
        }
        btNoti = UIButton(type: .custom)
        btNoti?.setImage(buttonImage,for: .normal)
        btNoti?.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
        btNoti?.addTarget(self, action: #selector(self.tapNoti), for: .touchUpInside)
        btNoti?.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        let leftButton = UIBarButtonItem(customView: btNoti ?? UIButton())
        navigationItem.rightBarButtonItem = leftButton
    }
    func addNotiBtn(){
        navigationItem.rightBarButtonItem = nil
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(UIImage.init(named: "ic_noti"), for: .normal)
        btnLeft.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
        btnLeft.addTarget(self, action: #selector(self.tapNoti), for: .touchUpInside)
        btnLeft.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        let leftButton = UIBarButtonItem(customView: btnLeft)
        navigationItem.rightBarButtonItem = leftButton
    }
    func addShareBtn(){
        navigationItem.rightBarButtonItem = nil
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(UIImage.init(named: "ic_share"), for: .normal)
        btnLeft.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
        btnLeft.addTarget(self, action: #selector(self.tapShare), for: .touchUpInside)
        btnLeft.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        let leftButton = UIBarButtonItem(customView: btnLeft)
        navigationItem.rightBarButtonItem = leftButton
    }
    @objc func tapNoti(){
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        let notiVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VEAlersViewController") as! VEAlersViewController
//        self.navigationController?.pushViewController(notiVC, animated: true)
        let notificationVC:ListNotificationViewCotroller = UtilitysStoryBoard.instantiateViewController(withIdentifier: "ListNotificationViewCotroller") as! ListNotificationViewCotroller
        //notificationVC.isPromotion = false
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    @objc func tapShare(){
        //        UIApplication.shared.applicationIconBadgeNumber = 0
        //        let notiVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VEAlersViewController") as! VEAlersViewController
        //        self.navigationController?.pushViewController(notiVC, animated: true)
        
    }
    @objc func tapLeft() {
        if self.isShowBackButton
        {
            if self.isModal {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }

    public func setRightNavButton (withImage image: UIImage, tintColor: UIColor = .white, imageInsets: UIEdgeInsets = .zero) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        button.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
        button.imageEdgeInsets = imageInsets
        button.addTarget(self, action: #selector(self.onPressRightNavButton), for: .touchUpInside)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func onPressRightNavButton () {
    }

    // MARK: - UIGestureRecognizerDelegate
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
