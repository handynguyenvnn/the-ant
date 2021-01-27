//
//  TAJobViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
import Presentr
enum STATUS_JOB : Int{
    case DRAFF = 0 //Nháp show chỉnh sửa
    case NEW = 1 // Mới show huỷ
    case InProgress = 2 // Đang chạy, show hoàn thành và huỷ
    case CANCEL = 3 // show đặt lại
    case DONE = 4// show đặt lại
    case NONE = -1 // lỗi
}
//enum STATUS_JOB : String{
//    case DRAFF = "0" //Nháp show chỉnh sửa
//    case NEW = "1" // Mới show huỷ
//    case InProgress = "2" // Đang chạy, show hoàn thành và huỷ
//    case CANCEL = "3" // show đặt lại
//    case DONE = "4"// show đặt lại
//    case NONE = "-1" // lỗi
//}
class TAJobViewController: BaseViewController {
    @IBOutlet weak var tbTAJob: UITableView!
    
    @IBOutlet weak var lbRecruiting: UILabel!
    @IBOutlet weak var viewRecruiting: UIView!

    @IBOutlet weak var lbActivate: UILabel!
    @IBOutlet weak var viewActivate: UIView!
    
    @IBOutlet weak var lbNhap: UILabel!
    @IBOutlet weak var viewNhap: UIView!
    @IBOutlet weak var lbHistory: UILabel!
    @IBOutlet weak var viewHistory: UIView!
    var heightVC:CGFloat = 368
    var isShowRecruiting:Bool = false
    var isShowActivate:Bool = false
    var isShowHistory:Bool = false
    var isShowNhap:Bool = false
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var listJob = [TAJobObj]()
    var currentJob:TAJobObj?
    var currentJobStatus:STATUS_JOB? = .NEW
    override func viewDidLoad() {
        super.viewDidLoad()
        tbTAJob.register(UINib(nibName: "TAJobTableViewCell", bundle: nil), forCellReuseIdentifier: "TAJobTableViewCell")
        tbTAJob.delegate = self
        tbTAJob.dataSource = self
        isHiddenBottomBar = false
        self.getData()
        tbTAJob?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbTAJob?.finishInfiniteScroll()
            }
        }
        
        if #available(iOS 10.0, *) {
            self.tbTAJob?.refreshControl = refreshControl
        } else {
            self.tbTAJob?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        isShowNoti = true
        isShowHeader = true
        isShowLeftTitle = true
        self.navigationItem.title = "Công việc"
        //new()
		DataCenter.sharedInstance.listJobVC = self
    }
    @IBAction func bntRecruiting(_ sender: Any) {
        new()
    }
    
    @IBAction func bntActivate(_ sender: Any) {
        currentJobStatus = .InProgress
        isShowRecruiting = false
        isShowActivate = true
        isShowHistory = false
        isShowNhap = false
        changeStateCate()
        reloadData()
    }
    
    @IBAction func bntHistory(_ sender: Any) {
        currentJobStatus = .DONE
        isShowRecruiting = false
        isShowActivate = false
        isShowHistory = true
        isShowNhap = false
        changeStateCate()
        reloadData()
    }
    @IBAction func onNhap(_ sender: Any) {
        currentJobStatus = .DRAFF
        isShowRecruiting = false
        isShowActivate = false
        isShowHistory = false
        isShowNhap = true
        changeStateCate()
        reloadData()
    }
    func new(){
        currentJobStatus = .NEW
        isShowRecruiting = true
        isShowActivate = false
        isShowHistory = false
        isShowNhap = false
        changeStateCate()
        reloadData()
    }
    func changeStateCate(){
        if isShowRecruiting
        {
            viewRecruiting.isHidden = false
            lbRecruiting.font = UIFont(name: "Muli-Bold", size: 18)
        }
        else
        {
            viewRecruiting.isHidden = true
            lbRecruiting.font = UIFont(name: "Muli-Regular", size: 16)
        }
        
        if isShowActivate
        {
            viewActivate.isHidden = false
            lbActivate.font = UIFont(name: "Muli-Bold", size: 18)
           
        }
        else
        {
           viewActivate.isHidden = true
            lbActivate.font = UIFont(name: "Muli-Regular", size: 16)
            
        }
        
        if isShowHistory
        {
            viewHistory.isHidden = false
            
            lbHistory.font = UIFont(name: "Muli-Bold", size: 18)
        }
        else
        {
            viewHistory.isHidden = true
            lbHistory.font = UIFont(name: "Muli-Regular", size: 16)
            
        }
        if isShowNhap
        {
            viewNhap.isHidden = false
            lbNhap.font = UIFont(name: "Muli-Bold", size: 18)
            
        }
        else
        {
            viewNhap.isHidden = true
            lbNhap.font = UIFont(name: "Muli-Regular", size: 16)
            
        }
        
    }
        //currentJobStatus?.rawValue
    func getData()  {
        var listStatus = [STATUS_JOB]()
        listStatus.append(currentJobStatus ?? .NONE)
        if currentJobStatus == .DONE{
            listStatus.append(.CANCEL)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListJob(page: currentPage, cate: nil, status: listStatus, uid: nil, name: nil) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbTAJob?.finishInfiniteScroll()
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
                self.tbTAJob.reloadData()
            }
            else{
                Toast(text: message, duration: 2.0).show()
            }
        }
    }
    @objc func reloadData()  {
        self.listJob.removeAll()
        tbTAJob!.reloadData()
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
    }
}

extension TAJobViewController:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listJob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TAJobTableViewCell", for: indexPath) as! TAJobTableViewCell
        cell.indexMap = indexPath.row
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setup(obj: self.listJob[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailVC :TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as! TaJobDetailViewController
        jobDetailVC.jobObj = self.listJob[indexPath.row]
        jobDetailVC.superView = self
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}
extension TAJobViewController : choiseDelegateMap{
    func delegateMap(index: Int?) {
        let mapVC:TaMapViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaMapViewController") as! TaMapViewController
        mapVC.jobObj = listJob[index ?? 0]
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
}
