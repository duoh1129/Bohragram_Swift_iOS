//
//  FeaturePostItem.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/28/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class FeaturePostItem: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var featuredLabel: UILabel!
    
    var featuredPost = [[String:Any]]()
    var vc: ExploreVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "FeaturedPostCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedPostcell")
        self.featuredLabel.text = NSLocalizedString("Featured Posts", comment: "Featured Posts")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.featuredPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPostcell", for: indexPath) as! FeaturedPostCell
        let index = self.featuredPost[indexPath.row]
        if let files = index["media_set"] as? [[String:Any]]{
            if let image = files[0]["file"] as? String{
                let url = URL(string: image)
                let exten = url?.pathExtension
                if exten == "mp4"{
                    cell.videoBtn.isHidden = false
                    cell.videoIcon.isHidden = false
                    if  let previewURl = files[0]["extra"] as? String{
                        let url = URL(string: previewURl ?? "")
                        cell.imageView.sd_setImage(with: url, completed: nil)
                    }
                   
                }
                else{
                    cell.videoBtn.isHidden = true
                    cell.videoIcon.isHidden = true
                    cell.imageView.sd_setImage(with: url, completed: nil)
                }

            }
        
        }
//        cell.heightAnchor.constraint(equalToConstant: 210).isActive = true
//        cell.widthAnchor.constraint(equalToConstant: collectionView.frame.width).isActive = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 10 , height: 210.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.featuredPost[indexPath.row]
        print(index)
        let user_data = index["user_data"] as? [String:Any]
        print(user_data)

        var mediaSet = [String]()
        var media_file = ""
        
        if let media_set = index["media_set"] as? [[String:Any]]{
            
            media_file = media_set[0]["file"] as! String
             print(media_file)
            if (media_set.count > 1){
//                for i in media_set
                media_set.forEach { (it) in
                    mediaSet.append(it["file"] as! String)
                }
            }
        }
//        if (index.mediaSet!.count)! > 1{
        
        
//            index.mediaSet?.forEach({ (it) in
//                mediaSet.append(it.file ?? "")
//            })
//        }
        log.verbose("MediaSet = \(mediaSet)")
        let vc = R.storyboard.post.showPostsVC()
        let objectToSend = ShowUserProfileData(fname: user_data?["fname"] as! String, lname: user_data?["lname"] as! String, username: user_data?["uname"] as! String, aboutMe: user_data?["about"] as! String, followersCount: 0, followingCount: 0, postCount: user_data?["posts"] as! Int, isFollowing: user_data?["following"] as! Bool, userId: user_data?["user_id"] as! Int,imageString: user_data?["avatar"] as! String,timeText: index["time_text"] as! String,isAdmin: user_data?["admin"] as! Int)
        let object = ShowPostModel(userId: user_data?["user_id"] as! Int, imageString: user_data?["avatar"] as! String, username: user_data?["username"] as! String, type: index["type"] as! String, timeText: index["time_text"] as! String, MediaURL: media_file, likesCount: index["likes"] as! Int, commentCount: index["votes"] as! Int, isLiked: index["is_liked"] as! Bool, isSaved: index["is_saved"] as! Bool, showUserProfile: objectToSend,mediaCount: mediaSet.count,postId: index["post_id"] as! Int,description: index["description"] as! String,youtube: index["youtube"] as! String, MediaUrlsArray:mediaSet)
        print(object)
        vc!.object = object
        
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
}
