//
//  FavoritesVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 28/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK

class FavoritesVC: BaseVC {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!

    
    private var favoriteArray = [FavoriteModel.Datum]()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
            showImage.tintColor = UIColor.mainColor
        }
        self.title = NSLocalizedString("Favourite", comment: "Favourite")
        self.navigationController?.navigationItem.title = NSLocalizedString("Favourite", comment: "Favourite")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if let tabVC = self.tabBarController as? TabbarController {
                  tabVC.button.isHidden = false
              }
        
    }
    
    func setupUI(){
        
        self.title = NSLocalizedString("Favourite", comment: "Favourite")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.showImage.isHidden = true
        self.showLabel.isHidden = true
      
        self.contentCollectionView.register(UINib(nibName: "PPMosaicGIFItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPMosaicGIFItemCollectionViewCellID")
        self.contentCollectionView.register(UINib(nibName: "PPMosaicVideoItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPMosaicVideoItemCollectionViewCellID")
        self.contentCollectionView.register(UINib(nibName: "PPMosaicImageItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PPMosaicImageItemCollectionViewCellID")
        self.contentCollectionView.register(UINib(nibName: "ExploreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCell")
        self.contentCollectionView.register(UINib(nibName: "FeaturedPostCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedPostcell")
        self.showLabel.text = NSLocalizedString("No Post Yet!", comment: "")
    }
  
    
    private func fetchFavorites(){
        if Connectivity.isConnectedToNetwork(){
            self.favoriteArray.removeAll()
            
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userId = AppInstance.instance.userId ?? 0
            Async.background({
                FavoriteManager.instance.fetchFavorites(accessToken: accessToken, limit: 10, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? [])")
                                self.favoriteArray = success?.data ?? []
                                if self.favoriteArray.isEmpty{
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
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}

extension FavoritesVC : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{

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

    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoriteArray.count ?? 0
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPostcell", for: indexPath) as! FeaturedPostCell
            let index = self.favoriteArray[indexPath.row]
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
        let index = self.favoriteArray[indexPath.row]
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
    
}
