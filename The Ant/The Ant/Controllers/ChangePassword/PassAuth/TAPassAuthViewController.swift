//
//  TAPassAuthViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAPassAuthViewController: BaseViewController {
    @IBOutlet weak var txtPassAuth: SSTextField!
    var phone:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeader = true
        self.navigationItem.title = "Xác Thực"
        // Do any additional setup after loading the view.
    }
    func isValid() -> Bool{
        if txtPassAuth.text == "" {
            self.view.showToast(message: "Mời bạn nhập mã Otp", position: .center)
            txtPassAuth.becomeFirstResponder()
            return false
        }
        return true
    }
    func goForPassword(){
        if isValid(){
        let comfirmVC:TAChangePassViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAChangePassViewController") as! TAChangePassViewController
            comfirmVC.phone = phone
            comfirmVC.code = txtPassAuth.text ?? ""
            comfirmVC.isChangePassword = false
        self.navigationController?.pushViewController(comfirmVC, animated: true)
        }
    }
    @IBAction func bntSentTo(_ sender: Any) {
    }
    
    @IBAction func bntAuth(_ sender: Any) {
        goForPassword()
    }

    

}
