//
//  TANewsViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
import Presentr
class TANewsViewController: BaseViewController {

    @IBOutlet weak var tbNew: UITableView!
    var refreshControl = UIRefreshControl()
    var isLoadMore:Bool = true
    var currentPage:Int = 1
    var listNews =  [TAPostObj]()
    var heightVC:CGFloat = 368
    override func viewDidLoad() {
        super.viewDidLoad()
        tbNew.delegate = self
        tbNew.dataSource = self
        isHiddenBottomBar = false
        tbNew.register(UINib(nibName: "TANewTableViewCell", bundle: nil), forCellReuseIdentifier: "TANewTableViewCell")
        isShowLeftTitle = true
        self.navigationItem.title = "Tin tức"
        isShowHeader = true
        isShowNoti = true
        getData()
        tbNew?.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getData()
            } else {
                self.tbNew?.finishInfiniteScroll()
            }
        }
        if #available(iOS 10.0, *) {
            self.tbNew?.refreshControl = refreshControl
        } else {
            self.tbNew?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
     func getData()  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListPost(page: currentPage) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.tbNew?.finishInfiniteScroll()
            if errorCode == SUCCESS_CODE
            {
                if self.currentPage == 1{
                    self.listNews = response as? [TAPostObj] ?? [TAPostObj]()
                }
                else{
                    self.listNews += response as? [TAPostObj] ?? [TAPostObj]()
                }
                //check có trang tiếp hay không
                self.isLoadMore = isNextPage ?? false
                //Nếu có trang tiếp thì tăng page lên 1
                if self.isLoadMore{
                    self.currentPage += 1
                }
                self.tbNew.reloadData()
                
            }
            else
            {
                self.view.makeToast(message)
            }
        }
    }
    @objc func reloadData()  {
        self.listNews.removeAll()
        tbNew.reloadData()
        self.isLoadMore = true
        self.currentPage = 1
        self.getData()
    }
}
extension TANewsViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TANewTableViewCell", for: indexPath) as! TANewTableViewCell
        cell.setup(obj: self.listNews[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MainStoryBoard.instantiateViewController(withIdentifier: "TANewDetailViewController") as! TANewDetailViewController
        detailVC.currentNews = self.listNews[indexPath.row]
        detailVC.isCheckVC = false
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
