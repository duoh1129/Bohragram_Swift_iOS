//
//  PostWithOneImageCollectionCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/11/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.

//


import UIKit
import ActiveLabel
import Async
import PixelPhotoSDK

class PostWithOneImageCollectionCell: UICollectionViewCell,EditPostDelegate {

    
    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var captionLabel: ActiveLabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var showAllCommentsBtn: UIButton!
    

    
    var post_id: Int? = nil
    var user_id: Int? = nil
    var url: String? = nil
    var index: Int? = nil
    
    var vc : ProfileVC?
    var homePostModel:FetchPostModel.UserPost?
    var showPostModel:ShowPostModel?
    var post_vc:ShowPostVC?
    var hashTagVC:FetchHashTagPostVC?
    var hastagModel:PostByHashTagModel.Datum?
    var delegate: DeletePostDelegate!
    var userProVC : ShowUserProfileVC?

    override  func awakeFromNib() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        self.imageView1.addGestureRecognizer(doubleTap)
        self.imageView1.isUserInteractionEnabled = true
        self.showAllCommentsBtn.setTitle(NSLocalizedString("Show all comments", comment: "Show all comments"), for: .normal)
    }
    
    @IBAction func DoubleTap(gesture: UIGestureRecognizer){
        print("Double Tab")
        if (self.vc != nil){
            if (self.homePostModel?.isLiked == false){
                self.likeDisLike()
            }
        }
        else if (self.userProVC != nil){
            if (self.homePostModel?.isLiked == false){
                self.likeDisLike()
            }
        }
    }
    
    
    func bind(object: FetchPostModel.UserPost, index:Int){
        self.homePostModel  = object
        self.post_id = object.postID ?? 0
        self.user_id = object.userID ?? 0
        self.index = index
        let image1 = object.mediaSet?[0].file ?? ""
        let url = URL(string: image1)
        self.imageView1.sd_setImage(with: url, completed: nil)
        self.captionLabel.text = object.userPostDescription ?? ""
        self.captionLabel.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        self.captionLabel.handleMentionTap { mention in
            print("Success. You just tapped the \(mention) mentioned")
        }
        let profile = object.avatar
        let pro_url = URL(string: profile ?? "")
        self.profileImage.sd_setImage(with: pro_url, completed: nil)
        self.userNameLabel.text = object.username ?? ""
        self.timeLabel.text = object.timeText ?? ""
        self.commentBtn.setTitle("\("  ")\(object.votes ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
        if object.isLiked == true{
            self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
            self.likesCountBtn.setTitle("\(object.likes ?? 0)", for: .normal)
        }
        else{
            self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
            self.likesCountBtn.setTitle("\(object.likes ?? 0)", for: .normal)
        }
        if (object.isSaved == true){
            self.favouriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
        }
        else{
            self.favouriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
        }
        if (object.comments?.isEmpty == true){
            self.showAllCommentsBtn.isHidden = true
        }
        else{
            self.showAllCommentsBtn.isHidden = false
        }
    }
    
    
    private func likeDisLike(){
        let accessToken = AppInstance.instance.accessToken ?? ""
        let postId = homePostModel?.postID ?? 0
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                LikeManager.instance.addAndRemoveLike(accessToken: accessToken, postId: self.post_id ?? 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            if success?.isLiked ?? 0 == 1 {
                                let likes = (self.homePostModel?.likes ?? 0 )
                                let add_likes  = likes + 1
                                self.homePostModel?.likes = add_likes
                                self.likesCountBtn.setTitle("\(add_likes)", for: .normal)
                                self.likeBtn.setImage(UIImage(named: "Heart"), for: UIControl.State.normal)
                                self.homePostModel?.isLiked = true
                            }else{
                                let likes = (self.homePostModel?.likes ?? 0)
                                let sub_likes = likes - 1
                                self.homePostModel?.likes = sub_likes
                                self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                self.likeBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
                                self.homePostModel?.isLiked = false
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                        })
                    }
                })
            })
        }
        else{
            log.error("internetError = \(InterNetError)")
            if (self.vc != nil){
                self.vc?.view.makeToast(InterNetError)
            }
            else if (self.userProVC != nil){
                self.userProVC?.view.makeToast(InterNetError)
            }
        }
    }
    
    
    private func favoriteUnFavorite(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = self.post_id
            
            Async.background({
                FavoriteManager.instance.addAndRemoveFavorite(accessToken: accessToken, postId: self.post_id ?? 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            
                            if success?.type ?? 0 == 1 {
                                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            if (self.vc != nil){
                                self.vc?.view.makeToast(sessionError?.errors?.errorText)
                            }
                            else if (self.userProVC != nil){
                                self.userProVC?.view.makeToast(sessionError?.errors?.errorText)
                            }
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        })
                        
                    }else {
                        Async.main({
                            if (self.vc != nil){
                                self.vc?.view.makeToast(error?.localizedDescription)
                            }
                            else if (self.userProVC != nil){
                                self.userProVC?.view.makeToast(error?.localizedDescription)
                            }
                            log.error("error = \(error?.localizedDescription ?? "")")
                        })
                    }
                })
            })
        }
        else{
            log.error("internetError = \(InterNetError)")
            if (self.vc != nil){
                self.vc?.view.makeToast(InterNetError)
            }
            else if (self.userProVC != nil){
                self.userProVC?.view.makeToast(InterNetError)
            }
            
        }
    }
    
    
    private func reportPost(){
        let accessToken = AppInstance.instance.accessToken ?? ""
        let postId = homePostModel?.postID ?? 0
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                ReportManager.instance.reportPost(accessToken: accessToken, postId: self.post_id ?? 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            if (self.vc != nil){
                                self.vc?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))
                            }
                            else if (self.userProVC != nil){
                                self.userProVC?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                        })
                    }
                })
            })
        }
        else{
            log.error("internetError = \(InterNetError)")
            if (self.vc != nil){
                self.vc?.view.makeToast(InterNetError)
            }
            else if (self.userProVC != nil){
                self.userProVC?.view.makeToast(InterNetError)
            }
        }
    }
    
    
    private func deletePost(){
        let accessToken = AppInstance.instance.accessToken ?? ""
        let postId = homePostModel?.postID ?? 0
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                DeletePostManager.instance.deletePost(accessToken: accessToken, postId: self.post_id ?? 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.delegate.postDelete(index: self.index ?? 0)
                            log.verbose("Success = \(success!)")
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                        })
                    }
                })
            })
        }
    }
    
    
    func showActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Post", comment: "Post"), preferredStyle: .actionSheet)
        if (self.user_id == AppInstance.instance.userId){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Edit Post", comment: "Edit Post"), style: .default, handler: { (_) in
                let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                 let vc = Storyboard.instantiateViewController(withIdentifier: "EditPostVC") as! EditPostController
                 vc.delegate = self
                 vc.post_id = self.post_id ?? 0
                 vc.caption = self.captionLabel.text ?? ""
                if (self.vc != nil){
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                }
                else if (self.userProVC != nil){
                    self.userProVC?.navigationController?.pushViewController(vc, animated: true)
                }
                print("User click Edit button")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Delete Post", comment: "Delete Post"), style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: NSLocalizedString("Delete Post", comment: "Delete Post"), message: NSLocalizedString("Are you sure want to delete this post", comment: "Are you sure want to delete this post"), preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "NO"), style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "YES"),
                                              style: UIAlertAction.Style.destructive,
                                              handler: {(_: UIAlertAction!) in
                                                self.deletePost()
                }))
                if (self.vc != nil){
                       self.vc?.present(alert, animated: true, completion: nil)
                   }
                   else if (self.userProVC != nil){
                       self.userProVC?.present(alert, animated: true, completion: nil)
                   }
                
                print("User click Delete button")
            }))
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go to Post", comment: "Go to Post"), style: .default, handler: { (_) in
            //            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
            //            let vc = Storyboard.instantiateViewController(withIdentifier: "ShowPostsVC") as! ShowPostVC
            //            self.vc?.navigationController?.pushViewController(vc, animated: true)
            if self.vc != nil{
                let item = self.homePostModel
                let userItem = self.homePostModel?.userData
                var mediaSet = [String]()
                if (item?.mediaSet!.count)! > 1{
                    item?.mediaSet?.forEach({ (it) in
                        mediaSet.append(it.file ?? "")
                    })
                }
                log.verbose("MediaSet = \(mediaSet)")
                //                let vc = R.storyboard.post.showPostVC()
                let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                let vc = Storyboard.instantiateViewController(withIdentifier: "ShowPostsVC") as! ShowPostVC
                let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.posts, isFollowing: userItem?.following, userId: userItem?.userID,imageString: userItem?.avatar,timeText: item?.timeText,isAdmin: userItem?.admin)
                let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.userPostDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
                vc.object = object
                self.vc?.navigationController?.pushViewController(vc, animated: true)
            }
            else if self.hashTagVC != nil{
                let item = self.hastagModel
                let userItem = self.hastagModel?.userData
                var mediaSet = [String]()
                if (item?.mediaSet!.count)! > 1{
                    item?.mediaSet?.forEach({ (it) in
                        mediaSet.append(it.file ?? "")
                    })
                }
                log.verbose("MediaSet = \(mediaSet)")
                let vc = R.storyboard.post.showPostsVC()
                let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.posts, isFollowing: userItem?.following, userId: userItem?.userID,imageString: userItem?.avatar,timeText: item?.timeText,isAdmin: userItem?.admin)
                let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.datumDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
                vc!.object = object
                
                self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Report this Post", comment: "Report this Post"), style: .default, handler: { (_) in
            self.reportPost()
            print("")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default, handler: { (_) in
            UIPasteboard.general.string = self.url ?? ""
            if (self.vc != nil){
                self.vc?.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
            }
            else if (self.userProVC != nil){
                self.userProVC?.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
            }
            print("Copied")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        if (self.vc != nil){
            self.vc?.present(alert, animated: true, completion: {
                print("completion block")
            })
            
        }
        else if (self.userProVC != nil){
            self.userProVC?.present(alert, animated: true, completion: {
                print("completion block")
            })
            
        }
        
        
    }
    
    @IBAction func More(_ sender: Any) {
        if (self.vc != nil){
            self.showActionSheet(controller: self.vc!)
        }
        else if (self.userProVC != nil){
            self.showActionSheet(controller: self.userProVC!)
        }
        
    }
    
    @IBAction func showAllCommentsBtn(_ sender: Any) {
        let vc = R.storyboard.post.commentVC()
        vc?.postId = self.post_id ?? 0
        if (self.vc != nil){
             self.vc?.navigationController?.pushViewController(vc!, animated: true)
         }
         else if (self.userProVC != nil){
             self.userProVC?.navigationController?.pushViewController(vc!, animated: true)
         }
    }
    
    @IBAction func Like(_ sender: Any) {
        self.likeDisLike()
    }
    
    @IBAction func Comment(_ sender: Any) {

            let vc = R.storyboard.post.commentVC()
            vc?.postId = self.post_id ?? 0
            if (self.vc != nil){
                self.vc?.navigationController?.pushViewController(vc!, animated: true)
            }
            else if (self.userProVC != nil){
                self.userProVC?.navigationController?.pushViewController(vc!, animated: true)
            }
    }
    
    @IBAction func Share(_ sender: Any) {
        if (self.vc != nil){
               let image = self.imageView1?.image
               let imageToShare = [ image! ]
               let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.vc!.view
               self.vc!.present(activityViewController, animated: true, completion: nil)
        }
           else if (self.userProVC != nil){
               let image = self.imageView1?.image
               let imageToShare = [ image! ]
               let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.userProVC!.view
               self.userProVC!.present(activityViewController, animated: true, completion: nil)
        }

    }
    
    @IBAction func Favourite(_ sender: Any) {
        self.favoriteUnFavorite()
    }
    
    @IBAction func LikeCount(_ sender: Any) {
        if self.likesCountBtn.titleLabel?.text == "0"{
            if (self.vc != nil){
                self.vc?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
            else if (self.userProVC != nil){
                self.userProVC?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
        }
        else{
            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
            navigationVC.modalPresentationStyle = .fullScreen
            navigationVC.modalTransitionStyle = .coverVertical
            let vc = navigationVC.topViewController as! LikesVC
            vc.postId = self.post_id ?? 0
            if (self.vc != nil){
                 self.vc?.present(navigationVC, animated: true, completion: nil)
             }
             else if (self.userProVC != nil){
                 self.userProVC?.present(navigationVC, animated: true, completion: nil)
             }
        }
    }
    
    func editPost(text: String) {
        self.captionLabel.text = text
    }
    
    
}
