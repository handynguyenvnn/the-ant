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
    var cates = [CateObj]()
    var jobObj:TAJobObj?
    var superView:TAHomeViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        clCate.delegate = self
        clCate.dataSource = self
        isShowHeader = true
        isShowBackButton = true
        isHiddenBottomBar = true
        self.title = "Lĩnh vực"
        clCate.register(UINib.init(nibName: "TAHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAHomeCollectionViewCell")
        getCate()
    }
    func getCate(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getCate(uid: nil){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                self.cates = response as? [CateObj] ?? [CateObj]()
                self.checkSelect()
            }else{
                Toast(text: message, duration: 2).show()
            }
        }
    }
//    func checkSelect(){
//        for cateAll in cates{
//            for currentCate in DataCenter.sharedInstance.currentUser?.categoryMe ?? [CateObj()]{
//                if cateAll.internalIdentifier == currentCate.internalIdentifier{
//                    cateAll.isSeclect = true
//                }
//            }
//            for currentCate in DataCenter.sharedInstance.currentUser?.category_tmp ?? [CateObj()]{
//                if cateAll.internalIdentifier == currentCate.internalIdentifier{
//                    cateAll.isTmp = true
//                }
//            }
//        }
//        clCate.reloadData()
//    }
    func checkSelect(){
        for cateAll in cates{
            for currentCate in DataCenter.sharedInstance.currentUser?.categoryMe ?? [CateObj()]{
                if cateAll.internalIdentifier == currentCate.internalIdentifier{
                    cateAll.isSeclect = true
                }
            }
            for currentCate in DataCenter.sharedInstance.currentUser?.cate_fav ?? [CateObj()]{
                if cateAll.internalIdentifier == currentCate.internalIdentifier{
                    cateAll.isFav = true
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
        Services.shareInstance.updateCate(cate_ids: cates.filter{$0.isSeclect}){(response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.init(text: message,duration: 2.0).show()
            if errorCode == SUCCESS_CODE{
                DataCenter.sharedInstance.currentUser = response as? UserObj
                DataCenter.sharedInstance.cates = DataCenter.sharedInstance.currentUser?.cate_fav
                self.superView?.reloadData()
                DataCenter.sharedInstance.homeVC?.cates =  DataCenter.sharedInstance.currentUser?.cate_fav ?? [CateObj]()
                DataCenter.sharedInstance.homeVC?.clCate.reloadData()
                self.navigationController?.popViewController(animated: true)
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
        cell.setupData(obj: cates[indexPath.row],isShowCheck: false,isShowImg: true)
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cates[indexPath.row].isSeclect = !cates[indexPath.row].isSeclect
        clCate.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: clCate.frame.width/2 - 5, height: clCate.frame.width/2 - 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
  
}
