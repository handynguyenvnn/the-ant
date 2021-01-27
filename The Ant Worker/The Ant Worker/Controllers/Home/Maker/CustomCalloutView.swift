//
//  WHCustomCalloutView.swift
//  whh
//
//  Created by Dao Minh Nha on 12/20/16.
//  Copyright © 2016 Hoang Mai Long. All rights reserved.
//

import UIKit
protocol TapStoreMakerDelegate {
    func didJobDetail(obj:TAJobObj?)
}
class CustomCalloutView: UIView {
    @IBOutlet weak var lbSoLuong: UILabel!
    @IBOutlet weak var image_Post: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTimeOpen: UILabel!
    var currentStore:TAJobObj?
    var delegate:TapStoreMakerDelegate?
    let height_default:CGFloat = 79
    let lb_height_default:CGFloat = 18
    
    override func awakeFromNib() {
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.blue.cgColor
//        self.layer.cornerRadius = 5.0
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(CustomCalloutView.actionTap))
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
        image_Post.isUserInteractionEnabled = true
        image_Post.layer.cornerRadius = 2.0
//        image_Post.layer.shadowColor = UIColor.black.cgColor
//        image_Post.layer.shadowOpacity = 0.5
//        image_Post.layer.shadowOffset = CGSize.zero
//        image_Post.layer.shadowRadius = 5
//        image_Post.layer.borderWidth = 0.3
//        image_Post.layer.borderColor = UIColor.lightGray.cgColor
        self.UCDropShadowButton()
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOpacity = 0.7
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 6
        
    }
    func fillData(obj:TAJobObj?){
        currentStore = obj
        lbName.text = obj?.name
        var shift = ""
        obj?.timeWork?.forEach({ (time) in
            shift += ""
            if shift == ""
            {
                shift += "\(time.startTime ?? "") - \(time.endTime ?? "")"
            }
            else
            {
                shift += " \n\(time.startTime ?? "") - \(time.endTime ?? "")"
            }
        })
        image_Post.sd_setImage(with: URL.init(string: obj?.user?.avatar ?? ""), placeholderImage: nil,options: .refreshCached, completed: nil)
        let lbHieght = Utilitys.heightForView(text: shift, width: lbTimeOpen.frame.width, font: UIFont.init(name: "Muli-Regular", size: 14)!) > lb_height_default ? Utilitys.heightForView(text: shift, width: lbTimeOpen.frame.width, font: UIFont.init(name: "Muli-Regular", size: 14)!) : lb_height_default
        if lbHieght >= lb_height_default{
            self.frame.size.height = height_default + (lbHieght - lb_height_default)
        }
        else{
            self.frame.size.width = height_default
        }
        lbTimeOpen.text = shift
        lbSoLuong.text = "\(obj?.personBid ?? 0)/\(obj?.person ?? 1)"
        lbPrice.text = obj?.price ?? ""
    }
    @objc func actionTap(){
        print("tap image")
        if delegate != nil{
            delegate?.didJobDetail(obj: self.currentStore)
        }
//        ManagerNotifications.postNotificationName(ManagerNotifications.NotificationStringName.TAP_IMAGE, object: self)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        let sizeArrow = 5.0
        
        let X0 = rect.origin.x + 1
        let X1 = rect.origin.x + rect.size.width - 1
        let Y0 = rect.origin.y
        let Y1 = rect.origin.y + rect.size.height 

        let kEmbedFix = CGFloat(3.0)
        let  arrowXM = frame.size.width / 2
        let  arrowX0 = arrowXM - CGFloat(sizeArrow * 2)
        let  arrowX1 = arrowXM + CGFloat(sizeArrow * 2)
        let  arrowY0 = Y1 - CGFloat(sizeArrow) - kEmbedFix
        let  arrowY1 = Y1
        let corner:CGFloat = 5
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: arrowX0, y: arrowY0))
        arrowPath.addLine(to: CGPoint(x: arrowXM, y: arrowY1))
        arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY0))
        // render body
        arrowPath.addLine(to: CGPoint(x: X1 - corner, y: arrowY0))
        arrowPath.addArc(withCenter: CGPoint(x: CGFloat(X1 - corner), y: CGFloat(arrowY0 - corner)), radius: corner, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: false)
        //
        arrowPath.addLine(to: CGPoint(x: X1 , y: Y0 + corner))
        arrowPath.addArc(withCenter: CGPoint(x: CGFloat(X1 - corner), y: CGFloat(Y0 + corner)), radius: corner, startAngle: 0, endAngle: (-(CGFloat)(M_PI_2)), clockwise: false)
        //
        arrowPath.addLine(to: CGPoint(x: X0 + corner, y: Y0 ))//[X0 + corner, Y0]
        arrowPath.addArc(withCenter: CGPoint(x: CGFloat(X0 + corner), y: CGFloat(Y0 + corner)), radius: corner, startAngle: (-(CGFloat)(M_PI_2)), endAngle: .pi, clockwise: false)
        //
        arrowPath.addLine(to: CGPoint(x: X0 , y: arrowY0 - corner ))
        arrowPath.addArc(withCenter: CGPoint(x: CGFloat(X0 + corner), y: CGFloat(arrowY0 - corner)), radius: corner, startAngle: .pi, endAngle: CGFloat(M_PI_2), clockwise: false)
        
        arrowPath.addLine(to: CGPoint(x: arrowX0 , y: arrowY0 ))
        
        UIColor.white.setFill()
        arrowPath.fill()
        UIColor.lightGray.setStroke()
        arrowPath.stroke()
    }


    @IBAction func onInfo(_ sender: AnyObject) {
//        if delegate != nil{
//            delegate?.didTapStore(obj: self.currentStore)
//        }
//        ManagerNotifications.postNotificationName(ManagerNotifications.NotificationStringName.INFO, object: imageObj)
        //ALERT
    }
    
}
