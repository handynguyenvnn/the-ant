//
//  STFilterViewController.swift
//  Student 3T
//
//  Created by Tung Nguyen on 7/29/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import MBProgressHUD
import Toaster

class STFilterViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbCate: UILabel!
    @IBOutlet weak var tbCate: UITableView!
    var currentCate:CateObj?
    var listCate = [CateObj]()
    var curentJob :TAJobObj?
    var listStatus = [STATUS_JOB.NEW,STATUS_JOB.InProgress,STATUS_JOB.CANCEL,STATUS_JOB.DONE]
    var currentStatus:STATUS_JOB? = .NEW
    var superView:TAHomeViewController?
    var noName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        lbCate.text = currentCate?.name ?? ""
        lbStatus.text = currentStatus?.des()
        txtName.text = noName ?? ""
        //isShowHeaderFillter = true
//        self.title = "Lọc"
//        isShowBackButton = true
        
    }
    @IBAction func onRefresh(_ sender: Any) {
        lbStatus.text = ""
        lbCate.text = ""
        currentCate = nil
        txtName.text = ""
    }

    @IBAction func onCate(_ sender: Any) {
        if listCate.count == 0
        {
            getCate()
        }
        else
        {
            self.showDropdown(data: listCate.map{$0.name ?? ""}, target: self.lbCate, selectIndex: nil)
        }
    }
    @IBAction func onStatus(_ sender: Any) {
        self.showDropdown(data: listStatus.map{$0.des()}, target: self.lbStatus, selectIndex: nil)
    }

    @IBAction func onApproved(_ sender: Any) {
        superView?.currentCate = self.currentCate
        superView?.currentStatus = self.currentStatus ?? .NEW
        superView?.noName = self.txtName.text
        superView?.reloadData()
        dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func onReject(_ sender: Any) {
        dismiss(animated: true, completion: nil)
//        lbStatus.text = ""
//        txtName.text = ""
        
    }
    func showDropdown(data:[String],target:UILabel?,selectIndex:Int?) {
        let dropDown = DropDown()
        dropDown.anchorView = target
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height) ?? 0)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height ?? 0.0))
        if selectIndex != nil && selectIndex ?? 0 < data.count
        {
            dropDown.selectRow(selectIndex ?? 0)
        }
        
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 14.0){
            dropDown.textFont = font
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            target?.text = item
            if target == self.lbCate{
                self.currentCate = self.listCate[index]
            }
            else{
                self.currentStatus = self.listStatus[index]
            }
        }
        dropDown.show()
        
    }
    func getCate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getCate(uid: "\(DataCenter.sharedInstance.currentUser?.internalIdentifier ?? "")"){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.listCate = response as? [CateObj] ?? [CateObj]()
                self.showDropdown(data: self.listCate.map{$0.name ?? ""}, target: self.lbCate, selectIndex: nil)
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
