//
//  TaListUserWorkerViewController.swift
//  The Ant
//
//  Created by Quyet on 9/18/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
import Presentr
class TaListUserWorkerViewController: BaseViewController {
    @IBOutlet weak var tbViewUserWorker: UITableView!
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var jobObj:TAJobObj?
    var heightVC:CGFloat = 368
    var detaiJobVC:TaJobDetailViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowHeaderJobDetail = true
        self.title = "Danh sách người lao động"
        isShowBackButton = true
        tbViewUserWorker.delegate = self
        tbViewUserWorker.dataSource = self
        tbViewUserWorker.register(UINib.init(nibName: "TaUserWorkerTableViewCell", bundle: nil), forCellReuseIdentifier: "TaUserWorkerTableViewCell")
        getData()
//        tbViewUserWorker?.addInfiniteScroll { (tb) in
//            if self.isLoadMore{
//                self.getData()
//            } else {
//                self.tbViewUserWorker?.finishInfiniteScroll()
//            }
//        }
//        
//        if #available(iOS 10.0, *) {
//            self.tbViewUserWorker?.refreshControl = refreshControl
//        } else {
//            self.tbViewUserWorker?.addSubview(refreshControl)
//        }
//        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    @objc func reloadData()  {
//        self.jobObj?.userWorkers.removeAll()
//        tbViewUserWorker!.reloadData()
//        self.isLoadMore = true
//        self.currentPage = 1
//        self.getData()
    }
    func getData(){
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        Services.shareInstance.getListJob(page: currentPage, cate: nil, status: listStatus, uid: nil, name: nil) { (response, message, isNextPage, errorCode) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.refreshControl.endRefreshing()
//            self.tbTAJob?.finishInfiniteScroll()
//            if errorCode == SUCCESS_CODE{
//                if self.currentPage == 1{
//                    self.listJob = response as? [TAJobObj] ?? [TAJobObj]()
//                }
//                else{
//                    self.listJob += response as? [TAJobObj] ?? [TAJobObj]()
//                }
//                //check có trang tiếp hay không
//                self.isLoadMore = isNextPage ?? false
//                //Nếu có trang tiếp thì tăng page lên 1
//                if self.isLoadMore{
//                    self.currentPage += 1
//                }
//                self.tbTAJob.reloadData()
//            }
//            else{
//                Toast(text: message, duration: 2.0).show()
//            }
//        }
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
extension TaListUserWorkerViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobObj?.userWorkers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaUserWorkerTableViewCell", for: indexPath) as! TaUserWorkerTableViewCell
        cell.setupData(obj: jobObj?.userWorkers?[indexPath.row] ?? UserWorkers(),isCheckStar:jobObj?.statusJob == .DONE,indexStar:indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileUserVC :TaProfileUserViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaProfileUserViewController") as! TaProfileUserViewController
        profileUserVC.curentUserWork = self.jobObj?.userWorkers?[indexPath.row]
        self.navigationController?.pushViewController(profileUserVC, animated: true)
    }
}
extension TaListUserWorkerViewController:choiceStarDelegateDetail,RateDelegete{
    func rateSuccess() {
        tbViewUserWorker.reloadData()
        detaiJobVC?.tbUserWorker.reloadData()
    }
    
    func choiceStarDetail(index: Int?) {
        let rateVC:TAEvaluateViewController = QuanStoryBoard.instantiateViewController(withIdentifier: "TAEvaluateViewController") as! TAEvaluateViewController
        rateVC.jobObj = jobObj
        rateVC.delegate = self
//        detailPopUp.superView = self
        rateVC.currentUserRate = jobObj?.userWorkers?[index ??  0 ]
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
        customPresentViewController(presenter, viewController: rateVC, animated: true)
    }
    
    
}
