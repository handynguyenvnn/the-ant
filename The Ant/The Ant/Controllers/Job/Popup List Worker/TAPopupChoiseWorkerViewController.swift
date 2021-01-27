//
//  TAPopupChoiseWorkerViewController.swift
//  The Ant
//
//  Created by Khiem on 2019-07-17.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Presentr
import SwiftyJSON

protocol ChoiseWorkerDelegate {
    func choiseSuccess(worker:[UserWorkers],reason:String?)
}
class TAPopupChoiseWorkerViewController: UIViewController {
    let heightForDone:CGFloat = 380
    let heightForCancel:CGFloat = 480
    var containerVC:UIViewController?
    
    @IBOutlet weak var viewCheckAll: UIView!
    @IBOutlet weak var clWorker: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtDecs: UITextView!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var btnDone: UIButton?
    @IBOutlet weak var btnCancel: UIButton?
    @IBOutlet weak var btnAll: UIButton?
    var delegate:ChoiseWorkerDelegate?
    var workers = [UserWorkers]()
    var type:TypeCompleteWork?
    ///dem so dg dc chon
    var countSelect = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        clWorker.dataSource = self
        clWorker.delegate = self
        clWorker.register(UINib.init(nibName: "TAWorkerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAWorkerCollectionViewCell")
        //fakeData()
        txtDecs.text = "Lý do huỷ"
        txtDecs.delegate = self
        txtDecs.textColor = UIColor.lightGray
        
        if type == .CANCEL || type == .DONE_AT_NOW
        {
            viewReason.isHidden = true
            btnCancel?.isHidden = false
            btnDone?.isHidden = true
        }else if type == .RECREATE{
            btnCancel?.isHidden = false
            btnDone?.isHidden = false
            viewReason.isHidden = true
            btnDone?.setTitle("Đăng lại", for: .normal)
            btnCancel?.setTitle("Huỷ bỏ", for: .normal)
        }
        else
        {
            viewReason.isHidden = true
            btnCancel?.isHidden = true

            btnDone?.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        clWorker.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        workers.forEach { (data) in
            data.isChecked = false
        }
    }
    @IBAction func onDone(_ sender:Any)
    {
        if self.countSelect < 1 && type != .RECREATE
        {
            self.view.makeToast("Bạn chưa chọn nhân viên")
            return
        }
        if delegate != nil
        {
            delegate?.choiseSuccess(worker: self.workers, reason: txtDecs.text)
            self.dismiss(animated:true)
        }
    }
    @IBAction func onCancel(_ sender:Any)
    {
        if type == .RECREATE{
            self.dismiss(animated:true)
            return 
        }
        if self.countSelect < 1
        {
            self.view.makeToast("Bạn chưa chọn nhân viên")
            return
        }
        if delegate != nil
        {
            delegate?.choiseSuccess(worker: self.workers, reason: txtDecs.text)
            self.dismiss(animated:true)
        }
    }
    
    @IBAction func onAll(_ sender:Any)
    {
        btnAll?.isSelected = !(btnAll?.isSelected ?? false)
        workers.forEach { (data) in
            data.isChecked = btnAll?.isSelected ?? false
        }
        countSelect = (btnAll?.isSelected ?? false) ? workers.count : 0
        clWorker.reloadData()
    }

    /*
     * create new, bottom popup
     */
    static func show(mainVC:UIViewController,type:TypeCompleteWork = .DONE_100_PERCENT,dataWorker:[UserWorkers]?){
        if let popupVC:TAPopupChoiseWorkerViewController = TAPopupChoiseWorkerViewController(nibName: "TAPopupChoiseWorkerViewController", bundle: nil) as? TAPopupChoiseWorkerViewController
        {
            let heightVC:CGFloat = type == .CANCEL ? popupVC.heightForCancel:popupVC.heightForDone
            popupVC.containerVC = mainVC
            let yVC = (AppDelegate.sharedInstance.window?.frame.height ?? 0) - heightVC
            popupVC.delegate = mainVC as? ChoiseWorkerDelegate
            popupVC.type = type
            popupVC.workers = dataWorker ?? [UserWorkers]()
            let presenter: Presentr = {
                let width = ModalSize.full
                let height = ModalSize.custom(size: Float(heightVC)) //ModalSize.fluid(percentage: 0.20)
                let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: yVC))
                let customType = PresentationType.custom(width: width, height: height, center: center)
                
                let customPresenter = Presentr(presentationType: customType)
                customPresenter.transitionType =  TransitionType.coverVertical
                customPresenter.dismissTransitionType = .crossDissolve
                customPresenter.roundCorners = true
                customPresenter.backgroundColor = .black
                customPresenter.backgroundOpacity = 0.3
                customPresenter.dismissOnSwipe = true
                customPresenter.dismissOnSwipeDirection = .bottom
                customPresenter.cornerRadius = 10
                return customPresenter
            }()
            
            mainVC.customPresentViewController(presenter, viewController: popupVC, animated: true)
        }
        
    }
}
extension TAPopupChoiseWorkerViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAWorkerCollectionViewCell", for: indexPath) as! TAWorkerCollectionViewCell
        if indexPath.row < workers.count
        {
            cell.setup(obj: workers[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = TAWorkerCollectionViewCell.height
        var width:CGFloat = TAWorkerCollectionViewCell.width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < workers.count
        {
            workers[indexPath.row].isChecked = !workers[indexPath.row].isChecked
            collectionView.reloadItems(at: [indexPath])
            
            countSelect += (workers[indexPath.row].isChecked ? 1 : -1)
            btnAll?.isSelected = countSelect == workers.count
        }
    }
    
}
extension TAPopupChoiseWorkerViewController:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Lý do huỷ"
            textView.textColor = UIColor.lightGray
        }
    }
}
