//
//  TaListUserRequestViewController.swift
//  The Ant
//
//  Created by Quyet on 9/20/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
class TaListUserRequestViewController: BaseViewController {
    @IBOutlet weak var tbViewUserRequest: UITableView!
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var btCheckAll:UIButton?
    var currentUserRequest:ListRequestObj?
    var listUser = [ListUser]()
    var countSelect = 0
    var listRequestComplete:TaListRequestCompleteViewController?
    var currentNotifObj:NotificationObj?
    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var stackViewBtn: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Danh sách nhân sự"
        isShowBackButton = true
        isShowHeaderNoti = true
        tbViewUserRequest.delegate = self
        tbViewUserRequest.dataSource = self
        tbViewUserRequest.register(UINib.init(nibName: "TaUserRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "TaUserRequestTableViewCell")
        tbViewUserRequest?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbViewUserRequest?.finishInfiniteScroll()
            }
        }
        
        if #available(iOS 10.0, *) {
            self.tbViewUserRequest?.refreshControl = refreshControl
        } else {
            self.tbViewUserRequest?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
  
        addRightButton()
        getData()
    }
    @IBAction func onTuChoi(_ sender: Any) {
        if countSelect < 0 {
            self.view.showToast(message: "Chưa có người lao động nào được chọn!", position: .top)
        }else{
            verifyJob(isAccept: false)
        }
    }
    @IBAction func onXetduyet(_ sender: Any) {
        if countSelect < 0{
            self.view.showToast(message: "Chưa có người lao động nào được chọn!", position: .top)
        }else{
            verifyJob(isAccept: true)
            
        }
    }
    func verifyJob(isAccept:Bool){
        var  listUserSelected = [ListUser]()
        for user in listUser{
            if user.isChecked == true{
                listUserSelected.append(user)
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.verifyJob(idUsers: listUserSelected.map{$0.internalIdentifier ?? ""} , isAccpept: isAccept, jid:  currentUserRequest?.internalIdentifier ?? currentNotifObj?.jid ?? "") {(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                self.reloadData()
                self.listRequestComplete?.reloadData()
                self.listRequestComplete?.tbView.reloadData()
                self.tbViewUserRequest.reloadData()
            }
        }
    }
    func addRightButton(){
        btCheckAll = UIButton()
        btCheckAll?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 44, height: 44))
        btCheckAll?.setImage(UIImage.init(named: "ic_uncheck_all"), for: .normal)
        btCheckAll?.setImage(UIImage.init(named: "ic_check_all"), for: .selected)
        btCheckAll?.addTarget(self, action: #selector(self.checkAllPress), for: .touchUpInside)
        let viewRight = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        viewRight.addSubview(btCheckAll!)
        let itemsContainer = UIBarButtonItem(customView: viewRight)
        self.navigationItem.rightBarButtonItems = [itemsContainer]
    }
    override func onPressRightNavButton() {
        
    }
    @objc func checkAllPress(){
        btCheckAll?.isSelected = !(btCheckAll?.isSelected ?? false)
        listUser.forEach { (data) in
            data.isChecked = btCheckAll?.isSelected ?? false
        }
//        countSelect = (btCheckAll?.isSelected ?? false) ? listUser.count : 0
        tbViewUserRequest.reloadData()
//        tbJob.isHidden = !(btFilter?.isSelected ?? false)
    }
    func getData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.userRequest(jid:currentUserRequest?.internalIdentifier ?? currentNotifObj?.jid ?? "" ) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbViewUserRequest?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE{
                if self.currentPage == 1{
                    self.listUser = response as? [ListUser] ?? [ListUser]()
                }
                else{
                    self.listUser += response as? [ListUser] ?? [ListUser]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                if self.listUser.count == 0 {
                    self.lbText.text = "Tất cả yêu cầu hoàn thành đã được phản hổi hoặc công việc đã kết thúc"
                    self.stackViewBtn.isHidden = true
                    self.lbText.isHidden = false
                }else{
                    self.lbText.isHidden = true
                    self.title = self.currentUserRequest?.name
                }
                self.tbViewUserRequest.reloadData()
            }
            else{
                Toast(text: message, duration: 2.0).show()
            }
        }
    }
    @objc func reloadData() {
        self.listUser.removeAll()
        tbViewUserRequest!.reloadData()
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
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
extension TaListUserRequestViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaUserRequestTableViewCell", for: indexPath) as! TaUserRequestTableViewCell
        cell.selectionStyle = .none
        cell.setupData(obj: listUser[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listUser[indexPath.row].isChecked = !listUser[indexPath.row].isChecked
        //tableView.reloadRows(at: [indexPath], with: UITableView.ini)
        tableView.reloadRows(at: [indexPath], with: .none)
        countSelect += (listUser[indexPath.row].isChecked ? 1 : -1)
        btCheckAll?.isSelected = countSelect == listUser.count
        tbViewUserRequest.reloadData()
    }
    
    
    
}
