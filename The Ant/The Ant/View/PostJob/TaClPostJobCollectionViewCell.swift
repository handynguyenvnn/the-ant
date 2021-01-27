//
//  TaClPostJobCollectionViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
protocol ReportIMGCellDelegate {
    func deleteIMG(indexImg:Int?)
}
class TaClPostJobCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgPostJob: UIImageView!
    var imageSelected:UIImage?
    let imagePicker = UIImagePickerController()
    ///index ảnh trong mảng ảnh
    var index:Int?
    var delegate:ReportIMGCellDelegate?
    @IBOutlet weak var btnDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setup(img:ImageObj,indexCell:Int? = nil, isHidden:Bool = true) {
        btnDelete.isHidden = false
        if img.image != nil{
            imgPostJob.image = img.image
        }
        else{
            
            imgPostJob.sd_setImage(with: URL.init(string: img.thumb ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached,  completed: nil)
            btnDelete.isHidden = isHidden
            
        }
        
        index = indexCell
    }
    @IBAction func onDelete(_ sender: Any) {
        if delegate != nil
        {
            delegate?.deleteIMG(indexImg: index)
        }
    }

}
//extension TaClPostJobCollectionViewCell : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[.originalImage] as? UIImage {
//            imgPostJob.image = pickedImage
//            imageSelected = pickedImage
//        }
//        
//        dismiss(animated: true, completion: nil)
//    }
//    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
