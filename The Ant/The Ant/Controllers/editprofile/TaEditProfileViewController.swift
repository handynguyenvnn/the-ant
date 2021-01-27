//
//  TaEditProfileViewController.swift
//  The Ant Worker
//
//  Created by Quyet on 8/1/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toaster
import MBProgressHUD
import AVFoundation
import DatePickerDialog
import IDMPhotoBrowser
import YPImagePicker
import DropDown
class TaEditProfileViewController: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var clImage: UICollectionView!
    @IBOutlet weak var txtName: SSTextField!
    @IBOutlet weak var txtPhone: SSTextField!
    @IBOutlet weak var txtEmail: SSTextField!
    @IBOutlet weak var txtBirthday: SSTextField!
    @IBOutlet weak var btnBirthday: UIButton!
    @IBOutlet weak var txtAddress: SSTextField!
    @IBOutlet weak var txtDecs: UITextView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtGroup: SSTextField!
    var profile:UserObj?
    var listGroup = [CUSTOMTYPE.GROUP,CUSTOMTYPE.PRESON,CUSTOMTYPE.CANCEL]
    var curentGender:CUSTOMTYPE?
    var imgRealWork = [ImageObj]()
    ///biến này để check số ảnh đã đc upload
    var countCheckUpLoadImg:Int = 0
    /// số những ảnh mới đc update
    var countUpLoadImg:Int = 0
    let imagePicker = UIImagePickerController()
    var numberRequest = 0
    var imageSelected:UIImage?
    var birthday:Date = Date()
    var superView:TAProfileViewController?
    //let picker = YPImagePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cập nhật thông tin"
        isShowBackButton = true
        isShowHeader = true
        clImage.delegate = self
        clImage.dataSource = self
        clImage.register(UINib.init(nibName: "TaGiayToTuyThanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaGiayToTuyThanCollectionViewCell")
        self.fillData()
        imagePicker.delegate = self
        clImage.delegate = self
        txtPhone.delegate = self
        txtDecs.text = "Mô tả năng lực"
        txtDecs.delegate = self
        txtDecs.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        
//        if textView.text.isEmpty {
//            textView.text = "Mô tả năng lực"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    @IBAction func onGroup(_ sender: Any) {
        showDropdown(data: listGroup.map{$0.des()}, target: txtGroup, selectIndex: nil)
    }
    func showDropdown(data:[String],target:UITextField?,selectIndex:Int?) {
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
            self.curentGender = self.listGroup[index]
        }
        dropDown.show()
        
    }
    @IBAction func onBirthday(_ sender: Any) {
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show(
            "Thời gian",
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            defaultDate: Utilitys.getDateFromText("dd-MM-yyyy", profile?.birthday) ?? Date() ,
            maximumDate:Date(),
            datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    self.birthday = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    self.txtBirthday.text = formatter.string(from: dt)
                }
        }
    }
    func isValidEdit() -> Bool{
        if txtName.text == ""{
            self.view.showToast(message: "Mời bạn nhập họ và tên.", position: .top)
            txtName.becomeFirstResponder()
            return false
        }
        if txtEmail.text == ""{
            self.view.showToast(message: "Mời bạn nhập email.", position: .top)
            txtEmail.becomeFirstResponder()
            return false
        }
        if txtAddress.text == ""{
            self.view.showToast(message: "Mời bạn nhập địa chỉ.", position: .top)
            txtAddress.becomeFirstResponder()
            return false
        }
        if txtBirthday.text == ""{
            self.view.showToast(message: "Mời  bạn nhập ngày sinh.", position: .top)
            //txtBirthday.becomeFirstResponder()
            return false
        }
        return true
    }
    @IBAction func onEdit(_ sender: Any) {
        self.view.endEditing(true)
        if isValidEdit(){
//            MBProgressHUD.showAdded(to: self.view, animated: true)
            let listNewImage = imgRealWork.filter{$0.internalIdentifier == nil}
            imgRealWork.removeAll { (obj) -> Bool in
                obj.internalIdentifier == nil
            }
            countUpLoadImg = listNewImage.count
            if countUpLoadImg > 0{
                MBProgressHUD.showAdded(to: self.view, animated: true)
                for image in listNewImage{
                    upLoadImage(image: image.image ?? UIImage())
                }
            }
            else{
                editInfo()
            }
        }
    }

    func editInfo(){
        var decs = ""
        if txtDecs.text == "Mô tả năng lực"{
            decs = ""
        }else{
            decs = txtDecs.text
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.updateProfile(
            name: txtName.text ?? "",
            email: txtEmail.text ?? "",
            address: txtAddress.text ?? "",
            images: imgRealWork,
            birthday: Utilitys.stringToDate(withFormat: "dd-MM-yyyy",strDate: txtBirthday.text ?? "") ?? Date(),
            description:decs,
            sub_type: curentGender ?? profile?.subType ?? .NONE){ (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.checkUpdate()
            Toast(text: message, duration: 2).show()
            if errorCode == SUCCESS_CODE{
                let resJson = JSON.init(response!)
                let userInfo:UserObj = UserObj.init(json: resJson["data"])
                self.profile = userInfo
                DataCenter.sharedInstance.currentUser = self.profile
                if self.profile != nil{
                    UserDefaults.saveUserObj(obj: self.profile!)
                }
                self.superView?.profile = self.profile
                self.superView?.fillData()
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    func upLoadImage(image:UIImage){
        Services.shareInstance.uploadImg(selectedImages: image) { (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                self.imgRealWork.append((response as? ImageObj ?? ImageObj()))
            }
            self.countCheckUpLoadImg += 1
            self.checkUploadImg()
            //Toast.init(text: message, duration: 2.0).show()
        }
    }
    func checkUploadImg(){
        if countCheckUpLoadImg == countUpLoadImg{
            MBProgressHUD.hide(for: self.view, animated: true)
            editInfo()
            countCheckUpLoadImg = 0
        }
    }
    func checkUpdate(){
        numberRequest += 1
        if numberRequest == 2{
            MBProgressHUD.hide(for: self.view, animated: true)
            numberRequest = 0
        }
        else if imageSelected == nil{
            MBProgressHUD.hide(for: self.view, animated: true)
            numberRequest = 0
        }
    }
    func fillData(){
        if profile != nil {
            txtName.text = self.profile?.name ?? ""
            txtEmail.text = self.profile?.email ?? ""
            txtAddress.text = self.profile?.address ?? ""
            txtBirthday.text = self.profile?.birthday ?? ""
            //txtPhone.text = self.profile?.phone ?? ""
            for imgEdit in profile?.images ?? [ImageObj()]{
                imgRealWork.append(ImageObj.init(url: imgEdit ))
                clImage.reloadData()
            }
            txtGroup.text = self.profile?.subType.des()
            txtDecs.text = self.profile?.desc ?? ""
        }
    }
    func choiseImg() {
        
        let alert = UIAlertController(title: "Bạn có thể chụp hoặc tải ảnh có sẵn trên máy", message: "", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Tải hình từ điện thoại", style: .default) { (ACTION) in
            self.showLibrary()
        }
        
        let photo = UIAlertAction(title: "Chụp ảnh", style: .default) { (ACTION) in
            self.checkAccessCamera()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (ACTION) in
            
        }
        alert.addAction(library)
        alert.addAction(photo)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    func showLibrary()  {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    func checkAccessCamera()  {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.showCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (newStatus) in
                if newStatus {
                    DispatchQueue.main.async(execute: {
                        self.showCamera()
                    });
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        let alert = UIAlertController(title: "Cho phép truy cập camera của bạn!", message: "", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Cài đặt", style: .default) { (ACTION) in
                            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                        }
                        let cancel = UIAlertAction(title: "Hủy", style: .destructive) { (ACTION) in
                            self.view.showToast(message: "Bạn chưa cho phép truy cập camera!")
                        }
                        alert.addAction(ok)
                        alert.addAction(cancel)
                        self.present(alert, animated: true)
                    });
                }
            }
        }
    }
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
//        let idmPhoto = IDMPhotoBrowser.init(photos: arrImg.map{$0.thumb ?? ""})
        let idmPhoto = IDMPhotoBrowser(photos: arrIdmImg as [Any])
        idmPhoto?.setInitialPageIndex(UInt(index))
        idmPhoto?.displayToolbar = false
        self.present(idmPhoto ?? UIViewController(), animated: true, completion: nil)
    }
    func pickIMG(){
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        config.library.defaultMultipleSelection = true
        config.showsPhotoFilters = false
        config.library.skipSelectionsGallery = true
        config.startOnScreen = YPPickerScreen.library
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items
            {
                switch item {
                case .photo(let photo):
                    let imgObj = ImageObj()
                    imgObj.image = photo.image
                    self.imgRealWork.insert(imgObj, at: 0)
                case .video(let v):
                    return
                }
            }
            self.clImage.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

}
extension TaEditProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ReportIMGCellDelete{
    func removeImg(indexImg: Int?) {
        if indexImg != nil && (indexImg ?? 0) < imgRealWork.count
        {
            imgRealWork.remove(at: indexImg ?? 0)
            clImage.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return profile?.images?.count ?? 0  + 1
        return imgRealWork.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaGiayToTuyThanCollectionViewCell", for: indexPath) as! TaGiayToTuyThanCollectionViewCell
        if indexPath.row == 0{ //imgRealWork.count
            cell.imgGiayTo.image = UIImage.init(named: "ic_add_cl")
            cell.btnDelete.isHidden = true
//            cell.imgGiayTo.layer.cornerRadius = 0
//            cell.imgGiayTo.layer.borderWidth = 0
        }
        else
        {
            cell.setup(img: imgRealWork[indexPath.row - 1],indexCell: indexPath.row - 1,isHidden: false)
            cell.delegate = self
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 123
        var width:CGFloat = 132
//        height = self.clImage.frame.height
//        width = height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //indexPath.row
        if indexPath.row == 0 {
//            self.choiseImg()
            pickIMG()
           
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! TaGiayToTuyThanCollectionViewCell
//            if indexPath.row > 0 { // nút add ảnh ở cuối cùng indexPath.row < imgRealWork.count
                if let img =  cell.imgGiayTo.image
                {
                    self.showFullListImg(arrImg: imgRealWork, index: indexPath.row)
                }
            }
//        }
    }
}
extension TaEditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let imgObj = ImageObj()
            imgObj.image = pickedImage.fixedOrientation()
//            imgRealWork.append(imgObj)
//            clImage.scrollToItem(at: IndexPath.init(row: imgRealWork.count - 1, section: 0), at: .centeredHorizontally, animated: true)
            imgRealWork.insert(imgObj, at: 0)
            clImage.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension TaEditProfileViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone{
            //đang nhập thêm chữ thứ 10
            if textField.text?.count == 9 && string != ""{
            }
            if textField.text?.count == 10 && string != ""{
                return false
            }
            if textField.text?.count == 10 && string == ""{
            }
            return true
        }
        return true
    }
}
