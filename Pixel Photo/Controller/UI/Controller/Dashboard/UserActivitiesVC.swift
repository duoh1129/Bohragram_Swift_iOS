//
//  UserActivitiesVC.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/30/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PixelPhotoSDK
import Async
class UserActivitiesVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    
    public var itemInfo = IndicatorInfo(title: "View")
    private var activitiesArray = [ActivitiesModel.Datum]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchActivities()
    }
    private func setupUI(){
        
        self.contentTblView.register(R.nib.activitiesTableItem(), forCellReuseIdentifier: R.reuseIdentifier.activitiesTableItem.identifier)
        self.showLabel.text = NSLocalizedString("There is no UserData", comment: "")
        
    }
    private func fetchActivities(){
        if Connectivity.isConnectedToNetwork(){
            self.activitiesArray.removeAll()
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userId = AppInstance.instance.userId ?? 0
            
            Async.background({
                ActivitiesManager.instance.fetchUserActivities(accessToken: accessToken, limit: 200, Offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                                self.activitiesArray = success?.data ?? []
                                if self.activitiesArray.isEmpty{
                                    self.showImage.isHidden = false
                                    self.showLabel.isHidden = false
                                    self.contentTblView.reloadData()
                                }else{
                                    self.showImage.isHidden = true
                                    self.showLabel.isHidden = true
                                    self.contentTblView.reloadData()
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
extension UserActivitiesVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.activitiesArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.activitiesTableItem.identifier) as! ActivitiesTableItem
        let object = self.activitiesArray[indexPath.row]
        let value = Double(object.time ?? "0.0")
        var date =    Date(timeIntervalSinceNow: (value! / 1000.0))
        cell.titleLabel.text = object.text ?? ""
        cell.timeAgoLabel.text = timeAgoSinceDate(date)
        if object.type == "liked__post"{
            cell.iconLabel.image = R.image.ic_like()
        }else{
            cell.iconLabel.image = R.image.ic_alert()
            
        }
        let url = URL.init(string:object.userData?.avatar ?? "")
        cell.thumbnailImage.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let object = self.activitiesArray[indexPath.row]
        if object.followingData?.stringValue == ""{
            let userItem = object.postData?.postDataClassValue
                   var mediaSet = [String]()
                   if (userItem?.mediaSet!.count)! > 1{
                       userItem?.mediaSet?.forEach({ (it) in
                           mediaSet.append(it.file ?? "")
                       })
                   }
                   log.verbose("MediaSet = \(mediaSet)")
            let vc = R.storyboard.post.showPostsVC()
            let objectToSend = ShowUserProfileData(fname: userItem?.userData?.fname, lname: userItem?.userData?.lname, username: userItem?.userData?.username, aboutMe: userItem?.userData?.about, followersCount: 0, followingCount: 0, postCount: userItem?.userData?.postsCount, isFollowing: false, userId: userItem?.userData?.userID,imageString: userItem?.userData?.avatar,timeText: userItem?.timeText,isAdmin: userItem?.userData?.admin)
            let object = ShowPostModel(userId: userItem?.userID, imageString: userItem?.avatar, username: userItem?.username, type: userItem?.type, timeText: userItem?.timeText, MediaURL: userItem?.mediaSet![0].file, likesCount: userItem?.likes, commentCount: userItem?.comments?.count, isLiked: userItem?.isLiked, isSaved: userItem?.isSaved, showUserProfile: objectToSend,mediaCount:userItem?.mediaSet?.count,postId: userItem?.postID,description: userItem?.postDataDescription,youtube: userItem?.youtube,MediaUrlsArray:mediaSet)
                   vc!.object = object
                   
                   self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = R.storyboard.post.showUserProfileVC()
                 let object = self.activitiesArray[indexPath.row]
            let objectToSend = ShowUserProfileData(fname: object.followingData?.userDataClassValue?.fname, lname: object.followingData?.userDataClassValue?.lname, username: object.followingData?.userDataClassValue?.username, aboutMe: object.followingData?.userDataClassValue?.about, followersCount: object.followingData?.userDataClassValue?.followers, followingCount: object.followingData?.userDataClassValue?.following, postCount: object.followingData?.userDataClassValue?.posts, isFollowing: false, userId: object.followingData?.userDataClassValue?.userID,imageString: object.followingData?.userDataClassValue?.avatar,timeText: "",isAdmin: object.followingData?.userDataClassValue?.admin)
                  vc!.object = objectToSend
                  self.navigationController?.pushViewController(vc!, animated: true)
        }
       
       
    }
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}

extension UserActivitiesVC:IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
