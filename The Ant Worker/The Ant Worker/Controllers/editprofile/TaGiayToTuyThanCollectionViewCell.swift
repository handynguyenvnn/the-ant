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
    @IBOutlet weak var imgClose: UIImageView?
    var index:Int?
    var delegate:ReportIMGCellDelete?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(img:ImageObj,indexCell:Int? = nil, isHidden:Bool = true,isHideDelete:Bool = false) {
        btnDelete.isHidden = isHideDelete
        imgClose?.isHidden = isHideDelete
        index = indexCell
        if img.image != nil{
            imgGiayTo.image = img.image
        }
        else{
            imgGiayTo.sd_setImage(with: URL.init(string: img.thumb ?? ""), placeholderImage: nil, options: .refreshCached,  completed: nil)
            btnDelete.isHidden = isHidden
            
        }
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
