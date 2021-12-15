//
//  UserDetailCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/24/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfileBtn : UIButton!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var followersStack: UIStackView!
    @IBOutlet weak var followingStack: UIStackView!
    @IBOutlet weak var favoriteStack: UIStackView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var favouriteLabel: UILabel!
    @IBOutlet weak var blueTickImageView: RoundImage!
    
    var vc :ProfileVC?
    private var avatarImage:UIImage? = nil
    private let imagePickerController = UIImagePickerController()
    private var imageStatus:Bool? = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let followersTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followersTapped(tapGestureRecognizer:)))
        followersStack.isUserInteractionEnabled = true
        followersStack.addGestureRecognizer(followersTapGestureRecognizer)
        
        let followingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followingTapped(tapGestureRecognizer:)))
        followingStack.isUserInteractionEnabled = true
        followingStack.addGestureRecognizer(followingTapGestureRecognizer)
        
        let favoiriteTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoritesTapped(tapGestureRecognizer:)))
        favoriteStack.isUserInteractionEnabled = true
        favoriteStack.addGestureRecognizer(favoiriteTapGestureRecognizer)
        
        let profileImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(profileImageTapGestureRecognizer)
        self.followersLabel.text = NSLocalizedString("Followers", comment: "Followers")
        self.followingLabel.text = NSLocalizedString("Following", comment: "Following")
        self.favouriteLabel.text = NSLocalizedString("Favourite", comment: "Favourite")
        self.editProfileBtn.setTitle(NSLocalizedString("Edit Profile", comment: "Edit Profile"), for: .normal)
        
    }
    @objc func favoritesTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = R.storyboard.profile.favoritesVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func followersTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = R.storyboard.profile.followersVC()
        vc?.userid = AppInstance.instance.userId ?? 0
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func followingTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = R.storyboard.profile.followingVC()
        vc?.userid = AppInstance.instance.userId ?? 0
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
   @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc?.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imageStatus = false
            self.imagePickerController.delegate = self

            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc?.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
    self.vc?.present(alert, animated: true, completion: nil)

    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    @IBAction func EditProfile(_ sender: Any){
        let vc = R.storyboard.settings.settingsProfileVC()
        vc!.commingFrom = "profile"
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension  UserDetailCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profileImage.image = image
        self.avatarImage  = image ?? nil
        let avatarData = self.avatarImage?.jpegData(compressionQuality: 0.2)
        self.vc?.updateAvatar(imageData: avatarData ??  Data())
        self.vc?.dismiss(animated: true, completion: nil)
    }
}
