//
//  TaReportViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 8/2/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
class TaReportViewController: BaseViewController {

    @IBOutlet weak var clCate: UICollectionView!
    @IBOutlet weak var viewStatistic: UIView!
    @IBOutlet weak var btMonth: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    ///số tiền đã chi
    @IBOutlet weak var numberUser: UILabel!
    ///số người đã thuê
    @IBOutlet weak var lbTLTT: UILabel!
    //tỉ lệ thành công
    @IBOutlet weak var lbSoDiem: UILabel!
    //số điểm tuyển dụng
    //var imgAva:UIImageView = UIImageView()
    //var lbName:UILabel = UILabel()
    //var cates = [CateObj]()
    var reportHr:ReportObj?
    //    var user:UserObj?
    var currentListMonth:[PMonthObj] = [PMonthObj]()
    var currentMonth:PMonthObj?
    //var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowHeader = true
        isShowNoti = true
        isShowMenuButton = true
        //        isTransParentBar = true
        //addInfoView()
//        clCate.register(UINib.init(nibName: "TAHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAHomeCollectionViewCell")
//        clCate.delegate = self
//        clCate.dataSource = self
        
//        if #available(iOS 10.0, *) {
//            self.clCate?.refreshControl = refreshControl
//        } else {
//            self.clCate?.addSubview(refreshControl)
//        }
//        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        // Do any additional setup after loading the view.
        report()
    }
    override func initUI() {
        viewStatistic.dropShadow()
    }
//    @objc func reloadData (){
//        self.cates.removeAll()
//        if cates != nil {
//            clCate!.reloadData()
//        }
//        self.getCate()
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if DataCenter.sharedInstance.cate == nil && DataCenter.sharedInstance.currentUser != nil{
//            getCate()
//        }else{
//            self.cates = DataCenter.sharedInstance.cate ?? [CateObj()]
//            clCate.reloadData()
//        }
//        self.navigationController?.navigationController?.navigationBar.isHidden = true
    }
    
    override func initData() {
        //        let month = PMonthObj.init()
        currentListMonth = PMonthObj.getListTitleFromCurrentDate(currentDate: Date())
        currentMonth = currentListMonth.filter{$0.month == Calendar.current.component(Calendar.Component.month, from: Date())}.first
        self.btMonth?.setTitle(currentMonth?.titleMonthYear, for: .normal)
        //        month.month = i + 1
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        Services.shareInstance.getMyProfileDetai { (response, message, errorCode) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            DataCenter.sharedInstance.currentUser = response as? UserObj
//            //            self.user = response as? UserObj
//            self.getCate()
//            if errorCode == SUCCESS_CODE{
//                self.imgAva.sd_setHighlightedImage(with: URL.init(string: DataCenter.sharedInstance.currentUser?.avatar ?? ""), options: SDWebImageOptions.refreshCached, completed: nil)
//                self.lbName.text = DataCenter.sharedInstance.currentUser?.name
//            }
//            else{
//                Toast(text: message, duration: 2.0).show()
//            }
//
//        }
    }
    func loadData(){
        lbPrice.text = reportHr?.payment ?? ""
        lbTLTT.text = reportHr?.percentSuccess ?? ""
        numberUser.text = "\(reportHr?.people ?? 0)"
        
    }
    func report(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.reportWorker(date: currentMonth?.display() ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.reportHr = response as? ReportObj ?? ReportObj()
                self.loadData()
            }else{
                Toast.init(text: message, duration: 2.0).show()
            }
        }
    }
    @IBAction func onChooseMonth(_ sender: Any) {
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
                    self.loadData()
                }
                alertVC.addAction(action)
            }
            else
            {
                let action = UIAlertAction.init(title: item.titleMonthYear, style: .default) { (action) in
                    self.currentMonth = item
                    let newTitle:String = item.titleMonthYear
                    self.btMonth?.setTitle(newTitle, for: .normal)
                    self.loadData()
                }
                alertVC.addAction(action)
            }
        }
        let actionCancel = UIAlertAction.init(title: "Đóng", style: .cancel) { (action) in
        }
        alertVC.addAction(actionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
//    func addInfoView(){
//        imgAva.frame = CGRect.init(origin: CGPoint.init(x: -10, y: 0), size: CGSize.init(width: 45, height: 45))
//        let viewLeft = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width * (2/3), height: 44)))
//        imgAva.backgroundColor = UIColor.lightGray
//        imgAva.cornerRadius = imgAva.frame.size.width/2
//        viewLeft.addSubview(imgAva)
//        lbName.frame = CGRect.init(x: 43, y: 0, width: viewLeft.frame.width - 43, height: 20)
//        lbName.center.y = imgAva.center.y
//        lbName.font = UIFont.init(name: "AvenirNext-Bold", size: 15)
//        lbName.textColor = UIColor.white
//        lbName.text = "Nguyễn Thế Tùng"
//        viewLeft.addSubview(lbName)
//        let btMore = UIButton(type: .custom)
//        //        btMore.setImage(UIImage.init(named: "ic_two_dot"), for: .normal)
//        btMore.tintColor = .white
//        btMore.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: viewLeft.frame.size)
//        //        btNoti.imageEdgeInsets = imageInsets
//        btMore.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
//        btMore.addTarget(self, action: #selector(infoPress), for: .touchUpInside)
//        viewLeft.addSubview(btMore)
//        //        self.btNoti?.addBadge(number: 100)
//        let itemsContainer = UIBarButtonItem(customView: viewLeft)
//        self.navigationItem.leftBarButtonItems = [itemsContainer]
//        //        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btMore),self.btNoti] as? [UIBarButtonItem]
//    }
//    @objc func infoPress(){
//
//    }
//    func getCate(){
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        Services.shareInstance.getCate(uid: "\(DataCenter.sharedInstance.currentUser?.internalIdentifier ?? "")"){(response, message, errorCode) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.refreshControl.endRefreshing()
//            self.clCate?.finishInfiniteScroll()
//            if errorCode == SUCCESS_CODE{
//                self.cates = response as? [CateObj] ?? [CateObj]()
//                DataCenter.sharedInstance.cate = self.cates
//                self.clCate.reloadData()
//            }else{
//                Toast(text: message, duration: 2).show()
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
//extension TAHomeViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cates.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAHomeCollectionViewCell", for: indexPath) as! TAHomeCollectionViewCell
//        cell.setupData(obj: cates[indexPath.row],isShowCheck: true)
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: clCate.frame.width/2 - 0, height: clCate.frame.width/2 - 0)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let CreatJobVC:TaCreateViewController = JobStoryBoard.instantiateViewController(withIdentifier: "TaCreateViewController") as! TaCreateViewController
//        CreatJobVC.cate = cates[indexPath.row]
//        self.navigationController?.pushViewController(CreatJobVC, animated: true)
//    }
//
//        // Do any additional setup after loading the view.
//}
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
