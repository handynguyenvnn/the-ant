//
//  POCNotificationDetailViewController.swift
//  
//
//  Created by longhm on 1/30/19.
//  Copyright © 2019 "". All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
import SwiftyJSON
class NotificationDetailViewController: BaseViewController {
    @IBOutlet weak var notifiAvatar:UIImageView?
    @IBOutlet weak var lbTitle:UILabel?
    @IBOutlet weak var lbTime:UILabel?
    @IBOutlet weak var tvDescription:UITextView?
    var fromPush:Bool = false
    var isPromotion:Bool = false
    var currentNotifObj:NotificationObj?
    var notiId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        //isShowBackButton = true
        self.navigationItem.title = "Chi tiết thông báo"
        isShowHeaderNoti = true
//        self.title = "Chi tiết thông báo "
//        self.isShowHeaderBackground = true
//        self.isTransParentBar = true
//        self.isShowBackButton = true
        // Do any additional setup after loading the view.
    }
    override func initData() {
        
        if  self.currentNotifObj != nil {
            self.updateData()
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Services.shareInstance.getNotifDetail(notifId: self.currentNotifObj?.notificationId ?? notiId ?? "") { (result, message, errorCode) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if errorCode == SUCCESS_CODE
                {
                    AppDelegate.sharedInstance.getCountNotif()
                    self.currentNotifObj = result as? NotificationObj
                    if self.fromPush
                    {
                        self.currentNotifObj = result as? NotificationObj
                    }
                    self.currentNotifObj?.notificationIsRead = 1
                    //self.updateData()
                    //NotificationCenter.default.post(name: NSNotification.Name("readNotif"), object: nil)
                    self.currentNotifObj?.isRead = true
                    self.updateData()
                    NotificationCenter.default.post(name: NSNotification.Name("readNotif"), object: nil)
                }
            }
        }
        else
        {
            self.view.showToast(message: "Không có dữ liệu", position: .top)        }
    }
    @IBAction func backPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func updateData(){
        if currentNotifObj != nil{
            self.notifiAvatar?.sd_setImage(with: URL.init(string: self.currentNotifObj?.notificationIcon ?? ""), placeholderImage: UIImage.init(named: "ic_non_image-1"), options: .queryDiskDataSync, completed: nil)
            self.lbTitle?.text = self.currentNotifObj?.notificaitonTitle ?? ""
            self.tvDescription?.text = self.currentNotifObj?.notificationContent ?? ""
            self.lbTime?.text = self.currentNotifObj?.notiticationTime ?? ""
            //self.notifiAvatar?.image = UIImage.init(named: "ic_picker")
        }
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
