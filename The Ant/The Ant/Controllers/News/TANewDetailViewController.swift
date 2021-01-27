//
//  TANewDetailViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
 let baseUrlBankInfo = "http://45.76.182.238:8888/systembank"
class TANewDetailViewController: BaseViewController {
    @IBOutlet weak var lbNewDetail: UIWebView!
    var currentNews:TAPostObj?
    var isCheckVC:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lbNewDetail.delegate = self
        isShowBackButton = true
        isShowHeader = true
        if !isCheckVC{
            self.navigationItem.title = currentNews?.title
        }else{
            self.title = "Chuyển khoản thanh toán"
        }
        // Do any additional setup after loading the view.
    }
    override func initData() {
        if !isCheckVC{
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getPostDetail(postId: currentNews?.internalIdentifier ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.currentNews = response as? TAPostObj
                self.lbNewDetail.loadHTMLString(self.currentNews?.content ?? "", baseURL: nil)
            }
            else{
                Toast(text: message, duration: 2.0).show()
            }
        }
        }else{
            if let url = URL(string: baseUrlBankInfo ){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                lbNewDetail.loadRequest(URLRequest(url: url))
            }
        }
        
    }
}
extension TANewDetailViewController : UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
