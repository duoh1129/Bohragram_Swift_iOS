//
//  UserPostVC.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/30/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Async
import PixelPhotoSDK
class UserPostVC: BaseVC {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    
    var object:ShowUserProfileData?
    public var itemInfo = IndicatorInfo(title: "View")
    private var userDataArray : FetchPostModel.DataClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchUserPostByUserId()
        
    }
    private func setupUI(){
        self.contentCollectionView.register(UINib(nibName: "PPMosaicGIFItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPMosaicGIFItemCollectionViewCellID")
        self.contentCollectionView.register(UINib(nibName: "PPMosaicVideoItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPMosaicVideoItemCollectionViewCellID")
        self.contentCollectionView.register(UINib(nibName: "PPMosaicImageItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPMosaicImageItemCollectionViewCellID")
        self.showLabel.text = NSLocalizedString("There is no UserData", comment: "")
    }
    private func fetchUserPostByUserId(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userid = AppInstance.instance.userId ?? 0
            Async.background({
                FetchPostManager.instance.fetchPostByUserId(accessToken: accessToken, userId: userid, limit: 10, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                self.userDataArray = success?.data ?? nil
                                if (self.userDataArray?.userPosts?.isEmpty)!{
                                    self.showImage.isHidden = false
                                    self.showLabel.isHidden = false
                                    self.contentCollectionView.reloadData()
                                }else{
                                    self.showImage.isHidden = true
                                    self.showLabel.isHidden = true
                                    self.contentCollectionView.reloadData()
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog { self.view.makeToast(sessionError?.errors?.errorText ?? "")
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
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    
}

extension UserPostVC : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 , height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userDataArray?.userPosts!.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.userDataArray?.userPosts![indexPath.row]
        
        if item?.type == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPMosaicVideoItemCollectionViewCellID", for: indexPath) as! PPMosaicVideoItemCollectionViewCell
            cell.bindUserPost(item: item!)
            return cell
        }else if item?.type == "image" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPMosaicImageItemCollectionViewCellID", for: indexPath) as! PPMosaicImageItemCollectionViewCell
            cell.bindUserPost(item: item!)
            return cell
        }else if item?.type == "gif" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPMosaicGIFItemCollectionViewCellID", for: indexPath) as! PPMosaicGIFItemCollectionViewCell
            
            cell.bindUserPost(item: item!, indexPath: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPMosaicImageItemCollectionViewCellID", for: indexPath) as! PPMosaicImageItemCollectionViewCell
        //        cell.bind(item: item)
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.userDataArray?.userPosts![indexPath.row]
        let userItem = self.userDataArray?.userData
        var mediaSet = [String]()
        if (item?.mediaSet!.count)! > 1{
            item?.mediaSet?.forEach({ (it) in
                mediaSet.append(it.file ?? "")
            })
        }
        log.verbose("MediaSet = \(mediaSet)")
        let vc = R.storyboard.post.showPostsVC()
        let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: userItem?.followers, followingCount: userItem?.following, postCount: userItem?.posts, isFollowing: self.userDataArray?.isFollowing, userId: userItem?.userID,imageString: userItem?.avatar,timeText: userItem?.timeText,isAdmin: userItem?.admin)
        let object = ShowPostModel(userId: item?.userID, imageString: item?.avatar, username: item?.username, type: item?.type, timeText: item?.timeText, MediaURL: item?.mediaSet![0].file, likesCount: item?.likes, commentCount: item?.comments?.count, isLiked: item?.isLiked, isSaved: item?.isSaved, showUserProfile: objectToSend,mediaCount:item?.mediaSet?.count,postId: item?.postID,description: item?.userPostDescription,youtube: item?.youtube,MediaUrlsArray:mediaSet)
        vc!.object = object
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
extension UserPostVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
