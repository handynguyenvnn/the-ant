//
//  TaListRateViewController.swift
//  The Ant
//
//  Created by Quyet on 9/16/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
class TaListRateViewController: BaseViewController {
    @IBOutlet weak var tbRate: UITableView!
    var listRate = [RateHistoryObj]()
    var profile:UserObj?
    var currentRate:RateHistoryObj?
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var jobObj:TAJobObj?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var lbText: UILabel!
    override func viewDidLoad() {
        self.title = "Danh sách phản hồi"
        isShowBackButton = true
        isShowHeaderJobDetail = true
        super.viewDidLoad()
        tbRate.dataSource = self
        tbRate.delegate = self
        tbRate.register(UINib.init(nibName: "TaDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "TaDetailTableViewCell")
        rateHistory()
        tbRate?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.rateHistory()
            } else {
                self.tbRate?.finishInfiniteScroll()
            }
        }
        if #available(iOS 10.0, *) {
            self.tbRate?.refreshControl = refreshControl
        } else {
            self.tbRate?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    @objc func reloadData()  {
        self.listRate.removeAll()
        tbRate.reloadData()
        self.isLoadMore = true
        self.currentPage = 1
        self.rateHistory()
    }
    func rateHistory(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListRateHistory(uid: jobObj?.user?.internalIdentifier ??  profile?.internalIdentifier  , jid:jobObj?.internalIdentifier ?? "", page: currentPage) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbRate?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE
            {
                if self.currentPage == 1{
                    self.listRate = response as? [RateHistoryObj] ?? [RateHistoryObj]()
                }
                else{
                    self.listRate += response as? [RateHistoryObj] ?? [RateHistoryObj]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                //let viewHeader:UIView = self.view.viewWithTag(300) ?? UIView()
                if self.listRate.count == 0{
                    //self.tbRate.isHidden = true
                    self.lbText.text = "Chưa có đánh giá nào"
                    self.lbText.isHidden = false
                    //viewHeader.viewWithTag(300)
                    //viewHeader.isHidden = false
                    //self.isShowHeaderNoti = true
                }else{
                    self.tbRate.isHidden = false
                    self.lbText.isHidden = true
                    //viewHeader.isHidden = false
                    //self.isShowHeaderJobDetail = true
                }
                self.tbRate.reloadData()
            }
            else
            {
                self.view.makeToast(message)
            }
        }
    }
}
extension TaListRateViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRate.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaDetailTableViewCell", for: indexPath) as! TaDetailTableViewCell
        cell.selectionStyle = .none
        cell.setupData(obj: listRate[indexPath.row])
        return cell
    }
    
    
}
