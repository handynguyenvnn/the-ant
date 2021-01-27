//
//  TAMainTabBarViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAMainTabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        AppDelegate.sharedInstance.mainNavigation = self.navigationController
        AppDelegate.sharedInstance.mainTabbar = self
        // Do any additional setup after loading the view.
    }
    func call(phoneNumber:String){
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if DataCenter.sharedInstance.currentUser?.status == 0{
            if !((viewController as? UINavigationController)?.viewControllers.first?.isKind(of: TAProfileViewController.self) ?? false){
                let alert = UIAlertController(title: "Thông báo", message: "Tài khoản của bạn chưa được kích hoạt nên không thể sử dụng chức năng này, vui lòng liên hệ với The Ant.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Đóng", style: .cancel, handler: { (action) in
                    
                }))
                alert.addAction(UIAlertAction.init(title: "Liên hệ", style: .default, handler: { (action) in
                    self.call(phoneNumber: DataCenter.sharedInstance.currentUser?.hotline ?? "")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            return ((viewController as? UINavigationController)?.viewControllers.first?.isKind(of: TAProfileViewController.self) ?? false)
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
