//
//  TaProfileUserViewController.swift
//  The Ant
//
//  Created by Quyet on 7/22/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import MBProgressHUD
import Toaster
import IDMPhotoBrowser
enum GENDER : Int{
    case MEN = 0
    case WOMEN = 1
    case CANCEL = 2 
    case NONE = -1
    func des() -> String {
        switch self {
        case .MEN:
            return "Nam"
        case .WOMEN:
            return "Nữ"
        case .CANCEL:
            return "Khác"
        default:
            return ""
        }
    }
}
class TaProfileUserViewController: BaseViewController {
    @IBOutlet weak var lbCodeUser: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbFullName: UILabel!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbField: UILabel!
    @IBOutlet weak var lbDecs: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var lbGioiTinh: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    ///thông tin cá nhân khi lấy dữ liệu trả về
    var currentUser:UserObj?
    var imageSelected:UIImage?
    var listGender = [GENDER.MEN,GENDER.WOMEN,GENDER.CANCEL]
    var currenGender:GENDER?
    var imgRealWork = [ImageObj]()
    /// thông tin user bắn từ màn detail work sang
    var curentUserWork:UserWorkers?
    override func viewDidLoad() {
        super.viewDidLoad()
        clView.delegate = self
        clView.dataSource = self
        clView.register(UINib.init(nibName: "TAProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TAProfileCollectionViewCell")
        isShowBackButton = true
        isShowHeader = true
        self.title = "Thông tin cá nhân "
        getDataProfile()
        // Do any additional setup after loading the view.
    }
    func fillData(){
        if currentUser != nil {
            imgAvatar.sd_setImage(with: URL.init(string: currentUser?.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: SDWebImageOptions.queryDiskDataSync, completed: nil)
            lbFullName.text = currentUser?.name ?? ""
            lbDecs.text = currentUser?.decs ?? ""
            lbAddress.text = currentUser?.address ?? ""
            txtEmail.text = currentUser?.email ?? ""
            txtPhone.text = currentUser?.phone ?? ""
            txtBirthday.text = currentUser?.birthday ?? ""
            lbPrice.text = currentUser?.price ?? ""
            for imgEdit in currentUser?.images ?? [ImageObj()]{
                imgRealWork.append(ImageObj.init(url: imgEdit ))
                clView.reloadData()
            }
            lbCodeUser.text = "Mã người dùng:\(currentUser?.code ?? "")"
            lbCode.text = currentUser?.code ?? ""
            lbGioiTinh.text = currentUser?.subGENDER.des()
            lbNumber.text = "\(currentUser?.rate ?? 0)"
        }
        if self.currentUser?.images?.count ?? 0 == 0 {
            self.viewCollection.isHidden = true
        }else{
            self.clView.reloadData()
        }
    }
    func getDataProfile(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.getProfile(uid:curentUserWork?.internalIdentifier ?? ""){(response, message, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == SUCCESS_CODE {
                self.currentUser = response as? UserObj
                self.fillData()
            }
            Toast.init(text: message, duration: 2.0).show()
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
extension TaProfileUserViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser?.realImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAProfileCollectionViewCell", for: indexPath) as! TAProfileCollectionViewCell
        cell.setupData(obj:currentUser?.images?[indexPath.row] ?? ImageObj() )
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TAProfileCollectionViewCell
        if let img =  cell.imgAva.image
        {
            self.showFullListImg(arrImg: currentUser?.images ?? [ImageObj](), index: indexPath.row)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: clView.frame.height, height: clView.frame.height)
    }
}
extension TaProfileUserViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgAvatar.image = pickedImage
            imageSelected = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
