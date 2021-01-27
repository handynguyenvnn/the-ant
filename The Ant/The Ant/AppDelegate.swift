//
//  AppDelegate.swift
//  MQ Coffee
//
//  Created by Tung Nguyen on 6/6/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON
import RNCryptor
import MBProgressHUD
import Firebase
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit
import IQKeyboardManager
import FirebaseMessaging
import GoogleSignIn
import Toaster
let MainStoryBoard:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
let AccountStoryBoard:UIStoryboard = UIStoryboard.init(name: "Account", bundle: nil)
let JobStoryBoard:UIStoryboard = UIStoryboard.init(name: "Job", bundle: nil)
let DuongStoryBoard:UIStoryboard = UIStoryboard.init(name: "Duongpt", bundle: nil)
let QuanStoryBoard:UIStoryboard = UIStoryboard.init(name: "Quanda", bundle: nil)
let MapStoryBoard:UIStoryboard = UIStoryboard.init(name: "Map", bundle: nil)
let UtilitysStoryBoard:UIStoryboard = UIStoryboard.init(name: "Utilitys", bundle: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    var isLogout = false
    var notiId = ""
    var jobId = ""
    var totalNotif:NSInteger = 0
    var pushToken:String = ""
    var timer:Timer?
    var userInfo:JSON? = JSON()
    var window: UIWindow?
    var mainTabbar:UITabBarController?
    var mainNavigation:UINavigationController?
    var currentViewController:BaseViewController?
    var firebaseToken = ""
    var menuButton:ExpandingMenuButton?
    class var sharedInstance :AppDelegate {
        
        struct Singleton {
            static let instance = (UIApplication.shared.delegate as! AppDelegate)
        }
        return Singleton.instance
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Muli-Regular", size: 11)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        IQKeyboardManager.shared().isEnabled = true
        GIDSignIn.sharedInstance().clientID = GG_SIGIN_ID
        GMSServices.provideAPIKey(GGMAP.key_map)
        GMSPlacesClient.provideAPIKey(GGMAP.key_map)
//        GMSServices.provideAPIKey(GGMAP.key_search)
//        GMSPlacesClient.provideAPIKey(GGMAP.key_search)
        UserDefaults.saveUUID(UIDevice.current.identifierForVendor?.uuidString ?? "")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont.init(name: "Muli-Bold", size: 20) ?? ""]
        FirebaseApp.configure()
        if let userInfo = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            let jsonData = JSON.init(userInfo)
            handlePushDefault(info: jsonData)
        }
        //        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        registerNotification(application)
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let jsonData = JSON.init(userInfo)
        handlePushDefault(info: jsonData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let jsonData = JSON.init(userInfo)
        if application.applicationState == UIApplication.State.inactive {
            // user has tapped notification
            handlePushDefault(info: jsonData)
            
        }else {
            // user opened app from app icon
            handlePushDefault(info: jsonData)
        }
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Custom alert
        let userInfo = notification.request.content.userInfo
        let jsonData = JSON.init(userInfo)
        handlePushDefault(info: jsonData)
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        let userInfo = response.notification.request.content.userInfo
        let jsonData = JSON.init(userInfo)
        handlePushDefault(info: jsonData)
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                //MARK: UPDATE TOKEN FIREBASE
                if UserDefaults.resultDeviceToken() != result.token {
                    UserDefaults.saveDeviceToken(token: result.token)
                    self.firebaseToken = result.token
                    Services.shareInstance.updateFBToken(token: self.firebaseToken, block: { (_, message, errorCode) in
                        if errorCode == SUCCESS_CODE {
                            
                        } else {
                        }
                    })
                }
                print("Remote instance ID token: \(result.token)")
                //                self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        AppDelegate.sharedInstance.pushToken = deviceTokenString
        //        if UserDefaults.resultUUID() == ""{
        //            UIDevice.current.identifierForVendor?.uuidString ?? ""
        //        }
    }
    
    fileprivate func registerNotification(_ application: UIApplication) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted {
                    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                        print("Notification settings: \(settings)")
                        guard settings.authorizationStatus == .authorized else { return }
                        DispatchQueue.main.sync() {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
                else {
                    //Handle user denying permissions..
                }
            }
            
            //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
            application.registerForRemoteNotifications()
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    func handlePushDefault(info:JSON){
        if self.timer != nil {
            self.timer?.invalidate()
            timer = nil
        }
        // print(info)
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.handleNotiEvent),
            userInfo: nil,
            repeats: true)
        self.userInfo = info
    }
    @objc func handleNotiEvent(){
        if DataCenter.sharedInstance.token.isEmpty{
            return
        }
        DLOG.printfLog(obj: self.userInfo as AnyObject)
        if self.mainNavigation != nil && self.currentViewController != nil
        {
            if self.timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
        self.getCountNotif()
        let type:TYPE_NOTI = TYPE_NOTI(rawValue: userInfo?["type"].int ?? Int(userInfo?["type"].string ?? "") ?? 0) ?? .NONE
        let messageLogout = userInfo?["aps"]["alert"]["body"].string ?? ""
        /// id công việc
//        let jid = userInfo?["aps"]["alert"]["jid"].string ?? ""
        ///id của người lao động
//        let uid = userInfo?["aps"]["alert"]["uid"].string ?? ""
        
        if type == .CHANGE_PASSWORD
        {
            userInfo = nil
            MBProgressHUD.showAdded(to: AppDelegate.sharedInstance.window!, animated: true)
            Services.shareInstance.logout(block: { (response, message, error) in
                MBProgressHUD.hide(for: AppDelegate.sharedInstance.window!, animated: true)
                UserObj.removeDataUser()
                if error == SUCCESS_CODE
                {
                    self.logout(message: messageLogout)
                }
                else
                {
                    self.logout(message: messageLogout)
                }
            })
        }
        else
        {
            jobId = userInfo?["job_id"].string ?? ""
            let uid = userInfo?["uid"].string ?? ""
            let title = userInfo?["aps"]["alert"]["title"].string ?? ""
            let message = userInfo?["aps"]["alert"]["body"].string ?? ""
            
            
//            let isAcceptStudy = getBoolValueFromJson(data: userInfo, key: "is_accept")
//            let isRequestCheckin = getBoolValueFromJson(data: userInfo, key: "is_checkin")
//            let isAcceptCheckin:Bool? = getBoolValueFromJson(data: userInfo, key: "is_checkin")
//            let isAcceptCheckout:Bool? = !(getBoolValueFromJson(data: userInfo, key: "is_checkin"))
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if userInfo != nil {
                if (currentViewController?.isKind(of: TaJobDetailViewController.self) ?? false) && ((currentViewController as! TaJobDetailViewController).jobObj?.internalIdentifier == jobId){
                    (currentViewController as! TaJobDetailViewController).initData()
                }
                userInfo = nil
                alert.addAction(UIAlertAction.init(title: "Đóng", style: .cancel, handler: { (action) in
                    
                }))

                switch type{
                case .NEW_JOB, .JOB_RESOLVED, .JOB_BID, .JOB_COMING_SOON,.ENOUGH_MEMBER:
                    alert.addAction(UIAlertAction.init(title: "Xem chi tiết", style: .default, handler: { (action) in
                        
                        self.gotoDetailJob(jobId: self.jobId)
                        self.getCountNotif()
                    }))
                    break
                case .JOB_RESOLVED_CONFIRM:
                    alert.addAction(UIAlertAction.init(title: "Đồng ý", style: .default, handler: { (action) in
                        self.confirmResolveJob(jid: self.jobId, id: uid, isAccept: true)
                    }))
                    alert.addAction(UIAlertAction.init(title: "Từ chối", style: .destructive, handler: { (action) in
                        self.confirmResolveJob(jid: self.jobId, id: uid, isAccept: false)
                    }))
                    break
                default:
                    break
                }
                if self.mainNavigation != nil
                {
                    self.mainNavigation?.present(alert,animated: true)
                }
                else if self.currentViewController != nil{
                    self.currentViewController?.present(alert,animated: true)
                }
            }
        }
        
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - jid: id của công việc
    ///   - id: id của người lao động
    func confirmResolveJob(jid:String,id:String,isAccept:Bool){
        MBProgressHUD.showAdded(to: AppDelegate.sharedInstance.window ?? UIView(), animated: true)
        Services.shareInstance.verifyJob(idUsers: [id], isAccpept: isAccept, jid:  jid) {(response, message, errorCode) in
            MBProgressHUD.hide(for: AppDelegate.sharedInstance.window ?? UIView(), animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                
            }
        }
    }
    func gotoDetailJob(jobId:String){
        let jobDetailVC :TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as! TaJobDetailViewController
        jobDetailVC.jobId = jobId
        if (currentViewController?.isKind(of: TaJobDetailViewController.self) ?? false) && ((currentViewController as! TaJobDetailViewController).jobObj?.internalIdentifier == jobId){
            (currentViewController as! TaJobDetailViewController).getInfoUser()
        }
        else{
            self.currentViewController?.navigationController?.pushViewController(jobDetailVC, animated: true)
        }
    }
    func logout(message:String){
        self.unSubcribeTopicAll()
        self.isLogout = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "change_badge"), object: nil)
        UserObj.removeDataUser()
        DataCenter.sharedInstance.token = ""
        DataCenter.sharedInstance.currentUser = nil
        if message != ""{
            let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                let loginVC = MainStoryBoard.instantiateViewController(withIdentifier: "TALoginViewController") as! TALoginViewController
                
                AppDelegate.sharedInstance.mainNavigation?.viewControllers = [loginVC]
            }))
            self.mainNavigation?.present(alert, animated: true, completion: nil)
        }
    }
    func subcribeTopicAll(){
        Messaging.messaging().subscribe(toTopic: "topic_all") { error in
            print("Subscribed to topic_all")
        }
    }
    func unSubcribeTopicAll(){
        Messaging.messaging().unsubscribe(fromTopic: "topic_all") { error in
            print("Subscribed to topic_all")
        }
    }
    //MARK: Refresh token Firebare
    @objc func tokenRefreshNotification(notification: NSNotification) {
        //    NOTE: It can be nil here
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                //MARK: UPDATE TOKEN FIREBASE
                if UserDefaults.resultDeviceToken() != result.token {
                    UserDefaults.saveDeviceToken(token: result.token)
                    self.firebaseToken = result.token
                    Services.shareInstance.updateFBToken(token: self.firebaseToken, block: { (_, message, errorCode) in
                        if errorCode == SUCCESS_CODE {
                            
                        } else {
                            //                            Toast(text: message, delay: 0, duration: 1).show()
                        }
                    })
                }
                print("Remote instance ID token: \(result.token)")
                //                self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
    }
    func getCountNotif()
    {
        if DataCenter.sharedInstance.currentUser != nil
        {
            Services.shareInstance.getCountNotif { (result, message, errorCode) in
                if errorCode == SUCCESS_CODE
                {
                    if result != nil
                    {
                        let resJson = JSON.init(result!)
                        let total = resJson["total"].intValue
                        AppDelegate.sharedInstance.totalNotif = total
                        //NEED_FIX set count
                        if self.totalNotif > 0{
                            AppDelegate.sharedInstance.currentViewController?.addNotiBtnPush(UIImage.init(named: "ic_noti_push") ?? UIImage())
                        }else{
                            AppDelegate.sharedInstance.currentViewController?.addNotiBtnPush(UIImage.init(named: "ic_noti") ?? UIImage())
                        }
                    }
                }
            }
        }
    }
}

