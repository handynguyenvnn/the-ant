//
//  TaNewsDetailViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 7/30/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
let baseUrlBankInfo = "http://45.76.182.238:8888/systembank"
class TaNewsDetailViewController: BaseViewController {

    @IBOutlet weak var webViewDettail: UIWebView!
    var currentNews:TAPostObj?
    var isCheckVC:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeader = true
        webViewDettail.delegate = self
        if !isCheckVC{
            self.navigationItem.title = currentNews?.title
        }else{
            self.title = "Chuyển khoản thanh toán"
        }
        postDettail()
        // Do any additional setup after loading the view.
    }
    func postDettail(){
        if !isCheckVC{
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getPostDetail(postId: currentNews?.internalIdentifier ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.currentNews = response as? TAPostObj
                self.webViewDettail.loadHTMLString(self.currentNews?.content ?? "", baseURL: nil)
            }
            else{
                Toast(text: message, duration: 2.0).show()
                }
            }
            }else{
                if let url = URL(string: baseUrlBankInfo ){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                webViewDettail.loadRequest(URLRequest(url: url))
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
extension TaNewsDetailViewController : UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

