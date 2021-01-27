//
//  TaListInviteViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 10/7/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
enum TYPE_BID : Int{
    /// trạng thái nhận công việc bình thường
    case NORMAL = 1
    /// trạng thái chấp nhận lời mời
    case ACCEPT = 2
    /// trạng thời từ chối
    case REJECT = 3
}
class TaListInviteViewController: BaseViewController {
    @IBOutlet weak var lbText: UILabel!
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var currentNotifObj:NotificationObj?
    var listInvite = [UserInviteObj]()
    var listJob = [TAJobObj]()
    var currentJob:TAJobObj?
    var jobId:String = ""
    var currentInvite:UserInviteObj?
    var typeBid:TYPE_BID = .NORMAL
    @IBOutlet weak var tbViewInvite: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeaderNoti = true
        isHiddenBottomBar = true
        self.title = "Danh sách lời mời"
        tbViewInvite.delegate = self
        tbViewInvite.dataSource = self
        tbViewInvite.register(UINib.init(nibName: "TaInviteUserTableViewCell", bundle: nil), forCellReuseIdentifier: "TaInviteUserTableViewCell")
        getData()
        tbViewInvite?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbViewInvite?.finishInfiniteScroll()
            }
        }
        
        if #available(iOS 10.0, *) {
            self.tbViewInvite?.refreshControl = refreshControl
        } else {
            self.tbViewInvite?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    func getData()  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListInvite(block : { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbViewInvite?.finishInfiniteScroll()
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
                if self.listJob.count == 0{
                    self.lbText.text = "Bạn chưa có công việc được mời nào"
                    self.lbText.isHidden = false
                }else{
                    self.tbViewInvite.isHidden = false
                    self.lbText.isHidden = true
                }
                self.tbViewInvite.reloadData()
            }
            else{
                Toast(text: message, duration: 2.0).show()
            }
        })
    }
    @objc func reloadData()  {
        self.listInvite.removeAll()
        //refreshControl.endRefreshing()
        tbViewInvite?.reloadData()
        self.isLoadMore = true
        currentPage = 1
        getData()
    }
    func bid(idJob:String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.bidRequest(jid:idJob, decs: nil){ (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, delay: 0, duration: 2.0).show()
            if errorCode == SUCCESS_CODE
            {
                self.reloadData()
                self.tbViewInvite.reloadData()
                //self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    func deleteJobInvite(idInvite:String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.deleteJobInvite(invite_id: idInvite) { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE {
                self.reloadData()
                self.tbViewInvite.reloadData()
            }
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
extension TaListInviteViewController:UITableViewDataSource,UITableViewDelegate,FeedBackDelegate{
    func feedBack(index: Int?, isReject: Bool) {
        let idCurrenJob = listJob[index ?? 0].invite_id ?? ""
        let jobID = listJob[index ?? 0].internalIdentifier ?? ""
        if isReject{
            let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn nhận việc không?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
                self.bid( idJob: jobID )
            }))
            self.present(alertVC, animated: true, completion: nil)
        }else{
            
            let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn từ chối nhận việc này không?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "KHÔNG", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction.init(title: "CHẤP NHẬN", style: .destructive, handler: { (alertView) in
                self.deleteJobInvite(idInvite: idCurrenJob)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listJob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaInviteUserTableViewCell", for: indexPath) as! TaInviteUserTableViewCell
        cell.selectionStyle  = .none
        cell.delegate = self
        cell.setData(obj: listJob[indexPath.row],IndexCell: indexPath.row)
        tableView.rowHeight = UITableView.automaticDimension
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetail:TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as!
        TaJobDetailViewController
        jobDetail.jobObj = listJob[indexPath.row]
        self.navigationController?.pushViewController(jobDetail, animated: true)
    }
    
    
}
