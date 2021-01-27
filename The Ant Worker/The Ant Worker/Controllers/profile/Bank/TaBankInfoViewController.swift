//
//  TaBankInfoViewController.swift
//  The Ant
//
//  Created by Quyet on 10/3/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import DropDown
import Toaster
class TaBankInfoViewController: BaseViewController {
    @IBOutlet weak var txtChiNhanh: SSTextField!
    @IBOutlet weak var txtFullName: SSTextField!
    @IBOutlet weak var txtNameBank: SSTextField!
    @IBOutlet weak var txtSoTaiKhoan: SSTextField!
    var superView:TAProfileViewController?
    var currentPage:Int = 1
    var profile:UserObj?
    var bankShort:String = ""
    var codeBank:String = ""
    var nameBank:String = ""
    var idBank:String = ""
    var listBank = [ListBankObj]()
    var currentBank:ListBankObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin ngân hàng"
        isShowBackButton = true
        isShowHeaderNoti = true
        fillData()
        //getListBank()
        // Do any additional setup after loading the view.
    }
    @IBAction func onNameBank(_ sender: Any) {
        if listBank.isEmpty
        {
            getListBank()
        }
        else
        {
            self.showDropdown(data: listBank.map{$0.shortName ?? ""}, target: self.txtNameBank, selectIndex: nil)
        }
    }
    @IBAction func onUpdate(_ sender: Any) {
        postInfoBank()
    }
    func postInfoBank(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.postBankInfo(
        bank_id: idBank ,
        account_name: txtFullName.text ?? "",
        branch_name: txtChiNhanh.text ?? "",
        account_number: txtSoTaiKhoan.text ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE {
                DataCenter.sharedInstance.currentUser = self.profile
//                if self.profile != nil{
//                    UserDefaults.saveUserObj(obj: self.profile!)
//                }
                //DataCenter.sharedInstance.currentUser?.bank_name = self.codeBank
               //DataCenter.sharedInstance.currentUser?.bank_short_name = self.bankShort
                
                  DataCenter.sharedInstance.currentUser?.account_name = self.txtFullName.text
                  DataCenter.sharedInstance.currentUser?.account_number  = self.txtSoTaiKhoan.text
                  DataCenter.sharedInstance.currentUser?.branch_name = self.txtChiNhanh.text
                  DataCenter.sharedInstance.currentUser?.bank_short_name = self.txtNameBank.text
                DataCenter.sharedInstance.currentUser?.bank_id = self.idBank
                self.superView?.profile = DataCenter.sharedInstance.currentUser
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    func showDropdown(data:[String],target:UITextField?,selectIndex:Int?) {
        let dropDown = DropDown()
        dropDown.anchorView = target
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height) ?? 0)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height ?? 0.0))
        dropDown.cellNib = UINib(nibName: "TaBankNameTableViewCell", bundle: nil)
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? TaBankNameTableViewCell else { print("ádfas"); return }
            cell.logoImageView.sd_setImage(with: URL.init(string: self.listBank[index].image ?? "" )!, placeholderImage: nil, options: .refreshCached, completed: nil)
            // Setup your custom UI components
        }
        if selectIndex != nil && selectIndex ?? 0 < data.count
        {
            dropDown.selectRow(selectIndex ?? 0)
        }
        
        
        if let font = UIFont.init(name: "Muli-Regular", size: 14.0){
            dropDown.textFont = font
        }
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            target?.text = item
            self.bankShort = self.listBank[index].shortName ?? ""
            self.codeBank = self.listBank[index].code ?? ""
            self.nameBank = self.listBank[index].name ?? ""
            self.idBank = self.listBank[index].internalIdentifier ?? ""

        }
        dropDown.show()
        
    }
    func getListBank(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getListBank(page: currentPage) { (response, message, isNextPage, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.listBank = response as? [ListBankObj] ?? [ListBankObj]()
                self.showDropdown(data: self.listBank.map{$0.shortName ?? ""}, target: self.txtNameBank, selectIndex: nil)
            }
        }
    }
    func fillData(){
        if DataCenter.sharedInstance.currentUser != nil{
            self.profile = DataCenter.sharedInstance.currentUser
            txtFullName.text = profile?.account_name ?? ""
            txtSoTaiKhoan.text = profile?.account_number ?? ""
            txtChiNhanh.text = profile?.branch_name ?? ""
            txtNameBank.text = profile?.bank_short_name ?? ""
            self.idBank = profile?.bank_id ?? ""
            
            
        }
    }
}
