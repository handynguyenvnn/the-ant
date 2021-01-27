//
//  TaClPostJobCollectionViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TaClPostJobCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgPostJob: UIImageView!
    var imageSelected:UIImage?
    let imagePicker = UIImagePickerController()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setup(img:UIImage) {
        imgPostJob.image = img
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
