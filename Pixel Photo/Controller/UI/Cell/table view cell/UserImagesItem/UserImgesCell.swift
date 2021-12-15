//
//  UserImgesCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/25/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class UserImgesCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DeletePostDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userPosts =  [FetchPostModel.UserPost]()
    var vc : ProfileVC?
    
    var isPost = 1
    var isGrid = 1
    var isList = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ExploreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCell")
        self.collectionView.register(UINib(nibName: "NoPostCell", bundle: nil), forCellWithReuseIdentifier: "NoPostcell")
        self.collectionView.register(UINib(nibName: "PostWithImageCell", bundle: nil),forCellWithReuseIdentifier: "postImageCell")
        self.collectionView.register(UINib(nibName: "PostWithTwoImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TwoImageCollectionCell")
        self.collectionView.register(UINib(nibName: "PostWithThreeImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ThreeImageCollectionCell")
        self.collectionView.register(UINib(nibName: "PostWithFourImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FourImageCollectionCell")
        self.collectionView.register(UINib(nibName: "PostWithOneImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "postOneImageCollectionCell")
        self.collectionView.register(UINib(nibName: "FeaturedPostCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedPostcell")
        self.collectionView.register(UINib(nibName: "VideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionCells")
        self.collectionView.showsVerticalScrollIndicator = false
    }
    
    func postDelete(index: Int) {
          self.userPosts.remove(at: index)
        self.collectionView.reloadData()
      }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isPost == 0{
            return 1
        }
        else{
            return self.userPosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isPost == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPostcell", for: indexPath) as! NoPostCell
            return cell
        }
        else{
            if self.isGrid == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPostcell", for: indexPath) as! FeaturedPostCell
                let index = self.userPosts[indexPath.row]
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
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCell", for: indexPath) as! ExploreCollectionCell
//                let index = self.userPosts[indexPath.row]
//                let image = index.mediaSet?[0].file
//                let url = URL(string: image!)
//                cell.imageView.sd_setImage(with: url, completed: nil)
//                return cell
            }
            else{
                 let index = self.userPosts[indexPath.row]
                if (index.type == "image"){
                if (index.mediaSet?.count ?? 0) == 2{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoImageCollectionCell", for: indexPath) as! PostWithTwoImageCollectionCell
                    cell.post_id = index.postID ?? 0
                    cell.delegate = self
                    cell.vc = self.vc
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else if (index.mediaSet?.count ?? 0) == 3{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThreeImageCollectionCell", for: indexPath) as! PostWithThreeImageCollectionCell
                    cell.post_id = index.postID ?? 0
                     cell.delegate = self
                    cell.vc = self.vc
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else if(index.mediaSet?.count ?? 0) == 4{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourImageCollectionCell", for: indexPath) as! PostWithFourImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.vc = self.vc
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else if (index.mediaSet?.count ?? 0) == 1{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postOneImageCollectionCell", for: indexPath) as! PostWithOneImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.vc = self.vc
                    cell.bind(object: index, index: indexPath.row)
                    return cell
              }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourImageCollectionCell", for: indexPath) as! PostWithFourImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.vc = self.vc
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                    }
                }
                else if (index.type == "video"){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionCells", for: indexPath) as! VideoCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.vc = self.vc
                    cell.bind(item: index, index: indexPath.row)
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postOneImageCollectionCell", for: indexPath) as! PostWithOneImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.vc = self.vc
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isPost == 0{
            return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
        }
        else{
            if self.isGrid == 1{
                let collectionWidth = collectionView.frame.size.width - 10
                let widht = (collectionWidth / 3)
                return CGSize(width: widht , height: widht)
            }
            else{
                let index = self.userPosts[indexPath.row]
                if (index.type == "image"){
                if (index.mediaSet?.count ?? 0) == 2{
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 385.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 345.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 390.0)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 330.0)
                    }
                }
                else if (index.mediaSet?.count ?? 0) == 3{
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 400.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 345.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 410.0)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 330.0)
                    }
        
                }
                else if ((index.mediaSet?.count ?? 0) == 4){
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 445.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 425.0)
                        //Ok
                    }
                }
                else if ((index.mediaSet?.count ?? 0) == 1){
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 350.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 337.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                    return CGSize(width: collectionView.frame.width, height: 370.0)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 320.0)
                    }
                }
                else{
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 445.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 425.0)
                        //Ok
                    }
                 }
                }
                else if (index.type == "video"){
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                          return CGSize(width: collectionView.frame.width, height: 400.0)
                      }
                      else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 555.0)
                        //Done
                      }
                      else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                          return CGSize(width: collectionView.frame.width, height: 600.0)
                        //Done
                      }
                      else{
                          return CGSize(width: collectionView.frame.width, height: 550.0)
                        //Done
                      }
                }
                else{
                    return CGSize(width: collectionView.frame.width, height: 370.0)

                }

            }
        }
    }
    

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             if (self.isGrid == 1){
                let index = self.userPosts[indexPath.row]
                let userItem = index.userData
                 var mediaSet = [String]()
                if (index.mediaSet!.count) > 1{
                    index.mediaSet?.forEach({ (it) in
                         mediaSet.append(it.file ?? "")
                     })
                 }
    
                let vc = R.storyboard.post.showPostsVC()
                let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.postsCount, isFollowing: true, userId: userItem?.userID,imageString: userItem?.avatar,timeText: index.timeText,isAdmin: userItem?.admin)
                let object = ShowPostModel(userId: index.userID, imageString: index.avatar, username: index.username, type: index.type, timeText: index.timeText, MediaURL: index.mediaSet![0].file, likesCount: index.likes, commentCount: index.comments?.count, isLiked: index.isLiked, isSaved: index.isSaved, showUserProfile: objectToSend,mediaCount:index.mediaSet?.count,postId: index.postID,description: index.userPostDescription,youtube: index.youtube,MediaUrlsArray: mediaSet)
                 vc!.object = object
                self.vc?.navigationController?.pushViewController(vc!, animated: true)
    
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    @IBAction func Add(_ sender: Any) {
        self.vc?.tabBarController?.selectedIndex = 2
    }
    @IBAction func Grid(_ sender: Any) {
        self.isList = 0
        self.isGrid = 1
        self.collectionView.reloadData()
        print("Grid")
    }
    @IBAction func List(_ sender: Any) {
        self.isList = 1
        self.isGrid = 0
        self.collectionView.reloadData()
        print("List")
    }
    
    
    
}
