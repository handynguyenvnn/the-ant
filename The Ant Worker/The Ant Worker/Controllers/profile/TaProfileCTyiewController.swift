//
//  TaProfileCTyiewController.swift
//  The Ant
//
//  Created by Quyet on 10/1/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
class TaProfileCTyiewController: BaseViewController {

    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbTenCongTy: UILabel!
    @IBOutlet weak var lbDecs: UILabel!
    var profile:UserObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        self.title = "Thông tin"
        isShowHeaderJobDetail = true
        getDetaiUser()
        // Do any additional setup after loading the view.
    }
    @IBAction func onCallPhone(_ sender: Any) {
        let alertVC:UIAlertController = UIAlertController.init(title: "Thông báo", message: "Bạn đang yêu cầu trợ giúp,liên hệ với The Ant theo số \(profile?.phone ?? "") để được trợ giúp?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Huỷ ", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Liên hệ", style: .default, handler: { (alertView) in
            Utilitys.call(phoneNumber: DataCenter.sharedInstance.currentUser?.hotline ?? "")
        })
        )
        self.present(alertVC, animated: true, completion: nil)
    }
    func fillData(){
        lbPhone.text = profile?.phone ?? ""
        lbTenCongTy.text = profile?.name ?? ""
        lbAddress.text = profile?.address ?? ""
        lbDecs.text = profile?.summary ?? ""
    }
    func getDetaiUser(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getFAQINFO(page: 0){(response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == SUCCESS_CODE
            {
                self.profile = response as? UserObj ?? UserObj()
                self.fillData()
            }
            else
            {
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
