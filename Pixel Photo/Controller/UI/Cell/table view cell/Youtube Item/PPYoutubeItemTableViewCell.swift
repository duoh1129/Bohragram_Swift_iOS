//
//  PPYoutubeItemTableViewCell.swift
//  Pixel Photo
//
//  Created by DoughouzLight on 07/01/2019.
//  Copyright © 2019 DoughouzLight. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage
import RxGesture
import RxCocoa
import RxSwift
import ActionSheetPicker_3_0
import ActiveLabel
import Async
import PixelPhotoSDK
import YouTubePlayer


class PPYoutubeItemTableViewCell: UITableViewCell,EditPostDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var captionLbl: ActiveLabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var thumbNailImgView: UIImageView!
    //    @IBOutlet weak var contentWebView: WKWebView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var numLikeLbl: UILabel!
    @IBOutlet weak var numCommentLbl: UILabel!
    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!
    
    private var aspectConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var showAllCommentLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var addCommentBtn: UIButton!
    @IBOutlet weak var likedBtn: UIButton!
    
    @IBOutlet weak var showAllCommentBtn: UIButton!
    
    @IBOutlet weak var commentsBtn: UIButton!
    
    @IBOutlet weak var allCommentViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var showCallCommentsTopConstraints: NSLayoutConstraint!
    
    var loaded = false
    var disposeBag = DisposeBag()
    var showPostModel:ShowPostModel?
    var vc:ShowPostVC?
    var homePostModel:HomePostModel.Datum?
    var homeVC:HomeVC?
    var hashTagVC:FetchHashTagPostVC?
    var hastagModel:PostByHashTagModel.Datum?
    
    var delegate: DeletePostDelegate!
    
    var post_id: Int? = nil
    var user_id: Int? = nil
    var url: String? = nil
    var index: Int? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        self.profileImageView.addGestureRecognizer(gesture)
        self.profileNameLbl.addGestureRecognizer(gestureonLabel)
        self.profileImageView.isUserInteractionEnabled = true
        self.profileNameLbl.isUserInteractionEnabled = true
        self.videoPlayer.playerVars   = ["playsinline" : 1 as AnyObject]
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        let doubleTap1 = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        let doubleTap2 = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        doubleTap1.numberOfTouchesRequired = 1
        doubleTap1.numberOfTapsRequired = 2
        doubleTap2.numberOfTouchesRequired = 1
        doubleTap2.numberOfTapsRequired = 2
        self.view1.addGestureRecognizer(doubleTap2)
        self.topView.addGestureRecognizer(doubleTap)
        self.roundView.addGestureRecognizer(doubleTap1)
        self.topView.isUserInteractionEnabled = true
        self.roundView.isUserInteractionEnabled = true
        self.view1.isUserInteractionEnabled = true
        self.showAllCommentBtn.setTitle(NSLocalizedString("Show all comments", comment: "Show all comments"), for: .normal)
        
    }
    
    
    @IBAction func DoubleTap(gesture: UIGestureRecognizer){
        print("Double Tab")
        if (self.vc != nil){
            if (self.showPostModel?.isLiked == false){
                self.likeDisLike()
            }
        }
        else if (self.homeVC != nil){
            if (self.homePostModel?.isLiked == false){
                self.likeDisLike()
            }
            else if (self.hashTagVC != nil){
                if (self.homePostModel?.isLiked == false){
                    self.likeDisLike()
                }
            }
        }
    }
    
    @IBAction func gotoUserProfile(gesture: UIGestureRecognizer){
        if self.vc != nil{
                   let item = self.showPostModel
                   let object = self.showPostModel?.showUserProfile
                   if (object?.userId == AppInstance.instance.userId){
                       print("Nothing")
                       self.vc?.tabBarController?.selectedIndex = 4
                   }
                   else{
                   let vc = R.storyboard.post.showUserProfileVC()
                   vc?.privacy = ""
                   vc?.gender = ""
                   vc?.descriptionString = object?.aboutMe ?? ""
                   vc?.email =  ""
                   vc?.businessAccount =  0
                   let objectToSend = ShowUserProfileData(fname: object?.fname, lname: object?.lname, username: object?.username, aboutMe: object?.aboutMe, followersCount: 0, followingCount: 0, postCount: object?.postCount, isFollowing: false, userId: object?.userId,imageString: object?.imageString,timeText: "" ,isAdmin: object?.isAdmin)
                   vc?.object = objectToSend
                   self.vc?.navigationController?.pushViewController(vc!, animated: true)
                   }
               }
        else if (self.hashTagVC != nil){
            let item = self.hastagModel
            let object = self.hastagModel?.userData
            if (object?.userID == AppInstance.instance.userId){
                print("Nothing")
                self.vc?.tabBarController?.selectedIndex = 4
            }
            else{
                let vc = R.storyboard.post.showUserProfileVC()
                vc?.privacy = object?.pPrivacy ?? ""
                vc?.gender = object?.gender ?? ""
                vc?.descriptionString = object?.about ?? ""
                vc?.email = object?.email ?? ""
                vc?.businessAccount = object?.businessAccount ?? 0
                let objectToSend = ShowUserProfileData(fname: object?.fname, lname: object?.lname, username: object?.username, aboutMe: object?.about, followersCount: 0, followingCount: 0, postCount: object?.postsCount, isFollowing: false, userId: object?.userID,imageString: object?.avatar,timeText: "" ,isAdmin: object?.admin)
                vc?.object = objectToSend
                self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
    }
    
    //
    //    @objc func showAllCommentsTapped(tapGestureRecognizer: UITapGestureRecognizer)
    //    {
    //        if self.vc != nil{
    //            let vc = R.storyboard.post.commentVC()
    //            vc?.postId = showPostModel?.postId ?? 0
    //            self.vc?.navigationController?.pushViewController(vc!, animated: true)
    //        }else if  self.homeVC != nil{
    //            let vc = R.storyboard.post.commentVC()
    //            vc?.postId = homePostModel?.postID ?? 0
    //            self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
    //        } else if  self.hashTagVC != nil{
    //            let vc = R.storyboard.post.commentVC()
    //            vc?.postId = hastagModel?.postID ?? 0
    //            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
    //        }
    //    }
    //    @objc func numCommentsTapped(tapGestureRecognizer: UITapGestureRecognizer)
    //    {
    //        if self.vc != nil{
    //            let vc = R.storyboard.post.commentVC()
    //            vc?.postId = showPostModel?.postId ?? 0
    //            self.vc?.navigationController?.pushViewController(vc!, animated: true)
    //        }else if  self.homeVC != nil{
    //            let vc = R.storyboard.post.commentVC()
    //            vc?.postId = homePostModel?.postID ?? 0
    //            self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
    //        }else if  self.hashTagVC != nil{
    //            let vc = R.storyboard.post.commentVC()
    //            vc?.postId = hastagModel?.postID ?? 0
    //            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
    //        }
    //
    //
    //    }
    //    @objc func numLikesTapped(tapGestureRecognizer: UITapGestureRecognizer)
    //    {
    //
    //        if self.vc != nil{
    //            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
    //            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
    //            navigationVC.modalPresentationStyle = .fullScreen
    //            navigationVC.modalTransitionStyle = .coverVertical
    //            let vc = navigationVC.topViewController as! LikesVC
    //            vc.postId = showPostModel?.postId ?? 0
    //            //            vc.postId = self.post_id ?? 0
    //            self.vc?.present(navigationVC, animated: true, completion: nil)
    //        }else if  self.homeVC != nil{
    //            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
    //            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
    //            navigationVC.modalPresentationStyle = .fullScreen
    //            navigationVC.modalTransitionStyle = .coverVertical
    //            let vc = navigationVC.topViewController as! LikesVC
    //            vc.postId = homePostModel?.postID ?? 0
    //            self.vc?.present(navigationVC, animated: true, completion: nil)
    //        }else if  self.hashTagVC != nil{
    //            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
    //            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
    //            navigationVC.modalPresentationStyle = .fullScreen
    //            navigationVC.modalTransitionStyle = .coverVertical
    //            let vc = navigationVC.topViewController as! LikesVC
    //            vc.postId = hastagModel?.postID ?? 0
    //            self.vc?.present(navigationVC, animated: true, completion: nil)
    //
    //        }
    //
    //    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("PPYoutubeItemTableViewCell prepareForReuse")
        
        self.disposeBag = DisposeBag()
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        if self.vc != nil{
    //            if showPostModel?.description == "" {
    //                self.captionLbl.isHidden = true
    //                self.allCommentViewTopConstraints.isActive = true
    //                self.showCallCommentsTopConstraints.isActive = false
    //            }else{
    //                self.captionLbl.isHidden = false
    //                self.allCommentViewTopConstraints.isActive = false
    //                self.showCallCommentsTopConstraints.isActive = true
    //                self.captionLbl.text = self.showPostModel?.description?.decodeHtmlEntities()?.arrangeMentionedContacts() ?? ""
    //            }
    //        }else if self.homeVC != nil{
    //            if homePostModel?.datumDescription == "" {
    //                self.captionLbl.isHidden = true
    //                self.allCommentViewTopConstraints.isActive = true
    //                self.showCallCommentsTopConstraints.isActive = false
    //            }else{
    //                self.captionLbl.isHidden = false
    //                self.allCommentViewTopConstraints.isActive = false
    //                self.showCallCommentsTopConstraints.isActive = true
    //                self.captionLbl.text = self.homePostModel?.datumDescription!.decodeHtmlEntities()?.arrangeMentionedContacts()
    //            }
    //        }else if self.hashTagVC != nil{
    //            if hastagModel?.datumDescription == "" {
    //                self.captionLbl.isHidden = true
    //                self.allCommentViewTopConstraints.isActive = true
    //                self.showCallCommentsTopConstraints.isActive = false
    //            }else{
    //                self.captionLbl.isHidden = false
    //                self.allCommentViewTopConstraints.isActive = false
    //                self.showCallCommentsTopConstraints.isActive = true
    //                self.captionLbl.text = self.hastagModel?.datumDescription!.decodeHtmlEntities()?.arrangeMentionedContacts()
    //            }
    //        }
    //    }
    
    
    @IBAction func commentPressed(_ sender: Any) {
        if self.vc != nil{
            let vc = R.storyboard.post.commentVC()
            vc?.postId = showPostModel?.postId ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else if self.homeVC != nil{
            let vc = R.storyboard.post.commentVC()
            vc?.postId = homePostModel?.postID ?? 0
            self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
        }else if self.hashTagVC != nil{
            let vc = R.storyboard.post.commentVC()
            vc?.postId = hastagModel?.postID ?? 0
            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    @IBAction func likePressed(_ sender: Any) {
        likeDisLike()
    }
    private func deletePost(){
        if self.vc != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = showPostModel?.postId ?? 0
            
            Async.background({
                DeletePostManager.instance.deletePost(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.vc?.navigationController?.popViewController(animated: true)
                            
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
        }else if self.homeVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = homePostModel?.postID ?? 0
            
            Async.background({
                DeletePostManager.instance.deletePost(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.homeVC?.navigationController?.popViewController(animated: true)
                            
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
        }else if self.hashTagVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = hastagModel?.postID ?? 0
            
            Async.background({
                DeletePostManager.instance.deletePost(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.hashTagVC?.navigationController?.popViewController(animated: true)
                            
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
    
    private func reportPost(){
        if  self.vc != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = self.showPostModel?.postId ?? 0
            
            Async.background({
                ReportManager.instance.reportPost(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            
                            self.vc?.view.makeToast(success?.message ?? "" )

                            
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
        }else if self.homeVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = homePostModel?.postID ?? 0
            
            Async.background({
                ReportManager.instance.reportPost(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            self.homeVC?.view.makeToast(success?.message ?? "" )
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
        }else if self.hashTagVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = hastagModel?.postID ?? 0
            
            Async.background({
                ReportManager.instance.reportPost(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            self.homeVC?.view.makeToast(success?.message ?? "" )
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
    
    private func likeDisLike(){
        if self.vc != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = showPostModel?.postId ?? 0
            
            Async.background({
                
                LikeManager.instance.addAndRemoveLike(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            if success?.isLiked ?? 0 == 1 {
                                let likes = (self.showPostModel?.likesCount ?? 0 )
                                let add_likes  = likes + 1
                                self.showPostModel?.likesCount = add_likes
                                self.likesCountBtn.setTitle("\(add_likes)", for: .normal)
                                self.likedBtn.setImage(UIImage(named: "Heart"), for: UIControl.State.normal)
                                self.showPostModel?.isLiked = true
                            }else{
                                let likes = (self.showPostModel?.likesCount ?? 0)
                                let sub_likes = likes - 1
                                self.showPostModel?.likesCount = sub_likes
                                self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                self.likedBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
                                self.showPostModel?.isLiked = false
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
        }else if self.homeVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = homePostModel?.postID ?? 0
            
            Async.background({
                
                LikeManager.instance.addAndRemoveLike(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            if success?.isLiked ?? 0 == 1 {
                                let likes = (self.homePostModel?.likes ?? 0 )
                                let add_likes  = likes + 1
                                self.homePostModel?.likes = add_likes
                                self.likesCountBtn.setTitle("\(add_likes)", for: .normal)
                                self.likedBtn.setImage(UIImage(named: "Heart"), for: UIControl.State.normal)
                                self.homePostModel?.isLiked = true
                            }else{
                                let likes = (self.homePostModel?.likes ?? 0)
                                let sub_likes = likes - 1
                                self.homePostModel?.likes = sub_likes
                                self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                self.likedBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
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
        }else if self.hashTagVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = hastagModel?.postID ?? 0
            
            Async.background({
                
                LikeManager.instance.addAndRemoveLike(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            
                            if success?.isLiked ?? 0 == 1 {
                                let likes = (self.hastagModel?.likes ?? 0 )
                                let add_likes  = likes + 1
                                self.hastagModel?.likes = add_likes
                                self.likesCountBtn.setTitle("\(add_likes)", for: .normal)
                                self.likedBtn.setImage(UIImage(named: "Heart"), for: UIControl.State.normal)
                                self.hastagModel?.isLiked = true
                            }else{
                                let likes = (self.hastagModel?.likes ?? 0)
                                let sub_likes = likes - 1
                                self.hastagModel?.likes = sub_likes
                                self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                self.likedBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
                                self.hastagModel?.isLiked = false
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
        
    }
    private func favoriteUnFavorite(){
        if vc != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = showPostModel?.postId ?? 0
            
            Async.background({
                FavoriteManager.instance.addAndRemoveFavorite(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            
                            if success?.type ?? 0 == 1 {
                                self.favoriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favoriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
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
        }else if homeVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = homePostModel?.postID ?? 0
            
            Async.background({
                FavoriteManager.instance.addAndRemoveFavorite(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            
                            if success?.type ?? 0 == 1 {
                                self.favoriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favoriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
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
        }else if hashTagVC != nil{
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postId = hastagModel?.postID ?? 0
            
            Async.background({
                FavoriteManager.instance.addAndRemoveFavorite(accessToken: accessToken, postId: postId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            
                            if success?.type ?? 0 == 1 {
                                self.favoriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favoriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
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
        
        
    }
    private func sharePost(){
        if self.vc != nil{
            let myWebsite = NSURL(string:showPostModel?.MediaURL ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.vc!.view
            self.vc!.present(activityViewController, animated: true, completion: nil)
        }else if self.homeVC != nil{
            let myWebsite = NSURL(string:homePostModel?.mediaSet![0].file ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.homeVC!.view
            self.homeVC!.present(activityViewController, animated: true, completion: nil)
        }else if self.hashTagVC != nil{
            let myWebsite = NSURL(string:hastagModel?.mediaSet![0].file ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.hashTagVC!.view
            self.hashTagVC!.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
    func bind(item : ShowPostModel){
        
        self.showPostModel = item
        self.post_id = item.postId ?? 0
        self.user_id = item.userId ?? 0
//        self.index = index
        self.videoPlayer.loadVideoID(item.youtube ?? "")
        self.timeLbl.text = item.timeText ?? ""
        self.profileNameLbl.text = item.username ?? ""
        self.captionLbl.text = item.description ?? ""
        self.captionLbl.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        self.captionLbl.handleMentionTap { mention in
            print("Success. You just tapped the \(mention) mentioned")
        }
        self.addCommentBtn.setTitle("\("  ")\(item.commentCount ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
        if item.isLiked == true{
            self.likedBtn.setImage(UIImage(named: "Heart"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likesCount ?? 0)", for: .normal)
        }
        else{
            self.likedBtn.setImage(UIImage(named: "Heart1"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likesCount ?? 0)", for: .normal)
        }
        if (item.isSaved == true){
            self.favoriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
        }
        else{
            self.favoriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
        }
        if (item.commentCount == 0){
            self.showAllCommentBtn.isHidden = true
        }
        else{
            self.showAllCommentBtn.isHidden = false
        }
        let profile = item.imageString
        let pro_url = URL(string: profile ?? "")
        self.profileImageView.sd_setImage(with: pro_url, completed: nil)
    }
    func homeBinding(item : HomePostModel.Datum,index:Int){
        
        homePostModel = item
        self.post_id = item.postID ?? 0
        self.user_id = item.userID ?? 0
        self.index = index
        self.videoPlayer.loadVideoID(item.youtube ?? "")
        self.timeLbl.text = item.timeText ?? ""
        self.profileNameLbl.text = item.username ?? ""
        self.captionLbl.text = item.datumDescription ?? ""
        self.captionLbl.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        self.captionLbl.handleMentionTap { mention in
            print("Success. You just tapped the \(mention) mentioned")
        }
        self.addCommentBtn.setTitle("\("  ")\(item.votes ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
        if item.isLiked == true{
            self.likedBtn.setImage(UIImage(named: "Heart"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
        }
        else{
            self.likedBtn.setImage(UIImage(named: "Heart1"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
        }
        if (item.isSaved == true){
            self.favoriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
        }
        else{
            self.favoriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
        }
        if (item.comments?.isEmpty == true){
            self.showAllCommentBtn.isHidden = true
        }
        else{
            self.showAllCommentBtn.isHidden = false
        }
        let profile = item.avatar
        let pro_url = URL(string: profile ?? "")
        self.profileImageView.sd_setImage(with: pro_url, completed: nil)
    }
    
    
    
    func hashtagBinding(item : PostByHashTagModel.Datum,index:Int){
        
        hastagModel = item
        self.post_id = item.postID ?? 0
        self.user_id = item.userID ?? 0
        self.index = index
        self.videoPlayer.loadVideoID(item.youtube ?? "")
        self.timeLbl.text = item.timeText ?? ""
        self.profileNameLbl.text = item.username ?? ""
        self.captionLbl.text = item.datumDescription ?? ""
        self.captionLbl.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        self.captionLbl.handleMentionTap { mention in
            print("Success. You just tapped the \(mention) mentioned")
        }
        self.addCommentBtn.setTitle("\("  ")\(item.votes ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
        if item.isLiked == true{
            self.likedBtn.setImage(UIImage(named: "Heart"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
        }
        else{
            self.likedBtn.setImage(UIImage(named: "Heart1"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
        }
        if (item.isSaved == true){
            self.favoriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
        }
        else{
            self.favoriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
        }
        if (item.comments?.isEmpty == true){
            self.showAllCommentBtn.isHidden = true
        }
        else{
            self.showAllCommentBtn.isHidden = false
        }
        let profile = item.avatar
        let pro_url = URL(string: profile ?? "")
        self.profileImageView.sd_setImage(with: pro_url, completed: nil)
    }
    
    
    func showActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Post", comment: "Post"), preferredStyle: .actionSheet)
        if (self.user_id == AppInstance.instance.userId){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Edit Post", comment: "Edit Post"), style: .default, handler: { (_) in
                let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                let vcs = Storyboard.instantiateViewController(withIdentifier: "EditPostVC") as! EditPostController
                vcs.delegate = self
                vcs.post_id = self.post_id ?? 0
                vcs.caption = self.captionLbl.text ?? ""
                
                if (self.vc != nil){
                    self.vc?.navigationController?.pushViewController(vcs, animated: true)
                }
                else if (self.homeVC != nil){
                    self.homeVC?.navigationController?.pushViewController(vcs, animated: true)
                    
                }
                else if (self.hashTagVC != nil){
                    self.hashTagVC?.navigationController?.pushViewController(vcs, animated: true)
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
                    self.vc?.present(alert, animated: true, completion: {
                        print("completion block")
                    })
                }
                else if (self.homeVC != nil){
                    self.homeVC?.present(alert, animated: true, completion: {
                        print("completion block")
                    })
                }
                else if (self.hashTagVC != nil){
                    self.hashTagVC?.present(alert, animated: true, completion: {
                        print("completion block")
                    })
                    
                }
                //                    self.vc?.present(alert, animated: true, completion: nil)
                
                print("User click Delete button")
            }))
        }
        if (self.homeVC != nil) || (self.hashTagVC != nil){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Go to Post", comment: "Go to Post"), style: .default, handler: { (_) in
                //            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                //            let vc = Storyboard.instantiateViewController(withIdentifier: "ShowPostsVC") as! ShowPostVC
                //            self.vc?.navigationController?.pushViewController(vc, animated: true)
                if self.vc != nil{
                    let item = self.homePostModel
                    let userItem = self.homePostModel?.userData
                    var mediaSet = [String]()
                    if (item?.type != "youtube") {
                        if (item?.mediaSet!.count)! > 1{
                            item?.mediaSet?.forEach({ (it) in
                                mediaSet.append(it.file ?? "")
                            })
                        }
                    }
                    log.verbose("MediaSet = \(mediaSet)")
                    //                let vc = R.storyboard.post.showPostVC()
                    let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "ShowPostsVC") as! ShowPostVC
                    let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.posts, isFollowing: userItem?.following, userId: userItem?.userID,imageString: userItem?.avatar,timeText: item?.timeText,isAdmin: userItem?.admin)
                    let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.datumDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
                    vc.object = object
                    self.vc?.navigationController?.pushViewController(vc, animated: true)
                }
                else if self.hashTagVC != nil{
                    let item = self.hastagModel
                    let userItem = self.hastagModel?.userData
                    var mediaSet = [String]()
                    if (item?.type != "youtube"){
                        if (item?.mediaSet!.count)! > 1{
                            item?.mediaSet?.forEach({ (it) in
                                mediaSet.append(it.file ?? "")
                            })
                        }
                    }
                    log.verbose("MediaSet = \(mediaSet)")
                    let vc = R.storyboard.post.showPostsVC()
                    let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.posts, isFollowing: userItem?.following, userId: userItem?.userID,imageString: userItem?.avatar,timeText: item?.timeText,isAdmin: userItem?.admin)
                    let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.datumDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
                    vc!.object = object
                    
                    self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
                }
                    
                else if (self.homeVC != nil){
                    let item = self.homePostModel
                    let userItem = self.homePostModel?.userData
                    var mediaSet = [String]()
                    if (item?.type != "youtube"){
                    if (item?.mediaSet!.count)! > 1{
                        item?.mediaSet?.forEach({ (it) in
                            mediaSet.append(it.file ?? "")
                        })
                    }
                }
                    log.verbose("MediaSet = \(mediaSet)")
                    let vc = R.storyboard.post.showPostsVC()
                    let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.posts, isFollowing: userItem?.following, userId: userItem?.userID,imageString: userItem?.avatar,timeText: item?.timeText,isAdmin: userItem?.admin)
                    let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet?[0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.datumDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
                    vc!.object = object
                    self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Report this Post", comment: "Report this Post"), style: .default, handler: { (_) in
            self.reportPost()
            print("")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default, handler: { (_) in
            UIPasteboard.general.string = self.url ?? ""
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
        else if (self.homeVC != nil){
            self.homeVC?.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
        else if (self.hashTagVC != nil){
            self.hashTagVC?.present(alert, animated: true, completion: {
                print("completion block")
            })
            
        }
    }
    
    
    @IBAction func More(_ sender: Any) {
        //        self.showActionPicker()
        if (self.vc != nil){
            self.showActionSheet(controller: self.vc!)
        }
        else if (self.hashTagVC != nil){
            self.showActionSheet(controller: self.hashTagVC!)
        }
        else if (self.homeVC != nil){
            self.showActionSheet(controller: self.homeVC!)
        }
    }
    
    @IBAction func showAllCommentsBtn(_ sender: Any) {
        if self.vc != nil{
            let vc = R.storyboard.post.commentVC()
            //             vc?.postId = showPostModel?.postId ?? 0
            vc?.postId = self.post_id ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else if  self.homeVC != nil{
            let vc = R.storyboard.post.commentVC()
            //             vc?.postId = homePostModel?.postID ?? 0
            vc?.postId = self.post_id ?? 0
            self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
        } else if  self.hashTagVC != nil{
            let vc = R.storyboard.post.commentVC()
            //             vc?.postId = hastagModel?.postID ?? 0
            vc?.postId = self.post_id ?? 0
            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func Like(_ sender: Any) {
        self.likeDisLike()
    }
    
    @IBAction func Comment(_ sender: Any) {
            if self.vc != nil{
                let vc = R.storyboard.post.commentVC()
                //             vc?.postId = showPostModel?.postId ?? 0
                vc?.postId = self.post_id ?? 0
                self.vc?.navigationController?.pushViewController(vc!, animated: true)
            }else if  self.homeVC != nil{
                let vc = R.storyboard.post.commentVC()
                //             vc?.postId = homePostModel?.postID ?? 0
                vc?.postId = self.post_id ?? 0
                self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
            } else if  self.hashTagVC != nil{
                let vc = R.storyboard.post.commentVC()
                //             vc?.postId = hastagModel?.postID ?? 0
                vc?.postId = self.post_id ?? 0
                self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
            }
        
    }
    
    
    @IBAction func Share(_ sender: Any) {
        
        if self.vc != nil{
            //                let myWebsite = NSURL(string:showPostModel?.MediaURL ?? "")
            let myWebsite = NSURL(string: self.url ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.vc!.view
            self.vc!.present(activityViewController, animated: true, completion: nil)
        }else if self.hashTagVC != nil{
            let myWebsite = NSURL(string: self.url ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.hashTagVC!.view
            self.hashTagVC!.present(activityViewController, animated: true, completion: nil)
        }
        else if  self.homeVC != nil{
            let myWebsite = NSURL(string: self.url ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.homeVC!.view
            self.homeVC!.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func Favourite(_ sender: Any) {
        self.favoriteUnFavorite()
    }
    
    @IBAction func ShowAllComments(_ sender: Any) {

            if self.vc != nil{
                let vc = R.storyboard.post.commentVC()
                //            vc?.postId = showPostModel?.postId ?? 0
                vc?.postId  = self.post_id ?? 0
                self.vc?.navigationController?.pushViewController(vc!, animated: true)
            }else if  self.homeVC != nil{
                let vc = R.storyboard.post.commentVC()
                //            vc?.postId = homePostModel?.postID ?? 0
                vc?.postId  = self.post_id ?? 0
                self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
            }else if  self.hashTagVC != nil{
                let vc = R.storyboard.post.commentVC()
                vc?.postId = hastagModel?.postID ?? 0
                self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
            }
        
        
    }
    
    
    @IBAction func LikesCount(_ sender: Any) {
        if self.likesCountBtn.titleLabel?.text == "0"{
            if (self.vc != nil){
                self.vc?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
            else if (self.hashTagVC != nil){
                self.hashTagVC?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
            else if (self.homeVC != nil){
                self.homeVC?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
        }
        else{
            
            if self.vc != nil{
                let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
                navigationVC.modalPresentationStyle = .fullScreen
                navigationVC.modalTransitionStyle = .coverVertical
                let vc = navigationVC.topViewController as! LikesVC
                vc.postId = self.post_id ?? 0
                self.vc?.present(navigationVC, animated: true, completion: nil)
            }else if  self.hashTagVC != nil{
                let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
                navigationVC.modalPresentationStyle = .fullScreen
                navigationVC.modalTransitionStyle = .coverVertical
                let vc = navigationVC.topViewController as! LikesVC
                vc.postId = self.post_id ?? 0
                self.hashTagVC?.present(navigationVC, animated: true, completion: nil)
            }
            else if (self.homeVC != nil){
                let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
                navigationVC.modalPresentationStyle = .fullScreen
                navigationVC.modalTransitionStyle = .coverVertical
                let vc = navigationVC.topViewController as! LikesVC
                vc.postId = self.post_id ?? 0
                self.homeVC?.present(navigationVC, animated: true, completion: nil)
            }
        }
    }
    
    func editPost(text: String) {
        self.captionLbl.text = text
    }
}
