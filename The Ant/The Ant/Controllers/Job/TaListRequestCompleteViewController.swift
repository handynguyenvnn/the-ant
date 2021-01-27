//
//  TaListRequestCompleteViewController.swift
//  The Ant
//
//  Created by Quyet on 9/3/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
import Toast_Swift
class TaListRequestCompleteViewController: BaseViewController {
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var lbText: UILabel!
    var currentPage:Int = 1
    var isLoadMore:Bool = true
    var listRequest = [ListRequestObj]()
    var curentRequest:ListRequestObj?
    var refreshControl = UIRefreshControl()
    var indexPath:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeaderNoti = true
        tbView.delegate = self
        tbView.dataSource = self
        self.title = "Công việc chờ duyệt"
        //TaListRequestTableViewCell
        tbView.register(UINib.init(nibName: "TaRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "TaRequestTableViewCell")
        // Do any additional setup after loading the view.
        tbView?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbView?.finishInfiniteScroll()
            }
        }
        
        if #available(iOS 10.0, *) {
            self.tbView?.refreshControl = refreshControl
        } else {
            self.tbView?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        getData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func getData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListRequest(block: { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbView?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE{
                if self.currentPage == 1{
                    self.listRequest = response as? [ListRequestObj] ?? [ListRequestObj]()
                }
                else{
                    self.listRequest += response as? [ListRequestObj] ?? [ListRequestObj]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                if self.listRequest.count == 0{
//                    self.tbView.isHidden = true
                    self.lbText.text = "Chưa có công việc nào có yêu cầu hoàn thành"
                     self.lbText.isHidden = false
                }else{
                    self.tbView.isHidden = false
                    self.lbText.isHidden = true
                }
                self.tbView.reloadData()
            }
            else{
                Toast(text: message, duration: 2.0).show()
            }
        })
    }
    @objc func reloadData() {
        self.listRequest.removeAll()
        tbView!.reloadData()
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
    }
//    func verifyJob(isAccept:Bool,indexPath:IndexPath?){
//        let curentJob = listRequest[indexPath?.section ?? 0]
//        var  listUser = [ListUser]()
//        if indexPath?.row == 0 {
//            listUser = curentJob.listUser ?? [ListUser]()
//        }else{
//            listUser = [curentJob.listUser?[(indexPath?.row ?? 1) - 1] ?? ListUser()]
//        }
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        Services.shareInstance.verifyJob(idUsers: listUser.map{$0.internalIdentifier ?? ""} , isAccpept: isAccept, jid:  curentJob.internalIdentifier ?? "") {(response, message, errorCode) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            Toast.init(text: message, duration: 2.0).show()
//            if errorCode == SUCCESS_CODE{
//                self.reloadData()
//                self.tbView.reloadData()
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TaListRequestCompleteViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaRequestTableViewCell", for: indexPath) as! TaRequestTableViewCell
        cell.selectionStyle = . none
        cell.setupData(obj: listRequest[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRequestVc:TaListUserRequestViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaListUserRequestViewController") as! TaListUserRequestViewController
        userRequestVc.currentUserRequest = listRequest[indexPath.row]
        userRequestVc.listRequestComplete = self
        self.navigationController?.pushViewController(userRequestVc, animated: true)
    }
    

//    func choiseConfirm(isAcpent: Bool, index: IndexPath?) {
//        verifyJob(isAccept: isAcpent, indexPath: index)
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return listRequest.count
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !listRequest[section].isExpand{
//            return 1
//        }else{
//            return (listRequest[section].listUser?.count ?? 0) + 1
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaListRequestTableViewCell", for: indexPath) as! TaListRequestTableViewCell
//        cell.selectionStyle = .none
//        cell.delegate = self
//        if indexPath.row == 0{
//            cell.setupData(objJob: listRequest[indexPath.section], index: indexPath.section, objTime: nil)
//        }else{
//            cell.setupData(objJob:nil, index: indexPath.section , objTime: listRequest[indexPath.section].listUser?[indexPath.row - 1])
//        }
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            listRequest[indexPath.section].isExpand = !listRequest[indexPath.section].isExpand
//            tableView.reloadSections([indexPath.section], with: .automatic)
//    }
    
    
}

