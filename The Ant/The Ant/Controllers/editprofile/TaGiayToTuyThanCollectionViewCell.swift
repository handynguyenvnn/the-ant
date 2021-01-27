//
//  TaGiayToTuyThanCollectionViewCell.swift
//  The Ant Worker
//
//  Created by Quyet on 8/1/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
protocol ReportIMGCellDelete {
    func removeImg(indexImg:Int?)
}
class TaGiayToTuyThanCollectionViewCell: UICollectionViewCell {
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imgGiayTo: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    var index:Int?
    var delegate:ReportIMGCellDelete?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(img:ImageObj,indexCell:Int? = nil, isHidden:Bool = true) {
        btnDelete.isHidden = false
        if img.image != nil{
            imgGiayTo.image = img.image
        }
        else{
            imgGiayTo.sd_setImage(with: URL.init(string: img.thumb ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached,  completed: nil)
            btnDelete.isHidden = isHidden
        }
        index = indexCell
    }
    @IBAction func onDelete(_ sender: Any) {
        if delegate != nil {
            delegate?.removeImg(indexImg: index)
        }
    }
    //    func fillData(obj:ImageObj){
//        imgGiayTo.sd_setImage(with: URL.init(string: obj.thumb ?? ""), placeholderImage: nil, options: SDWebImageOptions.refreshCached, completed: nil)
//    }

}
