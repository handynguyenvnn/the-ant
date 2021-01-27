//
//  TaPopUpBankInFoViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 10/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster
class TaPopUpBankInFoViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtDecs: UITextView!
    @IBOutlet weak var txtMoney: UITextField!
     var profile:UserObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMoney.addTarget(self, action: #selector(formatPrice), for: .editingChanged)
        txtDecs.text = "Ghi chú"
        txtDecs.delegate = self
        txtDecs.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    @IBAction func onRequest(_ sender: Any) {
        let price = txtMoney.text?.replacingOccurrences(of: ".", with: "") ?? ""
        if Int(price) ?? 0 < 1_000_000{
            self.view.showToast(message: "Số tiền phải rút phải lớn hơn 1.000.000", position: .top)
        }else{
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.withdrawalRequest(user_id: profile?.internalIdentifier ?? "", price: "\(price)", note: txtDecs.text ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message, duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    @objc func formatPrice (){
        if let price = txtMoney.text?.replacingOccurrences(of: ".", with: "") {
            txtMoney.text = Utilitys.getDefaultStringPrice(originString: Float(price) as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)
            
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ghi chú"
            textView.textColor = UIColor.lightGray
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
