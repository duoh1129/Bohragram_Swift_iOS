//
//  PPVideoItemTableViewCell.swift
//  Pixel Photo
//
//  Created by DoughouzLight on 05/01/2019.
//  Copyright © 2019 DoughouzLight. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import RxCocoa
import RxSwift
import RxGesture
import ActionSheetPicker_3_0
import WebKit
import ActiveLabel
import VersaPlayer
import Async
import PixelPhotoSDK


class PPVideoItemTableViewCell: UITableViewCell,EditPostDelegate {
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var controls: VersaPlayerControls!
    @IBOutlet weak var playerView: VersaPlayerView!
    //@IBOutlet weak var contentWebView: WKWebView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var numLikeLbl: UILabel!
    @IBOutlet weak var numCommentLbl: UILabel!
    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var showAllCommentBtn: UIButton!
    @IBOutlet weak var captionLbl: ActiveLabel!
    @IBOutlet weak var showAllCommentLbl: UILabel!
    fileprivate var isUpdateTime = false
    
    
    var disposeBag = DisposeBag()
    
    //    lazy var mmPlayerLayer: MMPlayerLayer = {
    //        let l = MMPlayerLayer()
    //
    //        l.cacheType = .memory(count: 5)
    //        l.coverFitType = .fitToPlayerView
    //        l.videoGravity = AVLayerVideoGravity.resizeAspect
    //        l.replace(cover: CoverView.instantiateFromNib())
    //        return l
    //    }()
    
    
    
    var loaded = false
    var isplaying = false
    var showPostModel:ShowPostModel?
    var homePostModel:HomePostModel.Datum?
    var vc:ShowPostVC?
    var homeVC:HomeVC?
    var hashTagVC:FetchHashTagPostVC?
    var hastagModel:PostByHashTagModel.Datum?
    
    var post_id: Int? = nil
    var user_id: Int? = nil
    var url: String? = nil
    var index: Int? = nil
    
    @IBOutlet weak var allCommentViewTopContraints: NSLayoutConstraint!
    @IBOutlet weak var showAllCommentTopConstraints: NSLayoutConstraint!
    
    private var aspectConstraint: NSLayoutConstraint?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        self.topView.backgroundColor = UIColor.white
        //        self.profileImageView.isCircular(borderColor: UIColor.clear)
        //        self..text = NSLocalizedString("Show all comment", comment: "")
        
        //        let webConfiguration = WKWebViewConfiguration()
        //        webConfiguration.preferences.javaScriptEnabled = true
        //        webConfiguration.allowsInlineMediaPlayback = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        self.profileImageView.addGestureRecognizer(gesture)
        self.profileNameLbl.addGestureRecognizer(gestureonLabel)
        self.profileImageView.isUserInteractionEnabled = true
        self.profileNameLbl.isUserInteractionEnabled = true
        
        
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
        self.captionLbl.numberOfLines = 0
        self.captionLbl.enabledTypes = [.mention, .hashtag]
        self.captionLbl.customColor[.mention] = UIColor.red
        self.captionLbl.customSelectedColor[.hashtag] = UIColor.blue
        self.playerView.autoplay = false
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
    
    deinit {
        print("PPVideoItemTableViewCell deinit")
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
        else if (self.homeVC != nil){
            let item = self.homePostModel
            let object = self.homePostModel?.userData
            if (object?.userID == AppInstance.instance.userId){
                print("Nothing")
                self.homeVC?.tabBarController?.selectedIndex = 4
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        if self.vc != nil{
        //            if showPostModel?.description == "" {
        //                self.captionLbl.isHidden = true
        //                self.allCommentViewTopContraints.isActive = true
        //                self.showAllCommentTopConstraints.isActive = false
        //            }else{
        //                self.captionLbl.isHidden = false
        //                self.allCommentViewTopContraints.isActive = false
        //                self.showAllCommentTopConstraints.isActive = true
        //                self.captionLbl.text = self.showPostModel?.description!.decodeHtmlEntities()?.arrangeMentionedContacts()
        //            }
        //        }else if self.homeVC != nil{
        //            if homePostModel?.datumDescription == "" {
        //                self.captionLbl.isHidden = true
        //                self.allCommentViewTopContraints.isActive = true
        //                self.showAllCommentTopConstraints.isActive = false
        //            }else{
        //                self.captionLbl.isHidden = false
        //                self.allCommentViewTopContraints.isActive = false
        //                self.showAllCommentTopConstraints.isActive = true
        //                self.captionLbl.text = self.homePostModel?.datumDescription!.decodeHtmlEntities()?.arrangeMentionedContacts()
        //            }
        //        }
        //        else if self.hashTagVC != nil{
        //            if hastagModel?.datumDescription == "" {
        //                self.captionLbl.isHidden = true
        //                self.allCommentViewTopContraints.isActive = true
        //                self.showAllCommentTopConstraints.isActive = false
        //            }else{
        //                self.captionLbl.isHidden = false
        //                self.allCommentViewTopContraints.isActive = false
        //                self.showAllCommentTopConstraints.isActive = true
        //                self.captionLbl.text = self.hastagModel?.datumDescription!.decodeHtmlEntities()?.arrangeMentionedContacts()
        //            }
        //        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("PPVideoItemTableViewCell prepareForReuse")
        self.disposeBag = DisposeBag()
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
                                    self.showPostModel?.isLiked = true
                                }else{
                                    let likes = (self.showPostModel?.likesCount ?? 0)
                                    let sub_likes = likes - 1
                                    self.showPostModel?.likesCount = sub_likes
                                    self.likesCountBtn.setTitle("\(sub_likes)", for: .normal)
                                    self.likeBtn.setImage(UIImage(named: "Heart1"), for: UIControl.State.normal)
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
                                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
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
                                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
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
                                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: UIControl.State.normal)
                            }else{
                                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: UIControl.State.normal)
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
                    let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.datumDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
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
                    
                else if (self.homeVC != nil){
                    let item = self.homePostModel
                    let userItem = self.homePostModel?.userData
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
    
    func hashTagBinding(item : PostByHashTagModel.Datum,index:Int){
        
        if loaded == false {
            hastagModel = item
            self.post_id = item.postID ?? 0
            self.user_id = item.userID ?? 0
            self.index = index
            self.url  = "\("\(API.baseURL)/post/")\(item.postID ?? 0)"
            self.timeLbl.text = item.timeText ?? ""
            self.profileNameLbl.text = item.username ?? ""
            self.captionLbl.text = item.datumDescription ?? ""
            self.captionLbl.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            self.captionLbl.handleMentionTap { mention in
                print("Success. You just tapped the \(mention) mentioned")
            }
            self.commentBtn.setTitle("\("  ")\(item.votes ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
            if item.isLiked == true{
                self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            else{
                self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            if (item.isSaved == true){
                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
            }
            else{
                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
            }
            if (item.comments?.isEmpty == true){
                self.showAllCommentBtn.isHidden = true
            }
            else{
                self.showAllCommentBtn.isHidden = false
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
        log.verbose("Media Files = \(item.mediaSet![0].file!)")
        self.load(url: item.mediaSet![0].file!)
    }
    func homeBinding(item : HomePostModel.Datum,index:Int){
        
        if loaded == false {
            homePostModel = item
            self.post_id = item.postID ?? 0
            self.user_id = item.userID ?? 0
            self.index = index
            self.url  = "\("\(API.baseURL)/post/")\(item.postID ?? 0)"
            self.timeLbl.text = item.timeText ?? ""
            self.profileNameLbl.text = item.username ?? ""
            self.captionLbl.text = item.datumDescription ?? ""
            self.captionLbl.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            self.captionLbl.handleMentionTap { mention in
                print("Success. You just tapped the \(mention) mentioned")
            }
            self.commentBtn.setTitle("\("  ")\(item.votes ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
            if item.isLiked == true{
                self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            else{
                self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likes ?? 0)", for: .normal)
            }
            if (item.isSaved == true){
                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
            }
            else{
                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
            }
            if (item.comments?.isEmpty == true){
                self.showAllCommentBtn.isHidden = true
            }
            else{
                self.showAllCommentBtn.isHidden = false
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
        log.verbose("Media Files = \(item.mediaSet![0].file!)")
        self.load(url: item.mediaSet![0].file!)
    }
    func bind(item : ShowPostModel){
        
        if loaded == false {
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
            self.commentBtn.setTitle("\("  ")\(item.commentCount ?? 0)\(" ")\(NSLocalizedString("Comments", comment: "Comments"))", for: .normal)
            if item.isLiked == true{
                self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likesCount ?? 0)", for: .normal)
            }
            else{
                self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
                self.likesCountBtn.setTitle("\(item.likesCount ?? 0)", for: .normal)
            }
            if (item.isSaved == true){
                self.favouriteBtn.setImage(UIImage(named: "Star2"), for: .normal)
            }
            else{
                self.favouriteBtn.setImage(UIImage(named: "Star1"), for: .normal)
            }
            if (item.commentCount == 0){
                self.showAllCommentBtn.isHidden = true
            }
            else{
                self.showAllCommentBtn.isHidden = false
            }
            
            
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
        }
        
        self.load(url: item.MediaURL!)
    }
    func load(url: String) {
        //let html = "<video playsinline controls width=\"100%\" height=\"100%\" src=\"\(url)\"> </video>"
        DispatchQueue.main.async {
            self.playerView.layer.backgroundColor = UIColor.black.cgColor
            self.playerView.use(controls: self.controls)
            if let url = URL.init(string: url) {
                let item = VersaPlayerItem(url: url)
                self.playerView.set(item: item)
            }
        }
    }
    
    
    @IBAction func More(_ sender: Any) {
        if self.vc != nil{
            self.showActionSheet(controller: self.vc!)
        }
        else if (self.homeVC != nil){
            self.showActionSheet(controller: self.homeVC!)
        }
        else if (self.hashTagVC != nil){
            self.showActionSheet(controller: self.hashTagVC!)
        }
    }
    
    @IBAction func showAllCommentsBtn(_ sender: Any) {
        if self.vc != nil{
            let vc = R.storyboard.post.commentVC()
            //                vc?.postId = showPostModel?.postId ?? 0
            vc?.postId = self.post_id ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else if  self.homeVC != nil{
            let vc = R.storyboard.post.commentVC()
            //                vc?.postId = homePostModel?.postID ?? 0
            vc?.postId = self.post_id ?? 0
            self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
        } else if  self.hashTagVC != nil{
            let vc = R.storyboard.post.commentVC()
            //                vc?.postId = hastagModel?.postID ?? 0
            vc?.postId = self.post_id ?? 0
            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
        }
        
        
        
        //            let vc = R.storyboard.post.commentVC()
        //            vc?.postId = self.post_id ?? 0
        //            self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func Like(_ sender: Any) {
        self.likeDisLike()
    }
    
    @IBAction func Comment(_ sender: Any) {
        if self.vc != nil{
            let vc = R.storyboard.post.commentVC()
            //                   vc?.postId = showPostModel?.postId ?? 0
            vc?.postId = self.post_id ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else if  self.homeVC != nil{
            let vc = R.storyboard.post.commentVC()
            //                   vc?.postId = homePostModel?.postID ?? 0
            vc?.postId = self.post_id ?? 0
            self.homeVC?.navigationController?.pushViewController(vc!, animated: true)
        } else if  self.hashTagVC != nil{
            let vc = R.storyboard.post.commentVC()
            vc?.postId = self.post_id ?? 0
            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
        }
     
    }
    
    @IBAction func Share(_ sender: Any) {
        if self.vc != nil{
            let myWebsite = NSURL(string: self.url ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.vc?.view
            self.vc?.present(activityViewController, animated: true, completion: nil)
        }
        else if  self.homeVC != nil{
            let myWebsite = NSURL(string: self.url ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.homeVC?.view
            self.homeVC?.present(activityViewController, animated: true, completion: nil)
        }
        else if (self.self.hashTagVC != nil){
            let myWebsite = NSURL(string: self.url ?? "")
            let shareAll = [myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.hashTagVC?.view
            self.hashTagVC?.present(activityViewController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func Favourite(_ sender: Any) {
        self.favoriteUnFavorite()
    }
    
    @IBAction func LikesCount(_ sender: Any) {
        if self.likesCountBtn.titleLabel?.text == "0"{
            self.homeVC?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
        }
        else{
            let Storyboard = UIStoryboard(name: "Post", bundle: nil)
            let navigationVC = Storyboard.instantiateViewController(withIdentifier: "LikeNav_VC") as! UINavigationController
            navigationVC.modalPresentationStyle = .fullScreen
            navigationVC.modalTransitionStyle = .coverVertical
            let vc = navigationVC.topViewController as! LikesVC
            vc.postId = self.post_id ?? 0
            self.homeVC?.present(navigationVC, animated: true, completion: nil)
        }
    }
    
    func editPost(text: String) {
        self.captionLbl.text = text
    }
    
    
    
}

