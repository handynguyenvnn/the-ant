//
//  TaBoLocViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 8/15/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import MBProgressHUD
import Toaster
enum STATUS_JOB : Int{
    case NEW = 1 // Mới 
    case InProgress = 2 // Đang chạy, show hoàn thành và huỷ
    case CANCEL = 3 // show đặt lại
    case DONE = 4// show đặt lại
    case NONE = -1 // lỗi
    func des() -> String {
        switch self {
        case .NEW:
            return "Mới"
        case .InProgress:
            return "Đủ"
        case .CANCEL:
            return "Hủy bỏ"
        case .DONE:
            return "Hoàn thành"
        default:
            return ""
        }
    }
}
class TaBoLocViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbCate: UILabel!
    @IBOutlet weak var tbCate: UITableView!
    @IBOutlet weak var tbCateHeight: NSLayoutConstraint!
    var currentCate:CateObj?
    var listCate = [CateObj]()
    var curentJob :TAJobObj?
    var listCodi = [ConditionObj]()
    var listStatus = [STATUS_JOB.NEW,STATUS_JOB.InProgress,STATUS_JOB.CANCEL,STATUS_JOB.DONE]
    var currentStatus:STATUS_JOB? = .NEW
    var superView:TAHomeViewController?
    var listCateSelected = [CateObj]()
    var noName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbCate.dataSource = self
        tbCate.delegate = self
        tbCate.register(UINib.init(nibName: "TaTbSpecialConditionPostJobTableViewCell", bundle: nil), forCellReuseIdentifier: "TaTbSpecialConditionPostJobTableViewCell")
        //lbCate.text = currentCate?.name ?? ""
        //lbStatus.text = currentStatus?.des()
        txtName.text = noName ?? ""
        getCate()
        for cate in listCate{
            if listCateSelected.contains(cate){
                cate.isSelected = true
            }
        }
        //isShowHeaderFillter = true
        //        self.title = "Lọc"
        //        isShowBackButton = true
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onRefresh(_ sender: Any) {
        //lbStatus.text = ""
        //lbCate.text = ""
        //currentCate = nil
        txtName.text = ""
    }
    
    @IBAction func onCate(_ sender: Any) {
//        if listCate.count == 0
//        {
//            getCate()
//        }
//        else
//        {
//            self.showDropdown(data: listCate.map{$0.name ?? ""}, target: self.lbCate, selectIndex: nil)
//        }
    }
    @IBAction func onStatus(_ sender: Any) {
        self.showDropdown(data: listStatus.map{$0.des()}, target: self.lbStatus, selectIndex: nil)
    }
    
    @IBAction func onApproved(_ sender: Any) {
        superView?.currentStatus = self.currentStatus ?? .NEW
        superView?.noName = self.txtName.text
        superView?.listCatesSelected = self.listCate.filter{$0.isSelected}
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
                self.tbCate.reloadData()
                self.tbCateHeight.constant = CGFloat(HEIGHT_CELL_SPE_CODIONTION * self.listCate.count)
                //self.showDropdown(data: self.listCate.map{$0.name ?? ""}, target: self.lbCate, selectIndex: nil)
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
extension TaBoLocViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaTbSpecialConditionPostJobTableViewCell", for: indexPath) as! TaTbSpecialConditionPostJobTableViewCell
        cell.selectionStyle = .none
        cell.setup(obj: listCate[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listCate[indexPath.row].isSelected = !listCate[indexPath.row].isSelected
//        if listCate[indexPath.row].isSelected{
//            listCateSelected.append(listCate[indexPath.row])
//        }else{
//            listCateSelected.removeAll { (obj) -> Bool in
//                obj.internalIdentifier == listCate[indexPath.row].internalIdentifier
//            }
//        }
        tbCate.reloadData()
    }
    
    
}
