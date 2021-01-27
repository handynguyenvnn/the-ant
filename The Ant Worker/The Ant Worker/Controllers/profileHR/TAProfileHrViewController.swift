//
//  TAProfileHrViewController.swift
//  The Ant Worker
//
//  Created by Tung Nguyen on 8/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import MBProgressHUD
import Toaster
import IDMPhotoBrowser
class TAProfileHrViewController: BaseViewController {
    @IBOutlet weak var lbCodeUser: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbGroup: UILabel!
    @IBOutlet weak var viewDecs: UIView!
    @IBOutlet weak var imPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbRate: UILabel!
    @IBOutlet weak var lbAccount: UILabel!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtBirthDay: UITextField!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var clEdentification: UICollectionView!
    @IBOutlet weak var viewColection: UIView!
    @IBOutlet weak var lbDecs: UILabel!
    var imageSelected:UIImage?
    var imgRealWork = [ImageObj]()
    var detailJob: TAJobObj?
    ///thông tin user
    var profile:UserObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeader = true
        isHiddenBottomBar = true
        self.title = "Thông tin cá nhân"
        fillData()
        clEdentification.delegate = self
        clEdentification.dataSource = self
        clEdentification.register(UINib.init(nibName: "TAProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAProfileCollectionViewCell")
        if detailJob != nil
        {
            getDataProfile()
        }
    }
    func fillData() {
        if profile != nil{
            lbCodeUser.text = "Mã người dùng:\(profile?.code ?? "")"
            lbCode.text = profile?.code ?? ""
            imPhoto.sd_setImage(with: URL.init(string: profile?.avatar ?? ""), placeholderImage: nil, options: .refreshCached, completed: nil)
            lbName.text = profile?.name ?? ""
//            lbStatus.text = profile?.status ?? 0
            lbAccount.text = profile?.price ?? ""
            txtPhone.text = profile?.phone ?? ""
            txtEmail.text = profile?.email ?? ""
            txtBirthDay.text = profile?.birthday ?? ""
            lbAdress.text = profile?.address ?? ""
            lbDecs.text = profile?.desc ?? ""
            lbGroup.text = profile?.subTypeCus.des()  
            for imgEdit in profile?.images ?? [ImageObj()]{
                imgRealWork.append(ImageObj.init(url: imgEdit ))
                clEdentification.reloadData()
            }
            lbRate.text = "\(profile?.rate ?? 0)"
        }
        if self.profile?.images?.count ?? 0 == 0 {
            self.viewColection.isHidden = true
        }else{
            self.clEdentification.reloadData()
        }
    }
    func getDataProfile(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getProfile(uid: detailJob?.user?.internalIdentifier ?? ""){(response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == SUCCESS_CODE {
                self.profile = response as? UserObj
                self.fillData()
            }
            else{
                Toast.init(text: message, duration: 2.0).show()
            }
        }
    }
    //
    func showFullImg(img:UIImage)
    {
        if let idmImg = IDMPhoto.init(image: img)
        {
            let idmPhoto = IDMPhotoBrowser(photos: [idmImg] as [Any])
            idmPhoto?.displayToolbar = false
            self.present(idmPhoto ?? UIViewController(), animated: true, completion: nil)
        }
    }
    func showFullListImg(arrImg:[ImageObj],index:Int){
        var arrIdmImg = [IDMPhoto]()
        if arrImg.isEmpty{
            return
        }
        arrImg.forEach { (img) in
            if let idmImg = IDMPhoto.init(image:img.image)
            {
                arrIdmImg.append(idmImg)
            }
        }
        
        let idmPhoto = IDMPhotoBrowser(photos: arrIdmImg as [Any])
        idmPhoto?.setInitialPageIndex(UInt(index))
        idmPhoto?.displayToolbar = false
        self.present(idmPhoto ?? UIViewController(), animated: true, completion: nil)
    }
    //    func showListImg(img:UIImage){
    //        if IDMPhoto.init(image: img) != nil{
    //            let idmPhoto = IDMPhotoBrowser.init(photos: imgRealWork as [Any])
    //            idmPhoto?.displayToolbar = false
    //            self.present(idmPhoto ?? UIViewController(), animated: true, completion: nil)
    //        }
    //    }
}
extension TAProfileHrViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAProfileCollectionViewCell", for: indexPath) as! TAProfileCollectionViewCell
        cell.setupData(obj:profile?.images?[indexPath.row] ?? ImageObj() )
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TAProfileCollectionViewCell
        if let img =  cell.imgAva.image
        {
            self.showFullListImg(arrImg: profile?.images ?? [ImageObj](), index: indexPath.row)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: clEdentification.frame.height, height: clEdentification.frame.height)
    }
}
extension TAProfileHrViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imPhoto.image = pickedImage
            imageSelected = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
