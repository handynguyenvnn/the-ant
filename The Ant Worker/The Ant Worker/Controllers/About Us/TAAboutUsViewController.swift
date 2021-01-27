//
//  TAAboutUsViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/9/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import Presentr
import MBProgressHUD
class TAAboutUsViewController: BaseViewController {
    @IBOutlet weak var tbAboutUs: UITableView!
    var listAbout:[ListAboutObj] = [ListAboutObj]()
    var currentPage:Int = 1
    var isLoadMore:Bool = true
    let heightVC:CGFloat = 400
    var refreshControl = UIRefreshControl()
    var isFAQ = false
    let arrData1 = ["Thông tin điều khoản","Câu hỏi thường gặp","Mời bạn bè","Liên hệ","Đánh giá ứng dụng"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tbAboutUs.delegate = self
        tbAboutUs.dataSource = self
        tbAboutUs.register(UINib(nibName: "TAAboutUsTableViewCell", bundle: nil), forCellReuseIdentifier: "TAAboutUsTableViewCell")
        isShowHeader = true
        isShowBackButton = true
        isHiddenBottomBar = true
        if isFAQ{
            self.navigationItem.title = "Câu hỏi thường gặp"
        }
        else{
            self.navigationItem.title = "Về chúng tôi"
        }
        
//        tbAboutUs.layer.shadowOpacity = 1
//        tbAboutUs.layer.shadowOffset = CGSize(width: 0, height: 2)
//        tbAboutUs.shadowRadius = 4
//        tbAboutUs.layer.shadowColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
      
        
        if isFAQ{
            if #available(iOS 10.0, *) {
                self.tbAboutUs?.refreshControl = refreshControl
            } else {
                self.tbAboutUs?.addSubview(refreshControl)
            }
            refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
            self.tbAboutUs!.addInfiniteScroll { (tb) in
                if self.isLoadMore{
                    self.getListAbout()
                } else {
                    self.tbAboutUs?.finishInfiniteScroll()
                }
            }
            self.getListAbout()
        }
    }
    @objc func reloadData (){
        self.listAbout.removeAll()
        tbAboutUs.reloadData()
        self.isLoadMore = true
        self.currentPage = 1
        self.getListAbout()
    }
    func getListAbout(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListAbout(page: self.currentPage) {(response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tbAboutUs!.finishInfiniteScroll()
            self.refreshControl.endRefreshing()
            if errorCode == SUCCESS_CODE {
                if self.currentPage == 1
                {
                    self.listAbout = response as? [ListAboutObj] ?? [ListAboutObj]()
                }
                else
                {
                    self.listAbout += response as? [ListAboutObj] ?? [ListAboutObj]()
                }
                if self.tbAboutUs != nil {
                    self.tbAboutUs?.reloadData()
                    self.currentPage += 1
                } else {
                    Toast(text: message, delay: 0, duration: 2).show()
                }
                self.isLoadMore = isNextPage ?? false
            }
        }
    }

   
}
extension TAAboutUsViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFAQ{
            return listAbout.count
        }
        return arrData1.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TAAboutUsTableViewCell", for: indexPath) as! TAAboutUsTableViewCell
        cell.selectionStyle = .none
//        cell.setupCell()
//        cell.fillData(obj: arrData[indexPath.row])
        if isFAQ{
            cell.fillData(obj: listAbout[indexPath.row])
        }
        else{
            let obj = arrData1[indexPath.row]
            cell.setData(data: obj)
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFAQ{
            let listAskedVC = QuandaStoryBoard.instantiateViewController(withIdentifier: "TAListAskedViewController") as! TAListAskedViewController
            listAskedVC.idAbout = listAbout[indexPath.row].internalIdentifier ?? ""
            listAskedVC.content = listAbout[indexPath.row].title ?? ""
            self.navigationController?.pushViewController(listAskedVC, animated: true)
        }
        else{
            switch indexPath.row {
            case 0:
     
                break
            case 1:
                let listAskedVC = DuongStoryBoard.instantiateViewController(withIdentifier: "TAAboutUsViewController") as!TAAboutUsViewController
                listAskedVC.isFAQ = true
                self.navigationController?.pushViewController(listAskedVC, animated: true)
                break
            case 2:
                
                break

            case 3:
                let profileHR = JobStoryBoard.instantiateViewController(withIdentifier: "TaProfileCTyiewController") as!TaProfileCTyiewController
                self.navigationController?.pushViewController(profileHR, animated: true)
                break
            case 4:
                break
            default:
                break
            }
        }
    }
}
