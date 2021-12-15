//
//  PostWithTwoImage.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/23/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import ActiveLabel
import Async
import PixelPhotoSDK
import ActionSheetPicker_3_0

class PostWithTwoImage: UITableViewCell,EditPostDelegate {

    
    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var captionLabel: ActiveLabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var showAllCommentBtn: UIButton!
    var post_id: Int? = nil
    var user_id: Int? = nil
    var url: String? = nil
    var index: Int? = nil
    
    var vc : HomeVC?
    var post_vc:ShowPostVC?
    var hashTagVC:FetchHashTagPostVC?
    var hastagModel:PostByHashTagModel.Datum?
    var homePostModel:HomePostModel.Datum?
    var showPostModel:ShowPostModel?
    
    var delegate: DeletePostDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        let doubleTap1 = UITapGestureRecognizer(target: self, action: #selector(self.DoubleTap(gesture:)))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        doubleTap1.numberOfTouchesRequired = 1
        doubleTap1.numberOfTapsRequired = 2
        self.imageView1.addGestureRecognizer(doubleTap)
        self.imageView2.addGestureRecognizer(doubleTap1)
        self.imageView1.isUserInteractionEnabled = true
        self.imageView2.isUserInteractionEnabled = true
        self.profileImage.addGestureRecognizer(gesture)
        self.userNameLabel.addGestureRecognizer(gestureonLabel)
        self.profileImage.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        self.showAllCommentBtn.setTitle(NSLocalizedString("Show all comments", comment: "Show all comments"), for: .normal)
    }
    @IBAction func DoubleTap(gesture: UIGestureRecognizer){
        print("Double Tab")
        if (self.vc != nil){
            if (self.homePostModel?.isLiked == false){
                self.likeDisLike()
            }
        }
        else if (self.hashTagVC != nil){
            if (self.hastagModel?.isLiked == false){
                self.likeDisLike()
            }
        }
    }
    
     @IBAction func gotoUserProfile(gesture: UIGestureRecognizer){
         if self.vc != nil{
            let item = self.homePostModel
            let object = self.homePostModel?.userData
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
    
    func bind(object: HomePostModel.Datum, index:Int){
        self.homePostModel  = object
        self.post_id = object.postID ?? 0
        self.user_id = object.userID ?? 0
        self.index = index
        self.url  = "\("\(API.baseURL)/post/")\(object.postID ?? 0)"
        let image1 = object.mediaSet?[0].file ?? ""
        let url = URL(string: image1)
        self.imageView1.sd_setImage(with: url, completed: nil)
        let image2 = object.mediaSet?[1].file ?? ""
        let url1 = URL(string: image2)
        self.imageView2.sd_setImage(with: url1, completed: nil)
        self.captionLabel.text = object.datumDescription ?? ""
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
            self.showAllCommentBtn.isHidden = true
        }
        else{
            self.showAllCommentBtn.isHidden = false
        }
    }
    
    
    
    func hashTagBinding(item : PostByHashTagModel.Datum,index:Int){
        self.hastagModel = item
        self.post_id = item.postID ?? 0
        self.user_id = item.userID ?? 0
        self.index = index
        self.url  = "\("\(API.baseURL)/post/")\(item.postID ?? 0)"
        let image1 = item.mediaSet?[0].file ?? ""
        let url = URL(string: image1)
        self.imageView1.sd_setImage(with: url, completed: nil)
        let profile = item.avatar
        let pro_url = URL(string: profile ?? "")
        self.profileImage.sd_setImage(with: pro_url, completed: nil)
        self.userNameLabel.text = item.username ?? ""
        self.timeLabel.text = item.timeText ?? ""
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
                            
                            if (self.vc != nil){
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
                        }
                            else if (self.hashTagVC != nil){
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
            else if (self.hashTagVC != nil){
                self.hashTagVC?.view.makeToast(InterNetError)
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
                            else if (self.hashTagVC != nil){
                                self.hashTagVC?.view.makeToast(sessionError?.errors?.errorText)
                            }
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        })
                        
                    }else {
                        Async.main({
                            if (self.vc != nil){
                                self.vc?.view.makeToast(error?.localizedDescription)
                            }
                            else if (self.hashTagVC != nil){
                                self.hashTagVC?.view.makeToast(error?.localizedDescription)
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
            else if (self.hashTagVC != nil){
                self.hashTagVC?.view.makeToast(InterNetError)
            }
        }
    }
    
    private func reportPost(){
        let accessToken = AppInstance.instance.accessToken ?? ""
        //        let postId = homePostModel?.postID ?? 0
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                ReportManager.instance.reportPost(accessToken: accessToken, postId: self.post_id ?? 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success!)")
                            if (self.vc != nil){
                                self.vc?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))
                            }
                            else if (self.hashTagVC != nil){
                                self.hashTagVC?.view.makeToast(NSLocalizedString("Your report has been sent", comment: "Your report has been sent"))
                            }
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
        }
        else{
            log.error("internetError = \(InterNetError)")
            if (self.vc != nil){
                self.vc?.view.makeToast(InterNetError)
            }
            else if (self.hashTagVC != nil){
                self.hashTagVC?.view.makeToast(InterNetError)
            }
        }
    }
    
    private func deletePost(){
        let accessToken = AppInstance.instance.accessToken ?? ""
        //        let postId = homePostModel?.postID ?? 0
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                DeletePostManager.instance.deletePost(accessToken: accessToken, postId: self.post_id ?? 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.delegate.postDelete(index: self.index ?? 0)
                            //                            self.vc?.navigationController?.popViewController(animated: true)
                            
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
    
    
    func showActionPicker(){
        if self.showPostModel?.showUserProfile?.userId == AppInstance.instance.userId{
            ActionSheetStringPicker.show(withTitle: NSLocalizedString("Post", comment: ""),
                                         rows: [NSLocalizedString("Go To Post", comment: ""),
                                                NSLocalizedString("Report This Post", comment: ""),
                                                NSLocalizedString("Copy", comment: ""),
                                                NSLocalizedString("Delete This Post", comment: "")],
                                         initialSelection: 0,
                                         doneBlock: { (picker, value, index) in
                                            picker?.pickerBackgroundColor  = .white
                                            if value == 0 {
                                                //                                                self.viewModel?.showPost.accept(self.itemObs)
                                            }else if value == 1 {
                                                self.reportPost()
                                            }else if value == 2  {
                                                if self.vc != nil {
                                                    UIPasteboard.general.string = self.showPostModel?.MediaURL
                                                }else if self.vc != nil{
                                                    UIPasteboard.general.string = self.homePostModel?.mediaSet![0].file
                                                }
                                            }else{
                                                self.deletePost()
                                            }
                                            
                                            return
                                            
            }, cancel:  { ActionStringCancelBlock in return }, origin: self)
        }else{
            ActionSheetStringPicker.show(withTitle: NSLocalizedString("Post", comment: ""),
                                         rows: [NSLocalizedString("Go To Post", comment: ""),
                                                NSLocalizedString("Report This Post", comment: ""),
                                                NSLocalizedString("Copy", comment: "")],
                                         initialSelection: 0,
                                         doneBlock: { (picker, value, index) in
                                            picker?.pickerBackgroundColor  = .white
                                            if value == 0 {
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
                                                    let vc = R.storyboard.post.showPostsVC()
                                                    let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.posts, isFollowing: userItem?.following, userId: userItem?.userID,imageString: userItem?.avatar,timeText: item?.timeText,isAdmin: userItem?.admin)
                                                    let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.datumDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
                                                    vc!.object = object
                                                    
                                                    self.vc?.navigationController?.pushViewController(vc!, animated: true)
                                                }
                                            }else if value == 1 {
                                                self.reportPost()
                                            }else {
                                                if self.vc != nil {
                                                    UIPasteboard.general.string = self.showPostModel?.MediaURL
                                                }else if self.vc != nil{
                                                    UIPasteboard.general.string = self.homePostModel?.mediaSet![0].file
                                                }
                                            }
                                            
                                            return
                                            
            }, cancel:  { ActionStringCancelBlock in return }, origin: self)
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
                self.vc?.navigationController?.pushViewController(vc, animated: true)
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
                if self.vc != nil{
                    self.vc?.present(alert, animated: true, completion: nil)
                }
                else if self.hashTagVC != nil{
                    self.hashTagVC?.present(alert, animated: true, completion: nil)
                }
                print("User click Delete button")
            }))
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go to Post", comment: "Go to Post"), style: .default, handler: { (_) in

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
                print(mediaSet)
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
            self.vc?.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
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
    }
    
    
    
    
    @IBAction func More(_ sender: Any) {
        if (self.vc != nil){
            self.showActionSheet(controller: self.vc!)
        }
        else if (self.hashTagVC != nil){
            self.showActionSheet(controller: self.hashTagVC!)
        }
    }
    
    @IBAction func showAllCommentsBtn(_ sender: Any) {
        if self.vc != nil{
            let vc = R.storyboard.post.commentVC()
            //            vc?.postId = showPostModel?.postId ?? 0
            vc?.postId  = self.post_id ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else if  self.hashTagVC != nil{
            let vc = R.storyboard.post.commentVC()
            vc?.postId = hastagModel?.postID ?? 0
            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func Like(_ sender: Any) {
        self.likeDisLike()
    }
    
    @IBAction func Comment(_ sender: Any) {
        if self.vc != nil{
            let vc = R.storyboard.post.commentVC()
            //            vc?.postId = showPostModel?.postId ?? 0
            vc?.postId  = self.post_id ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else if  self.hashTagVC != nil{
            let vc = R.storyboard.post.commentVC()
            vc?.postId = hastagModel?.postID ?? 0
            self.hashTagVC?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func Share(_ sender: Any) {

        
        if self.vc != nil{
            // image to share
            let image = self.imageView1?.image
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.vc!.view
            self.vc!.present(activityViewController, animated: true, completion: nil)
        }else if self.hashTagVC != nil{
            let image = self.imageView1?.image
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.hashTagVC!.view
            self.hashTagVC!.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func Favourite(_ sender: Any) {
        self.favoriteUnFavorite()
    }
    
    @IBAction func LikesCount(_ sender: Any) {
        if self.likesCountBtn.titleLabel?.text == "0"{
            if (self.vc != nil){
                self.vc?.view.makeToast(NSLocalizedString("no likes yet", comment: "no likes yet"))
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
          
        }
    }
    func editPost(text: String) {
         self.captionLabel.text! = text
    }
    
}
