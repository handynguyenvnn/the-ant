//
//  TAStaticsViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 8/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import SDWebImage
import MBProgressHUD
class TAStaticsViewController: BaseViewController {
    @IBOutlet weak var tbStatics: UITableView!
    @IBOutlet weak var btnStatical: UIButton!
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var btMonth: UIButton!
    var currentListMonth:[PMonthObj] = [PMonthObj]()
    var currentMonth:PMonthObj?
    var statics = [CateObj]()
        var listReportWorker = [ReportWorkerObj]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        isShowLeftTitle = true
        isShowHeader = true
        self.navigationItem.title = "Thống kê"
        isShowBackButton = true
        tbStatics.delegate = self
        tbStatics.dataSource = self
        isHiddenBottomBar = true
         tbStatics.register(UINib(nibName: "TAStaticsTableViewCell", bundle: nil), forCellReuseIdentifier: "TAStaticsTableViewCell")
        if #available(iOS 10.0, *) {
            self.tbStatics?.refreshControl = refreshControl
        } else {
            self.tbStatics?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        listReport()
       
    }
    override func initData() {
        //        let month = PMonthObj.init()
        currentListMonth = PMonthObj.getListTitleFromCurrentDate(currentDate: Date())
        currentMonth = currentListMonth.filter{$0.month == Calendar.current.component(Calendar.Component.month, from: Date())}.first
        self.btMonth?.setTitle(currentMonth?.titleMonthYear, for: .normal)
        //        month.month = i + 1
    }
    @objc func reloadData (){
        self.refreshControl.endRefreshing()
        self.statics.removeAll()
        listReport()
//        self.getCate()
        
    }
    @IBAction func btnOnChooseMonth(_ sender: Any) {
        showAlertTime()
    }
    func showAlertTime(){
        let alertVC:UIAlertController = UIAlertController.init(title: "", message: NSLocalizedString("Chọn tháng thống kê", comment: ""), preferredStyle: .actionSheet)
        for item in currentListMonth
        {
            if self.currentMonth != nil &&  item.month == self.currentMonth?.month
            {
                let action = UIAlertAction.init(title: item.titleMonthYear, style: .destructive) { (action) in
                    self.currentMonth = item
                    let newTitle:String = item.titleMonthYear
                    self.btMonth?.setTitle(newTitle, for: .normal)
                    self.reloadData()
                }
                alertVC.addAction(action)
            }
            else
            {
                let action = UIAlertAction.init(title: item.titleMonthYear, style: .default) { (action) in
                    self.currentMonth = item
                    let newTitle:String = item.titleMonthYear
                    self.btMonth?.setTitle(newTitle, for: .normal)
                    self.reloadData()
                }
                alertVC.addAction(action)
            }
        }
        let actionCancel = UIAlertAction.init(title: "Đóng", style: .cancel) { (action) in
        }
        alertVC.addAction(actionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func listReport(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.reportHr(date:currentMonth?.display() ?? ""  ){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbStatics?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE{
                self.listReportWorker = response as? [ReportWorkerObj] ?? [ReportWorkerObj]()
                self.tbStatics.reloadData()
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
}

extension TAStaticsViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listReportWorker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TAStaticsTableViewCell", for: indexPath) as! TAStaticsTableViewCell
            cell.selectionStyle = .none
        cell.setup(obj:listReportWorker[indexPath.row])
        return cell
    }
    
    
}
