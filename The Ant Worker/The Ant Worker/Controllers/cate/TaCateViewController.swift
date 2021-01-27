//
//  TaCateViewController.swift
//  The Ant
//
//  Created by Quyet on 7/18/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
class TaCateViewController: BaseViewController {
    @IBOutlet weak var clCate: UICollectionView!
    @IBOutlet weak var btnLinhVuc: UIButton!
    var cates = [CateObj]()
    var profile:UserObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        clCate.delegate = self
        clCate.dataSource = self
        isShowHeaderNoti = true
        isShowBackButton = true
        isHiddenBottomBar = true
        self.title = "Lĩnh vực"
        clCate.register(UINib.init(nibName: "TAHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAHomeCollectionViewCell")
        getCate()
        if profile?.status == 1{
            btnLinhVuc.isHidden = true
        }else{
            btnLinhVuc.isHidden = false
        }
    }
    func getCate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getCate(uid: nil){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.cates = response as? [CateObj] ?? [CateObj]()
                self.chekcStateCate()
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
    func checkSelect(){
        for cateAll in cates{
            for currentCate in DataCenter.sharedInstance.currentUser?.categoryMe ?? [CateObj()]{
                if cateAll.internalIdentifier == currentCate.internalIdentifier{
                    cateAll.isSeclect = true
                }
            }
            for currentCate in DataCenter.sharedInstance.currentUser?.category_tmp ?? [CateObj()]{
                if cateAll.internalIdentifier == currentCate.internalIdentifier{
                    cateAll.isTmp = true
                }
            }
        }
        clCate.reloadData()
    }
    func chekcStateCate(){
        for cateAll in cates{
            if let indexTmp = DataCenter.sharedInstance.currentUser?.category_tmp?.firstIndex(where: { (itemTMP) -> Bool in
                return cateAll.internalIdentifier == itemTMP.internalIdentifier
            })
            {
                //check cate co trong tmp(đang yêu cầu tích vàng)
                cateAll.isTmp = true
            }
            else
            {
                if let indexCateMe = DataCenter.sharedInstance.currentUser?.categoryMe?.firstIndex(where: { (itemMe) -> Bool in
                    return cateAll.internalIdentifier == itemMe.internalIdentifier
                })
                {
                    /// cate đã được thông qua(tích xanh)
                    cateAll.isSeclect = true
                }
            }
        }
        clCate.reloadData()
    }
    @IBAction func onHoanThanh(_ sender: Any) {
        updateCate()
    }
    func updateCate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.updateCate(cate_ids: cates.filter{$0.isTmp || $0.isSeclect}){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message,duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                DataCenter.sharedInstance.listCate = nil
                self.getDetaiUser()
                DataCenter.sharedInstance.listCate = DataCenter.sharedInstance.currentUser?.category_tmp
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func getDetaiUser(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getMyProfileDetai{(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE
            {
                DataCenter.sharedInstance.currentUser = response as? UserObj ?? UserObj()
            }
            else
            {
                Toast(text: message, duration: 2).show()
            }
            
        }
    }
}
extension TaCateViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAHomeCollectionViewCell", for: indexPath) as! TAHomeCollectionViewCell
        cell.setupData(obj: cates[indexPath.row],isShowCheck: false,isShowBtnStatus:true)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if profile?.status == 0 && cates[indexPath.row].isSeclect == false {
            cates[indexPath.row].isTmp = !cates[indexPath.row].isTmp
            clCate.reloadItems(at: [indexPath])
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: clCate.frame.width/2 - 5, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}
