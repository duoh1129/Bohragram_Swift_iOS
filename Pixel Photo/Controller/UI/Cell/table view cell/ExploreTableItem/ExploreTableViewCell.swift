//
//  ExploreTableViewCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/21/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import SDWebImage

class ExploreTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var upperView: UIView!
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ExploreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCell")
        collectionView.register(UINib(nibName: "FeaturedPostCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedPostcell")
        return collectionView
    }()

    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var viewMoreLabel: UILabel!
    
    var explorePostArray = [ExplorePostModel.Datum]()
    var vc: ExploreVC?
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        self.exploreLabel.text = NSLocalizedString("Explore Posts", comment: "Explore Posts")
        self.viewMoreLabel.text = NSLocalizedString("ViewMore", comment: "ViewMore")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.explorePostArray.count > 4 {
            return 5
        }else {
            return self.explorePostArray.count
        }
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
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.clipsToBounds = true
        }
        else{
            cell.videoBtn.isHidden = true
            cell.videoIcon.isHidden = true
            cell.imageView.sd_setImage(with: url, completed: nil)
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.clipsToBounds = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return .init(width: collectionView.frame.width / 1.8, height: collectionView.frame.width / 1.8)
        }else if indexPath.item == 1 {
            let width = collectionView.frame.width / 1.8
            let totalWidth = collectionView.frame.width
            let calulatedWidth = totalWidth - width
            return .init(width: calulatedWidth - 30, height: collectionView.frame.width / 1.8)
        }else {
            return .init(width: (collectionView.frame.width / 3) - 20, height: (collectionView.frame.width / 3) - 20)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
           self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ViewMore(_ sender: Any) {
      let Storyboard = UIStoryboard(name: "Explore", bundle: nil)
      let vc = Storyboard.instantiateViewController(withIdentifier: "ExplorePostController") as! ShowAllExplorePostsController
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
}
