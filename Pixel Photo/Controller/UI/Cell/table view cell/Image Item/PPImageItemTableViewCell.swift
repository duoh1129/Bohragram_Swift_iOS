//
//  PPPostItemTableViewCell.swift
//  Pixel Photo
//
//  Created by DoughouzLight on 05/01/2019.
//  Copyright © 2019 DoughouzLight. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import RxGesture
import ActionSheetPicker_3_0
import ActiveLabel
import Async
import PixelPhotoSDK


class PPImageItemTableViewCell: UITableViewCell,EditPostDelegate {
    
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var captionLbl: ActiveLabel!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var allCommentViewTopContraints: NSLayoutConstraint!
    @IBOutlet weak var showCallCommentsTopConstraints: NSLayoutConstraint!
    private var aspectConstraint: NSLayoutConstraint?
    
    var disposeBag = DisposeBag()
    
    
    
    @IBOutlet weak var showAllCommentLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var addCommentBtn: UIButton!
    @IBOutlet weak var likedBtn: UIButton!
    @IBOutlet weak var showallComments: UIButton!
    var loaded = false
    var showPostModel:ShowPostModel?
    var vc:ShowPostVC?
    var homePostModel:HomePostModel.Datum?
    var homeVC:HomeVC?
    var hashTagVC:FetchHashTagPostVC?
    var hastagModel:PostByHashTagModel.Datum?
    
    var post_id: Int? = nil
    var user_id: Int? = nil
    var url: String? = nil
    var index: Int? = nil
    var height : CGFloat? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.captionLbl.numberOfLines = 0
        self.captionLbl.enabledTypes = [.mention, .hashtag]
        self.captionLbl.customColor[.mention] = UIColor.red
        self.captionLbl.customSelectedColor[.hashtag] = UIColor.blue
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
 
        self.contentImgView.addGestureRecognizer(doubleTap)
        self.contentImgView.isUserInteractionEnabled = true
        print(self.height)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        self.profileImageView.addGestureRecognizer(gesture)
        self.profileNameLbl.addGestureRecognizer(gestureonLabel)
        self.profileImageView.isUserInteractionEnabled = true
        self.profileNameLbl.isUserInteractionEnabled = true
      
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
                self.hashTagVC?.tabBarController?.selectedIndex = 4
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("PPImageItemTableViewCell prepareForReuse")
        
        self.disposeBag = DisposeBag()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.vc != nil{
            if showPostModel?.description == "" {
                self.captionLbl.isHidden = true
                //self.allCommentViewTopContraints.isActive = true
                //self.showCallCommentsTopConstraints.isActive = false
            }else{
                self.captionLbl.isHidden = false
                //self.allCommentViewTopContraints.isActive = false
                // self.showCallCommentsTopConstraints.isActive = true
                self.captionLbl.text = self.showPostModel?.description!.decodeHtmlEntities()?.arrangeMentionedContacts()
            }
        }else if self.homeVC != nil{
            if homePostModel?.datumDescription == "" {
                self.captionLbl.isHidden = true
                //self.allCommentViewTopContraints.isActive = true
                // self.showCallCommentsTopConstraints.isActive = false
            }else{
                self.captionLbl.isHidden = false
                //  self.allCommentViewTopContraints.isActive = false
                // self.showCallCommentsTopConstraints.isActive = true
                self.captionLbl.text = self.homePostModel?.datumDescription!.decodeHtmlEntities()?.arrangeMentionedContacts()
            }
        }else if self.hashTagVC != nil{
            if hastagModel?.datumDescription == "" {
                self.captionLbl.isHidden = true
                // self.allCommentViewTopContraints.isActive = true
                // self.showCallCommentsTopConstraints.isActive = false
            }else{
                self.captionLbl.isHidden = false
                //  self.allCommentViewTopContraints.isActive = false
                //  self.showCallCommentsTopConstraints.isActive = true
                self.captionLbl.text = self.hastagModel?.datumDescription!.decodeHtmlEntities()?.arrangeMentionedContacts()
            }
        }
    }
    @IBAction func morePressed(_ sender: Any) {
        self.showActionSheet(controller: self.vc!)

    }
    @IBAction func sharePressed(_ sender: Any) {
        self.sharePost()
    }
    @IBAction func favoritePressed(_ sender: Any) {
        
        self.favoriteUnFavorite()
    }
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
                            self.vc?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))

//                            self.vc?.navigationController?.popViewController(animated: true)
                            
                            
                            
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
                            self.homeVC?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))
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
                            
            self.hashTagVC?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))

//                            self.hashTagVC?.navigationController?.popViewController(animated: true)
                            
                            
                            
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
                                self.likeBtn.setImage(UIImage(named: "Heart"), for: UIControl.State.normal)
                            }else{
                                let likes = (self.showPostModel?.likesCount ?? 0)
                                let sub_likes = likes - 1
                                self.showPostModel?.likesCount = sub_likes
                                self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                self.likeBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
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
                                 self.likeBtn.setImage(UIImage(named: "Heart"), for: UIControl.State.normal)
                                 self.hastagModel?.isLiked = true
                             }else{
                                 let likes = (self.hastagModel?.likes ?? 0)
                                 let sub_likes = likes - 1
                                 self.hastagModel?.likes = sub_likes
                                 self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                 self.likeBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
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

    func showActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Post", comment: "Post"), preferredStyle: .actionSheet)
        if (self.user_id == AppInstance.instance.userId){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Edit Post", comment: "Edit Post"), style: .default, handler: { (_) in
                if (self.vc != nil){
                    let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "EditPostVC") as! EditPostController
                    vc.delegate = self
                    vc.post_id = self.post_id ?? 0
                    vc.caption = self.captionLbl.text ?? ""
                    self.vc?.navigationController?.pushViewController(vc, animated: true)                }
                else if (self.hashTagVC != nil){
                    let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "EditPostVC") as! EditPostController
                    vc.delegate = self
                    vc.post_id = self.post_id ?? 0
                    vc.caption = self.captionLbl.text ?? ""
                    self.hashTagVC?.navigationController?.pushViewController(vc, animated: true)
                }
                else if (self.homeVC != nil){
                    let Storyboard = UIStoryboard(name: "Post", bundle: nil)
                     let vc = Storyboard.instantiateViewController(withIdentifier: "EditPostVC") as! EditPostController
                     vc.delegate = self
                     vc.post_id = self.post_id ?? 0
                     vc.caption = self.captionLbl.text ?? ""
                     self.vc?.navigationController?.pushViewController(vc, animated: true)
                }

                print("User click Edit button")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Delete Post", comment: "Delete Post"), style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: "Delete Post", message: "Are you sure want to delete this post", preferredStyle: UIAlertController.Style.alert)
                
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
                else if (self.hashTagVC != nil){
                    self.vc?.present(alert, animated: true, completion: nil)
                }
                else if (self.homeVC != nil){
                    self.vc?.present(alert, animated: true, completion: nil)
                }
                print("User click Delete button")
            }))
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Report this Post", comment: "Report this Post"), style: .default, handler: { (_) in
            self.reportPost()
            print("")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default, handler: { (_) in
            UIPasteboard.general.string = self.url ?? ""
            if (self.vc != nil){
                self.vc?.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
            }
            else if (self.hashTagVC != nil){
            self.hashTagVC?.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))

            }
            else if (self.homeVC != nil){
                self.homeVC?.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
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
        else if (self.hashTagVC != nil){
            self.hashTagVC?.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
        else if (self.homeVC != nil){
            self.homeVC?.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    }
    
    
    
    func bind(item : ShowPostModel){
        print(self.height)
        self.contentImgView.image = nil
//        self.heightConstraint.constant = self.height ?? 250.0
        self.vc?.contentTblView.reloadData()
        showPostModel = item

        self.post_id = item.postId ?? 0
        self.user_id = item.userId ?? 0
        self.url  = "\("\(API.baseURL)/post/")\(item.postId ?? 0)"
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
            self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likesCount ?? 0)", for: .normal)
        }
        else{
            self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
            self.likesCountBtn.setTitle("\(item.likesCount ?? 0)", for: .normal)
        }
        if (item.isSaved == true){
            self.favoriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
        }
        else{
            self.favoriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
        }
        
        if (item.commentCount == 0){
            self.showallComments.isHidden = true
        }
        else{
            self.showallComments.isHidden = false
        }
//        self.topView.backgroundColor = UIColor.white
        
        if let profImg = SDImageCache.shared.imageFromCache(forKey:item.imageString!) {
            self.profileImageView.image = profImg
        }else{
            self.profileImageView.sd_setImage(with: URL(string:item.imageString!),
                                              placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                
                                                
                                                if error != nil {
                                                    self.profileImageView.image = UIImage(named: "img_item_placeholder")
                                                }else{
                                                    SDImageCache.shared.store(image, forKey: item.imageString!, completion: {
                                                        self.profileImageView.image = image
                                                    })
                                                }
                                                
                                                
            }
        }
        
//    self.contentImgView.sd_setImage(with: URL(string: item.MediaURL ?? ""), completed: nil)
        self.loadThumbNail(item: item.MediaURL ?? "")
        
    }
    func homeBinding(item : HomePostModel.Datum,index:Int){
        
        if loaded == false {
            homePostModel = item
            self.post_id = item.postID ?? 0
            self.user_id = item.userID ?? 0
            self.timeLbl.text = item.timeText ?? ""
            self.profileNameLbl.text = item.username ?? ""
            self.captionLbl.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            self.captionLbl.handleMentionTap { mention in
                print("Success. You just tapped the \(mention) mentioned")
            }
            
            if item.isLiked == true{
                self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            else{
                self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            if (item.isSaved == true){
                self.favoriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
            }
            else{
                self.favoriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
            }
            
            if (item.votes ?? 0 == 0){
                self.showallComments.isHidden = true
            }
            else{
                self.showallComments.isHidden = false
            }
            
            
            if let profImg = SDImageCache.shared.imageFromCache(forKey:item.avatar!) {
                self.profileImageView.image = profImg
            }else{
                self.profileImageView.sd_setImage(with: URL(string:item.avatar!),
                                                  placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                    
                                                    
                                                    if error != nil {
                                                        self.profileImageView.image = UIImage(named: "img_item_placeholder")
                                                    }else{
                                                        SDImageCache.shared.store(image, forKey: item.avatar!, completion: {
                                                            self.profileImageView.image = image
                                                        })
                                                    }
                                                    
                                                    
                }
            }
        }
        
        self.loadThumbNail(item: item.mediaSet![0].file ?? "")
        
        
    }
    func hashTagBinding(item : PostByHashTagModel.Datum,index:Int){
        
        if loaded == false {
            hastagModel = item
            self.post_id = item.postID ?? 0
            self.user_id = item.userID ?? 0
            if item.isLiked == true{
                self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            else{
                self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            if (item.isSaved == true){
                self.favoriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
            }
            else{
                self.favoriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
            }
            
            if (item.votes ?? 0 == 0){
                self.showallComments.isHidden = true
            }
            else{
                self.showallComments.isHidden = false
            }
            
            self.captionLbl.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            self.captionLbl.handleMentionTap { mention in
                print("Success. You just tapped the \(mention) mentioned")
            }
    
            if let profImg = SDImageCache.shared.imageFromCache(forKey:item.avatar!) {
                self.profileImageView.image = profImg
            }else{
                self.profileImageView.sd_setImage(with: URL(string:item.avatar!),
                                                  placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                    
                                                    
                                                    if error != nil {
                                                        self.profileImageView.image = UIImage(named: "img_item_placeholder")
                                                    }else{
                                                        SDImageCache.shared.store(image, forKey: item.avatar!, completion: {
                                                            self.profileImageView.image = image
                                                        })
                                                    }
                                                    
                                                    
                }
            }
        }
        
        self.loadThumbNail(item: item.mediaSet![0].file ?? "")
        
        
    }
    
    
    func loadThumbNail(item:String){
        
        if self.aspectConstraint != nil {
            self.contentImgView.removeConstraint(self.aspectConstraint!)
        }
        
        if item == "" {
            if let image = SDImageCache.shared.imageFromCache(forKey:item) {
                
                let aspectRatio = (image as UIImage).size.height/(image as UIImage).size.width
                
                self.aspectConstraint = NSLayoutConstraint(item: self.contentImgView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: self.contentImgView,
                                                           attribute: .width,
                                                           multiplier: aspectRatio,
                                                           constant: 0)
                
                self.aspectConstraint?.priority = UILayoutPriority(rawValue: 999)
                self.contentImgView.addConstraint(self.aspectConstraint!)
                self.contentImgView.image = image
                self.setNeedsLayout()
            }else{
                self.contentImgView.sd_setImage(with: URL(string: item),
                                                placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                    
                                                    if error != nil {
                                                        self.contentImgView.image = UIImage(named: "img_item_placeholder")
                                                        self.setNeedsLayout()
                                                    }else{
                                                        SDImageCache.shared.store(image, forKey: item, completion: {
                                                            let aspectRatio = (image! as UIImage).size.height/(image! as UIImage).size.width
                                                            
                                                            self.aspectConstraint = NSLayoutConstraint(item: self.contentImgView,
                                                                                                       attribute: .height,
                                                                                                       relatedBy: .equal,
                                                                                                       toItem: self.contentImgView,
                                                                                                       attribute: .width,
                                                                                                       multiplier: aspectRatio,
                                                                                                       constant: 0)
                                                            
                                                            self.aspectConstraint?.priority = UILayoutPriority(rawValue: 999)
                                                            self.contentImgView.addConstraint(self.aspectConstraint!)
                                                            self.contentImgView.image = image
                                                            self.setNeedsLayout()
                                                        })
                                                    }
                }
            }
        }else{
            if let image = SDImageCache.shared.imageFromCache(forKey:item) {
                
                let aspectRatio = (image as UIImage).size.height/(image as UIImage).size.width
                
                self.aspectConstraint = NSLayoutConstraint(item: self.contentImgView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: self.contentImgView,
                                                           attribute: .width,
                                                           multiplier: aspectRatio,
                                                           constant: 0)
                
                self.aspectConstraint?.priority = UILayoutPriority(rawValue: 999)
                self.contentImgView.addConstraint(self.aspectConstraint!)
                self.contentImgView.image = image
                self.setNeedsLayout()
            }else{
                self.contentImgView.sd_setImage(with: URL(string: item),
                                                placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                    
                                                    if error != nil {
                                                        self.contentImgView.image = UIImage(named: "img_item_placeholder")
                                                        self.setNeedsLayout()
                                                    }else{
                                                        SDImageCache.shared.store(image, forKey: item, completion: {
                                                            let aspectRatio = (image! as UIImage).size.height/(image! as UIImage).size.width
                                                            
                                                            self.aspectConstraint = NSLayoutConstraint(item: self.contentImgView,
                                                                                                       attribute: .height,
                                                                                                       relatedBy: .equal,
                                                                                                       toItem: self.contentImgView,
                                                                                                       attribute: .width,
                                                                                                       multiplier: aspectRatio,
                                                                                                       constant: 0)
                                                            
                                                            self.aspectConstraint?.priority = UILayoutPriority(rawValue: 999)
                                                            self.contentImgView.addConstraint(self.aspectConstraint!)
                                                            self.contentImgView.image = image
                                                            self.setNeedsLayout()
                                                        })
                                                    }
                }
            }
        }
        
    }
    
    func loadThumbNailFixHeight(item:HomePostModel.Datum){
        
        self.contentImgView.contentMode = UIView.ContentMode.scaleAspectFill
        self.contentImgView.clipsToBounds = true
        
        if self.aspectConstraint != nil {
            self.contentImgView.removeConstraint(self.aspectConstraint!)
        }
        
        self.aspectConstraint = NSLayoutConstraint(item: self.contentImgView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .width,
                                                   multiplier: 1.0,
                                                   constant: 350)
        
        self.aspectConstraint?.priority = UILayoutPriority(rawValue: 999)
        self.contentImgView.addConstraint(self.aspectConstraint!)
        
        if item.mediaSet![0].extra! == "" {
            if let image = SDImageCache.shared.imageFromCache(forKey:item.mediaSet![0].file!) {
                self.contentImgView.image = image
            }else{
                self.contentImgView.sd_setImage(with: URL(string: item.mediaSet![0].file!),
                                                placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                    
                                                    if error != nil {
                                                        self.contentImgView.image = UIImage(named: "img_item_placeholder")
                                                    }else{
                                                        SDImageCache.shared.store(image, forKey: item.mediaSet![0].file!, completion: {
                                                            self.contentImgView.image = image!
                                                        })
                                                    }
                                                    
                                                    
                                                    
                                                    
                }
            }
        }else{
            if let image = SDImageCache.shared.imageFromCache(forKey:item.mediaSet![0].extra!) {
                self.contentImgView.image = image
            }else{
                self.contentImgView.sd_setImage(with: URL(string: item.mediaSet![0].extra!),
                                                placeholderImage: UIImage(named: "img_item_placeholder")) {  (image, error, cacheType, url) in
                                                    
                                                    if error != nil {
                                                        self.contentImgView.image = UIImage(named: "img_item_placeholder")
                                                    }else{
                                                        SDImageCache.shared.store(image, forKey: item.mediaSet![0].extra!, completion: {
                                                            self.contentImgView.image = image!
                                                        })
                                                    }
                }
            }
        }
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
            else if (self.homeVC != nil){
                self.homeVC?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
            else if (self.hashTagVC != nil){
                self.hashTagVC?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
            }
        }
   
        else{
        if self.vc != nil{
            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
            navigationVC.modalPresentationStyle = .fullScreen
            navigationVC.modalTransitionStyle = .coverVertical
            let vc = navigationVC.topViewController as! LikesVC
            vc.postId = showPostModel?.postId ?? 0
            //            vc.postId = self.post_id ?? 0
            self.vc?.present(navigationVC, animated: true, completion: nil)
        }else if  self.homeVC != nil{
            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
            navigationVC.modalPresentationStyle = .fullScreen
            navigationVC.modalTransitionStyle = .coverVertical
            let vc = navigationVC.topViewController as! LikesVC
            vc.postId = homePostModel?.postID ?? 0
            self.vc?.present(navigationVC, animated: true, completion: nil)
        }else if  self.hashTagVC != nil{
            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
            navigationVC.modalPresentationStyle = .fullScreen
            navigationVC.modalTransitionStyle = .coverVertical
            let vc = navigationVC.topViewController as! LikesVC
            vc.postId = hastagModel?.postID ?? 0
            self.vc?.present(navigationVC, animated: true, completion: nil)
            
        }
    }
    }
    func editPost(text: String) {
        self.captionLbl.text! = text
    }
}
