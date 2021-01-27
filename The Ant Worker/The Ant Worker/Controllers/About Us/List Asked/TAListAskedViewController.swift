//
//  TAListAskedViewController.swift
//  The Ant
//
//  Created by Anh Quan on 7/31/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import Presentr
import MBProgressHUD
class TAListAskedViewController: BaseViewController {
    @IBOutlet weak var tbListAsked: UITableView!
    var listAsked:[ListAskObj] = [ListAskObj]()
    var currentPage:Int = 1
    var isLoadMore:Bool = true
    let heightVC:CGFloat = 400
    var index = 0
    var idAbout = ""
    var content:String = ""
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowHeaderJobDetail = true
        isShowBackButton = true
        self.navigationItem.title = content
        isHiddenBottomBar = true
        self.navigationItem.title = "Câu hỏi thường gặp"
        tbListAsked.delegate = self
        tbListAsked.dataSource = self
        tbListAsked.register(UINib(nibName: "TAListAskedTableViewCell", bundle: nil), forCellReuseIdentifier: "TAListAskedTableViewCell")
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            self.tbListAsked?.refreshControl = refreshControl
        } else {
            self.tbListAsked?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tbListAsked!.addInfiniteScroll { (tb) in
            if self.isLoadMore{
                self.getListAsked()
            } else {
                self.tbListAsked?.finishInfiniteScroll()
            }
        }
        self.getListAsked()
    }
    @objc func reloadData (){
        self.listAsked.removeAll()
        if listAsked != nil {
            tbListAsked!.reloadData()
        }
        self.isLoadMore = true
        self.currentPage = 1
        self.getListAsked()
    }
    func getListAsked(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListAsked(fid: idAbout){(response, message,isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
             self.refreshControl.endRefreshing()
            if errorCode == SUCCESS_CODE{
                self.listAsked = response as? [ListAskObj] ?? [ListAskObj]()
                self.tbListAsked.reloadData()
            }else{
                Toast(text: message, duration: 2).show()
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
extension TAListAskedViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAsked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TAListAskedTableViewCell", for: indexPath) as! TAListAskedTableViewCell
        cell.selectionStyle = .none
        cell.fillData(obj: listAsked[indexPath.row],index:indexPath.row)
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 148
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listAsked[indexPath.row].isExpand = !listAsked[indexPath.row].isExpand
        tableView.reloadRows(at: [indexPath], with: .automatic)
//        index = indexPath.row
//        getListAsked()
    }
}
