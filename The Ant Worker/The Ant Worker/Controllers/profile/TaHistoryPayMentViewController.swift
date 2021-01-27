//
//  TaHistoryPayMentViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 10/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
enum STATUS_PAYMENT : Int{
    case PAYMENT = 1 // trạng thái đã thanh toán
    case NO_PAYMENT = 3 // trạng thái không thanh toán
    case NOT_YET_PAYMENT = 2 // trạng thái huỷ thanh toán
}
class TaHistoryPayMentViewController: BaseViewController {
    @IBOutlet weak var tbHistoryPayMent: UITableView!
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var listPayMentHistory = [PayMentHistoryOBj]()
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowHeaderNoti = true
        isShowBackButton = true
        self.title = "Lịch sử giao dịch"
        tbHistoryPayMent.dataSource = self
        tbHistoryPayMent.delegate = self
        tbHistoryPayMent.register(UINib.init(nibName: "TaHistoryPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "TaHistoryPaymentTableViewCell")
        tbHistoryPayMent?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbHistoryPayMent?.finishInfiniteScroll()
            }
        }
        if #available(iOS 10.0, *) {
            self.tbHistoryPayMent?.refreshControl = refreshControl
        } else {
            self.tbHistoryPayMent?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        getData()
        // Do any additional setup after loading the view.
    }
    @objc func reloadData()  {
        self.listPayMentHistory.removeAll()
        if listPayMentHistory != nil {
            tbHistoryPayMent!.reloadData()
        }
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
    }
    func getData()  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListUserHistory(page: currentPage) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbHistoryPayMent?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE
            {
                if self.currentPage == 1{
                    self.listPayMentHistory = response as? [PayMentHistoryOBj] ?? [PayMentHistoryOBj]()
                }
                else{
                    self.listPayMentHistory += response as? [PayMentHistoryOBj] ?? [PayMentHistoryOBj]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                self.tbHistoryPayMent.reloadData()
                
            }
            else
            {
                self.view.makeToast(message)
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
extension TaHistoryPayMentViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPayMentHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaHistoryPaymentTableViewCell", for: indexPath) as! TaHistoryPaymentTableViewCell
        cell.selectionStyle = .none
        cell.fillData(obj: listPayMentHistory[indexPath.row])
        return cell
    }
    
    
}
