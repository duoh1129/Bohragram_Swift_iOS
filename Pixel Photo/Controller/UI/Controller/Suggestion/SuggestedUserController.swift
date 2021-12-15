//
//  SuggestedUserController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/21/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK

class SuggestedUserController: BaseVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
   var suggestedUsersArray = [SuggestedUserModel.Datum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "UserSuggestionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "UserSuggestionCollectionCell")
        self.fetchUserSuggestions()
        self.title = NSLocalizedString("Suggested User", comment: "Suggested User")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    private func fetchUserSuggestions(){
        if appDelegate.isInternetConnected{
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                SuggestedUserManager.instance.getsuggestedUser(accessToken: accessToken, limit: 30, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.suggestedUsersArray = success?.data ?? []
                            self.collectionView.reloadData()
                            self.dismissProgressDialog {
                                print("Dismiss")
                            }
//                            self.fetchExplorePost(limit: self.limit)
                        })
                    }else if sessionError != nil{
                        Async.main({
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                            self.view.makeToast(error?.localizedDescription ?? "")
                        })
                    }
                })
            })
        }else{
            log.error(InterNetError)
            self.view.makeToast(InterNetError)
        }
    }
    
}

extension SuggestedUserController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.suggestedUsersArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserSuggestionCollectionCell", for: indexPath) as! UserSuggestionCollectionCell
        let index = self.suggestedUsersArray[indexPath.row]
//           cell.vc1 = self
           cell.userId = index.userID ?? 0
           cell.userNameLbl.text = index.username ?? ""
           cell.profileNameLbl.text = index.name ?? ""
           let url = URL.init(string:index.avatar ?? "")
           log.verbose("userId = \(index.userID ?? 0 )")
           cell.profileImgView.sd_setImage(with: url , placeholderImage:R.image.img_profile_placeholder())
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.storyboard.post.showUserProfileVC()
        let index = self.suggestedUsersArray[indexPath.row]
        print(index.userID)
        vc?.privacy = index.pPrivacy ?? ""
               vc?.gender = index.gender ?? ""
               vc?.descriptionString = index.about ?? ""
               vc?.email = index.email ?? ""
               vc?.businessAccount = index.businessAccount ?? 0
        vc?.user_id = index.userID ?? 0
        let objectToSend = ShowUserProfileData(fname: index.fname, lname: index.lname, username: index.username, aboutMe: index.about, followersCount: index.followers, followingCount: index.following, postCount: index.posts, isFollowing: false, userId: index.userID,imageString: index.avatar,timeText: index.timeText,isAdmin: index.admin)
        vc!.object = objectToSend
        self.navigationController?.pushViewController(vc!, animated: true)
      
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let widht = (collectionWidth / 3)
        return CGSize(width: widht , height: 155.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10.0
    }
    
}
