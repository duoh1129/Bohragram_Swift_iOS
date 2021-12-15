//
//  PPHorizontalCollectionviewItemTableViewCell.swift
//  Pixel Photo
//
//  Created by DoughouzLight on 08/01/2019.
//  Copyright © 2019 DoughouzLight. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import PixelPhotoSDK

class PPHorizontalCollectionviewItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLblHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var suggestionLbl: UILabel!
    
    @IBOutlet weak var viewMoreLabel: UILabel!
    
    var viewModel : Any?
    var currentIndexPath : IndexPath?
    var vc:ExploreVC?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.suggestionLbl.text = NSLocalizedString("Suggestion for you", comment: "")
        self.viewMoreLabel.text = NSLocalizedString("ViewMore", comment: "ViewMore")
        self.horizontalCollectionView.delegate = self
        self.horizontalCollectionView.dataSource = self
        
        self.horizontalCollectionView.register(R.nib.userSuggestionCollectionCell(), forCellWithReuseIdentifier: R.reuseIdentifier.userSuggestionCollectionCell.identifier)
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    @IBAction func ViewMore(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "SuggestedUser", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SuggestedUserVC") as! SuggestedUserController
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
    
extension PPHorizontalCollectionviewItemTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        
        return self.vc!.suggestedUsersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.currentIndexPath = indexPath
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.userSuggestionCollectionCell.identifier, for: indexPath) as! UserSuggestionCollectionCell
        let object = self.vc!.suggestedUsersArray[indexPath.row]
        cell.vc1 = self
        cell.userId = object.userID ?? 0
        cell.userNameLbl.text = object.username ?? ""
        cell.profileNameLbl.text = object.name ?? ""
        let url = URL.init(string:object.avatar ?? "")
        log.verbose("userId = \(object.userID ?? 0 )")
        cell.profileImgView.sd_setImage(with: url , placeholderImage:R.image.img_profile_placeholder())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.storyboard.post.showUserProfileVC()
        let object = self.vc!.suggestedUsersArray[indexPath.row]
        vc?.privacy = object.pPrivacy ?? ""
               vc?.gender = object.gender ?? ""
               vc?.descriptionString = object.about ?? ""
               vc?.email = object.email ?? ""
               vc?.businessAccount = object.businessAccount ?? 0
        let objectToSend = ShowUserProfileData(fname: object.fname, lname: object.lname, username: object.username, aboutMe: object.about, followersCount: object.followers, followingCount: object.following, postCount: object.posts, isFollowing: false, userId: object.userID,imageString: object.avatar,timeText: object.timeText,isAdmin: object.admin)
        vc!.object = objectToSend
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
      
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 155.0)
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
    
}
