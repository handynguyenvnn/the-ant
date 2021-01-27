//
//  MMNotificationsTableViewCell.swift
//
//
//  Created by "longhm" on 12/18/18.
//  Copyright © 2018 "longhm". All rights reserved.
//

import UIKit
import SDWebImage
let HeightNotiCell:CGFloat = 90
let COLOR_NOTIFICATION_READ = UIColor.init(red: 255/255, green: 248/255, blue: 248/255, alpha: 1)
let COLOR_NOTIFICATION_READ_LINE = UIColor.init(red: 0.23, green: 0.82, blue: 0.62, alpha: 1)
class MMNotificationsTableViewCell: UITableViewCell {
    @IBOutlet weak var lbTitle:UILabel?
    @IBOutlet weak var lbContent:UILabel?
    @IBOutlet weak var viewShadow:UIView?
    @IBOutlet weak var lbTime:UILabel?
    @IBOutlet weak var icIcon:UIImageView?
    @IBOutlet weak var imgLine:UIView?
    @IBOutlet weak var lineBgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewShadow?.layer.cornerRadius = 4
        viewShadow?.clipsToBounds = true
//        viewShadow?.backgroundColor = UIColor.clear

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupData(objData: NotificationObj)
    {
        self.lbTitle?.text = objData.notificaitonTitle ?? " "
        self.lbContent?.text = Utilitys.getDefaultString(originString: objData.notificationContent as AnyObject)
        self.icIcon?.sd_setImage(with: URL.init(string: objData.notificationIcon ?? ""), placeholderImage: UIImage.init(named: "ic_non_image-1"), options: .queryDiskDataSync, completed: nil)
        self.lbTime?.text = Utilitys.getDefaultString(originString: objData.notiticationTime as AnyObject)
        self.imgLine?.backgroundColor = objData.isRead ? UIColor.lightGray:COLOR_NOTIFICATION_READ_LINE
        
        if  !objData.isRead {
            self.viewShadow?.backgroundColor = UIColor.init(hexString: "#FFF8F8")
            self.lbTitle?.font = UIFont.init(name: "Muli-Bold", size: 15)
            self.lineBgView.backgroundColor = UIColor.init(hexString: "#3AD29F")
            self.lineBgView.isHidden = false
        }
        else
        {
            self.viewShadow?.backgroundColor = UIColor.white
            self.lbTitle?.font = UIFont.init(name: "Muli-Regular", size: 15)
            self.lineBgView.isHidden = true
        }
    }
}
