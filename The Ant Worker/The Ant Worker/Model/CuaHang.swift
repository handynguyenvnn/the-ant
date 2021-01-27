//
//  CuaHang.swift
//  Food
//
//  Created by Tùng Nguyễn on 5/12/17.
//  Copyright © 2017 SUSOFT. All rights reserved.
//

import Foundation
class CuaHang: NSObject{
    var ownerId: String?
    var objectId: String?
    var diachi: String?
    //var images: [Images]?  //note
//    var liked: [BackendlessUser]?
    var chitiet: String?
    //var location: GeoPoint?
    //var mon_an: [MonAn]?
    var phone: String?
    //var reviews: [Review]?
    var ten: String?
    var rate: NSNumber?
    var thoigian: String?
//    func addToLike(backendlessUser:BackendlessUser) -> Void {
//        if (self.liked == nil) {
//            self.liked = [BackendlessUser]()
//        }
//        if self.checkUserIsLike(beckendlessUser: backendlessUser) {
//            self.liked?.append(backendlessUser)
//        }
//        
//    }
//    func removeLike(backendlessUser:BackendlessUser) -> Void {
//        if (self.liked == nil) {
//            return
//        }
//        if (self.liked?.count)! > 0 {
//           let index = self.getIndexLikeOfUser(beckendlessUser: backendlessUser)
//            if index < (self.liked?.count)! {
//                self.liked?.remove(at: index)
//            }
//        }
//    }
//    func checkUserIsLike(beckendlessUser:BackendlessUser) -> Bool
//    {
//        if self.liked != nil && (self.liked?.count)! > 0
//        {
//            var check:Bool = false
//            for user in (self.liked)! {
//                if AppDelegate.sharedInstance.backendless?.userService.currentUser.objectId == (user as BackendlessUser).objectId {
//                    check = true
//                    break
//                }
//            }
//            return check
//        }
//        else
//        {
//            return false
//        }
//    }
//    func getIndexLikeOfUser(beckendlessUser:BackendlessUser) -> NSInteger
//    {
//        var index = NSNotFound
//        if self.liked != nil && (self.liked?.count)! > 0
//        {
//            var check:Bool = false
//            var i:NSInteger = 0
//            for user in (self.liked)! {
//                if AppDelegate.sharedInstance.backendless?.userService.currentUser.objectId == (user as BackendlessUser).objectId {
//                    index = i
//                    break
//                }
//                i += 1
//            }
//        }
//        return index
//    }
}
