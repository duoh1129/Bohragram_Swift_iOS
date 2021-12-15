//
//  ShowAllExplorePostsController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/21/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import SDWebImage
import PixelPhotoSDK

class ShowAllExplorePostsController: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var explorePostArray = [ExplorePostModel.Datum]()
    var offset = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "ExploreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCell")
        self.collectionView.register(UINib(nibName: "FeaturedPostCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedPostcell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.fetchExplorePost(limit: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("Explore", comment: "Explore")
//
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    func fetchExplorePost(limit:Int){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                ExplorePostManager.instance.explorePost(accessToken: accessToken, limit: limit, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data?.count ?? 0)")
                                self.explorePostArray = success?.data ?? []
                                print(self.explorePostArray.count)
                                self.collectionView.reloadData()
                                
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
extension ShowAllExplorePostsController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.explorePostArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPostcell", for: indexPath) as! FeaturedPostCell
        let index = self.explorePostArray[indexPath.row]
        let image = index.mediaSet?[0].file
        let url = URL(string: image!)
        let exten = url?.pathExtension
        if exten == "mp4"{
            cell.videoBtn.isHidden = false
            cell.videoIcon.isHidden = false
            let previewURl = index.mediaSet?[0].extra
            let url = URL(string: previewURl ?? "")
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        else{
            cell.videoBtn.isHidden = true
            cell.videoIcon.isHidden = true
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.explorePostArray[indexPath.row]
        let user_data = index.userData
         var mediaSet = [String]()
        if (index.mediaSet?.count ?? 0) > 1{
             index.mediaSet?.forEach({ (it) in
                 mediaSet.append(it.file ?? "")
             })
         }
         log.verbose("MediaSet = \(mediaSet)")
         let vc = R.storyboard.post.showPostsVC()
         let objectToSend = ShowUserProfileData(fname: user_data?.fname, lname: user_data?.lname, username: user_data?.username, aboutMe: user_data?.about, followersCount: 0, followingCount: 0, postCount: user_data?.posts, isFollowing: user_data?.following, userId: user_data?.userID,imageString: user_data?.avatar,timeText: index.timeText,isAdmin: user_data?.admin)
        let object = ShowPostModel(userId: user_data?.userID, imageString: user_data?.avatar, username: user_data?.username, type: index.type, timeText: index.timeText, MediaURL: index.mediaSet![0].file, likesCount: index.likes, commentCount: index.comments?.count, isLiked: index.isLiked, isSaved: index.isSaved, showUserProfile: objectToSend,mediaCount:index.mediaSet?.count,postId: index.postID,description: index.datumDescription,youtube: index.youtube,MediaUrlsArray:mediaSet)
            vc!.object = object
           self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let widht = (collectionWidth / 3) - 10
        return CGSize(width: widht , height: widht)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
