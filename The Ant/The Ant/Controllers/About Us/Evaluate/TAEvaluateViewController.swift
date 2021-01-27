//
//  TAEvaluateViewController.swift
//  The Ant
//
//  Created by Anh Quan on 7/8/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Toaster
import MBProgressHUD
import SDWebImage
protocol RateDelegete {
    func rateSuccess()
}
let DEFAULT_TXT_FEEDBACK = "Đánh giá"
class TAEvaluateViewController: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var ImageAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEvaluate: UILabel!
    @IBOutlet weak var btEvaluate: UIButton!
    @IBOutlet weak var viewStar: HCSStarRatingView!
    @IBOutlet weak var txtDecs: UITextView!
    @IBOutlet weak var viewAll: UIView!
    var currentUserRate:UserWorkers?
    var superView:TaJobDetailViewController?
    var isEvaluate = false
    var delegate:RateDelegete?
    var cates:CateObj?
    var jobObj:TAJobObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStar.addTarget(self, action: #selector(changeRate),for: UIControl.Event.valueChanged)
        txtDecs.text = "Đánh giá"
        txtDecs.delegate = self
        txtDecs.textColor = UIColor.lightGray
        fillData()
        viewStar.minimumValue = CGFloat(MIN_RATE)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAll.layer.cornerRadius = 10.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.viewAll.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 10.0)
//            self.viewAll.clipsToBounds = false
        }
        
    }
    func fillData(){
        lbName.text = currentUserRate?.name ?? ""
        ImageAvatar.sd_setImage(with: URL.init(string: currentUserRate?.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        if currentUserRate?.isRate ?? false{
            viewStar.isUserInteractionEnabled = false
            txtDecs.isEditable = false
            txtDecs.textColor = UIColor.black
            btEvaluate.isHidden = true
            txtDecs.text = currentUserRate?.rateObj?.note
            viewStar.value = CGFloat(currentUserRate?.rateObj?.star ?? 0)
        }
    }
    @IBAction func clickEvaluate(_ sender: Any) {
        self.rate()
    }
    @objc func changeRate()
    {
        let rate = Float(viewStar?.value ?? CGFloat(MIN_RATE))
        
//        if (rate < 2) {
//            lbRateDes?.text = "Tồi tệ"
//            lbRateDes?.textColor = UIColor.init(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1)
//        } else if (rate <= 3) {
//            lbRateDes?.text = "Bình thường"
//            lbRateDes?.textColor =  UIColor.init(red: 254.0/255.0, green: 160.0/255.0, blue: 35.0/255.0, alpha: 1)
//        } else if (rate <= 4) {
//            lbRateDes?.text = "Tuyệt vời"
//            lbRateDes?.textColor = UIColor.init(red: 0/255.0, green: 143.0/255.0, blue: 243.0/255.0, alpha: 1)
//        } else {
//            lbRateDes?.text = "Xuất sắc"
//            lbRateDes?.textColor = UIColor.red
//        }
    }
    func rate(){
        var feedBack = ""
        if txtDecs.text == "Đánh giá"{
            feedBack = ""
        }else{
            feedBack = txtDecs.text
        }
        Services.shareInstance.rateHr(jid: jobObj?.internalIdentifier ?? "", rate: "\(viewStar?.value ?? CGFloat(MIN_RATE))", desc: feedBack, target_user:currentUserRate?.internalIdentifier ?? "" ){(response, message, errorCode) in
                Toast(text: message, delay: 0, duration: 1).show()
                if errorCode == SUCCESS_CODE{
                    if self.superView != nil{
                        self.superView?.getInfoUser()
                    }
                    let rate = RateObj()
                    rate.star = Float((self.viewStar?.value ?? 0) ?? CGFloat(MIN_RATE))
                    rate.note = feedBack
                    self.currentUserRate?.rateObj = rate
                    self.currentUserRate?.isRate = true
                    if self.delegate != nil{
                        self.delegate?.rateSuccess()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Đánh giá"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

