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
enum ACTIVE_JOB_TAB:Int {
    case ACTIVE_JOB = 0
    case RECRUITING = 1
    case HISTORY = 2
}
class TAJobViewController: BaseViewController {
    @IBOutlet weak var tbTAJob: UITableView!
    
    @IBOutlet weak var lbRecruiting: UILabel!
    @IBOutlet weak var viewRecruiting: UIView!

    @IBOutlet weak var lbActivate: UILabel!
    @IBOutlet weak var viewActivate: UIView!
    
    @IBOutlet weak var lbHistory: UILabel!
    @IBOutlet weak var viewHistory: UIView!
    var listJob = [TAJobObj]()
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var arrTitle:[UILabel]?
    var arrViewTitle:[UIView]?
    var currentJobStatus:STATUS_JOB? = .NEW
    var currentIndexTabSelected = 0
    
    var heightVC:CGFloat = 368
    override func viewDidLoad() {
        super.viewDidLoad()
        tbTAJob.register(UINib(nibName: "TAJobTableViewCell", bundle: nil), forCellReuseIdentifier: "TAJobTableViewCell")
        tbTAJob.delegate = self
        tbTAJob.dataSource = self
        getData()
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
        arrTitle = [lbRecruiting, lbActivate,lbHistory]
        arrViewTitle = [viewRecruiting,viewActivate,viewHistory]
        isHiddenBottomBar = false
    }
    @IBAction func bntRecruiting(_ sender: Any) {
        currentJobStatus = .NEW
         currentIndexTabSelected = 0
        changeStateCate()
        reloadData()
    }
    
    @IBAction func bntActivate(_ sender: Any) {
        currentJobStatus = .InProgress
        currentIndexTabSelected = 1
        changeStateCate()
        reloadData()
    }
    
    @IBAction func bntHistory(_ sender: Any) {
         currentIndexTabSelected = 2
        currentJobStatus = .DONE
        changeStateCate()
        reloadData()
      
    }
    
    func changeStateCate(){
        for i in 0...arrTitle!.count - 1
        {
            if i == self.currentIndexTabSelected
            {
                arrViewTitle![i].isHidden = false
                arrTitle![i].font = Utilitys.getFontBoldWithSize(size: 18)
            }
            else
            {
                arrViewTitle![i].isHidden = true
                arrTitle![i].font = Utilitys.getFontRegularWithSize(size: 16)
            }
        }

    }
        //currentJobStatus?.rawValue
     func getData()  {
        var listStatus = [STATUS_JOB]()
        listStatus.append(currentJobStatus ?? .NONE)
        if currentJobStatus == .DONE{
            listStatus.append(.CANCEL)
        }
        self.tbTAJob?.finishInfiniteScroll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListJob(page: currentPage, cate: nil, status:listStatus , type:2, name: nil) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
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
        refreshControl.endRefreshing()
        tbTAJob?.reloadData()
        self.isLoadMore = true
        currentPage = 1
        getData()
        
    }
    // rate
    func rateJob(job: TAJobObj){
        let ratePopup = QuandaStoryBoard.instantiateViewController(withIdentifier: "TAEvaluateViewController") as! TAEvaluateViewController
        ratePopup.superView = self
        ratePopup.jobObj = job
        let yVC = (AppDelegate.sharedInstance.window?.center.y ?? 0) - heightVC/2
        let presenter: Presentr = {
            let width = ModalSize.custom(size: Float(self.view.frame.width) * (5/6))
            let height = ModalSize.custom(size: Float(heightVC)) //ModalSize.fluid(percentage: 0.20)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: self.view.frame.width * (1/12), y: yVC))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType =  TransitionType.coverVertical
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.backgroundColor = .black
            customPresenter.backgroundOpacity = 0.3
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .bottom
            customPresenter.cornerRadius = 10
            return customPresenter
        }()
        customPresentViewController(presenter, viewController: ratePopup, animated: true)
    }
}

extension TAJobViewController:UITableViewDataSource, UITableViewDelegate, JobCellDelegate
{
    // rate
    func toRate(indexRate: Int) {
        if indexRate != nil && (indexRate ) < listJob.count
        {
            // trỏ đến indexRate
            rateJob(job: listJob[indexRate])
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listJob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TAJobTableViewCell", for: indexPath) as! TAJobTableViewCell
        cell.selectionStyle = .none
        // rate
        //cell.btnEvaluate.isHidden = self.currentPage != STATUS_JOB.DONE.rawValue
        cell.index = indexPath.row
        cell.delegate = self
                                                    /// nếu là màn lịch sử thì show rate
        cell.setup(obj: self.listJob[indexPath.row], isShowRate: currentJobStatus == .DONE, isShowImRate: currentJobStatus == .DONE)
      return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailVC :TaJobDetailViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaJobDetailViewController") as! TaJobDetailViewController
        jobDetailVC.jobObj = self.listJob[indexPath.row]
        // sau khi chuyển màn thì gán màn trước nó
        jobDetailVC.superViewJob = self
        jobDetailVC.fromVC = self
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
    
    
}
