//
//  TANewsViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
class TANewsViewController: BaseViewController {
    @IBOutlet weak var tbViewNew: UITableView!
    var listNew = [TAPostObj]()
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tin tức"
        isShowHeader = true
        isShowNoti = true
        tbViewNew.dataSource = self
        tbViewNew.delegate = self
        tbViewNew.register(UINib.init(nibName: "TANewTableViewCell", bundle: nil), forCellReuseIdentifier: "TANewTableViewCell")
        getData()
        isHiddenBottomBar = false
        tbViewNew?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbViewNew?.finishInfiniteScroll()
            }
        }
        if #available(iOS 10.0, *) {
            self.tbViewNew?.refreshControl = refreshControl
        } else {
            self.tbViewNew?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    @objc func reloadData()  {
        self.listNew.removeAll()
        if listNew != nil {
            tbViewNew!.reloadData()
        }
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
    }
    func getData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListPost(page: currentPage) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbViewNew?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE
            {
                if self.currentPage == 1{
                    self.listNew = response as? [TAPostObj] ?? [TAPostObj]()
                }
                else{
                    self.listNew += response as? [TAPostObj] ?? [TAPostObj]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                self.tbViewNew.reloadData()
                
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
extension TANewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TANewTableViewCell", for: indexPath) as! TANewTableViewCell
        cell.selectionStyle = .none
        cell.setup(obj: listNew[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPostVC:TaNewsDetailViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TaNewsDetailViewController") as! TaNewsDetailViewController
        detailPostVC.currentNews = listNew[indexPath.row]
        detailPostVC.isCheckVC = false
        self.navigationController?.pushViewController(detailPostVC, animated: true)
    }
    
    
}
