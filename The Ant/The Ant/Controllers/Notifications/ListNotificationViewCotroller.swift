//
//  PListNotificationViewCotroller.swift
//  Pavico
//
//  Created by MacBook on 5/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
class ListNotificationViewCotroller: BaseViewController {
    var listNotification:[NotificationObj] = [NotificationObj]()
    @IBOutlet weak var tbNotifications:UITableView?
    var isPromotion:Bool = false
    var isLoadMore:Bool = true
    var refreshControl = UIRefreshControl()
    var currentPage:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        self.navigationItem.title = "Thông báo"
        isShowHeaderNoti = true
        isHiddenBottomBar = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tbNotifications?.reloadData()
    }
    override func initData() {
//        self.isShowBackButton = true
//        self.isShowHeaderBackground = true
        self.isTransParentBar = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotif), name: NSNotification.Name("readNotif"), object: nil)
        self.tbNotifications?.register(UINib.init(nibName: "MMNotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "MMNotificationsTableViewCell")
        self.tbNotifications!.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbNotifications?.finishInfiniteScroll()
            }
        }
        
        if #available(iOS 10.0, *) {
            self.tbNotifications?.refreshControl = refreshControl
        } else {
            self.tbNotifications?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.getData()
    }
    @IBAction func backPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func reloadDataNotif()
    {
        self.tbNotifications?.reloadData()
    }
    func getData() {
        let type:Int? = self.isPromotion ? 1:nil
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListNotification(page: self.currentPage,type: type) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tbNotifications!.finishInfiniteScroll()
            self.refreshControl.endRefreshing()
            if errorCode == SUCCESS_CODE {
                
                if self.currentPage == 1
                {
                    self.listNotification = response as? [NotificationObj] ?? [NotificationObj]()
                }
                else
                {
                    self.listNotification += response as? [NotificationObj] ?? [NotificationObj]()
                }
                if self.tbNotifications != nil {
                    self.tbNotifications?.reloadData()
                }
                self.currentPage += 1
            } else {
                Toast(text: message, delay: 0, duration: 2).show()
            }
            self.isLoadMore = isNextPage ?? false
        }
    }
    @objc func reloadData (){
        self.listNotification.removeAll()
        if listNotification != nil {
            tbNotifications!.reloadData()
        }
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
    }
    func getNotiDetail(notiId:String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getNotifDetail(notifId: notiId) { (result, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE
            {
                AppDelegate.sharedInstance.getCountNotif()
                //self.updateData()
                //NotificationCenter.default.post(name: NSNotification.Name("readNotif"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("readNotif"), object: nil)
            }
        }
    }
//    func deleteNotif(notifObj:NotificationObj)
//    {
//        if notifObj.isRead == false {
//            let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có xoá thông báo?", preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
//            alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//                Services.shareInstance.deleteNotif(id: notifObj.notificationId ?? "") { (result, message, errorCode) in
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    if errorCode == SUCCESS_CODE
//                    {
//                        self.getData()
//                        AppDelegate.sharedInstance.getCountNotif()
//                    }
//                    Toast.init(text: message, delay: 0, duration: 2.0).show()
//                }
//            }))
//            self.present(alertVC, animated: true, completion: nil)
//        }
//        else
//        {
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//            Services.shareInstance.deleteNotif(id: notifObj.notificationId ?? "") { (result, message, errorCode) in
//                MBProgressHUD.hide(for: self.view, animated: true)
//                if errorCode == SUCCESS_CODE
//                {
//                    self.getData()
//                    AppDelegate.sharedInstance.getCountNotif()
//                }
//                Toast.init(text: message, delay: 0, duration: 2.0).show()
//            }
//        }
//        
//    }
    func gotoDetailJob(jobId:String){
        let jobDetailVC :TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as! TaJobDetailViewController
        jobDetailVC.jobId = jobId
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}
extension ListNotificationViewCotroller: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listNotification[indexPath.row].isRead = true
        listNotification[indexPath.row].notificationIsRead = 1
        if TYPE_NOTI.JOB_RESOLVED_CONFIRM.rawValue == listNotification[indexPath.row].notificationType{
            let userRequestVC:TaListUserRequestViewController = UIStoryboard.init(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "TaListUserRequestViewController") as! TaListUserRequestViewController
            userRequestVC.currentNotifObj = listNotification[indexPath.row]
            userRequestVC.title = "Danh sách nhân sự"
            self.navigationController?.pushViewController(userRequestVC, animated: true)
        }else if let jobId = listNotification[indexPath.row].jid, jobId != ""{
            self.getNotiDetail(notiId: listNotification[indexPath.row].notificationId ?? "")
            gotoDetailJob(jobId: jobId)
        }
        else{
            let notifDetailVC:NotificationDetailViewController = UIStoryboard.init(name: "Utilitys", bundle: nil).instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
            if indexPath.row < listNotification.count {
                notifDetailVC.currentNotifObj = listNotification[indexPath.row]
            }
            self.navigationController?.pushViewController(notifDetailVC, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MMNotificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MMNotificationsTableViewCell", for: indexPath) as! MMNotificationsTableViewCell
        cell.selectionStyle = .none
        if indexPath.row < listNotification.count {
            cell.setupData(objData: listNotification[indexPath.row])
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return HeightNotiCell
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//            if indexPath.row < self.listNotification.count
//            {
//                let objNotif:NotificationObj = self.listNotification[indexPath.row]
//                self.deleteNotif(notifObj: objNotif)
//            }
//        }
//    }

}
