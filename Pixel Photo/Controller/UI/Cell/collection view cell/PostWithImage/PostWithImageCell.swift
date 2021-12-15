//
//  PostWithImageCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/28/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class PostWithImageCell: UICollectionViewCell {
    
    
    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var postImage: RoundImage!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(object: FetchPostModel.UserPost){
        self.profileName.text = object.name
        let pro_image = object.avatar!
        let url1 = URL(string: pro_image)
        self.profileImage.sd_setImage(with: url1, completed: nil)
        self.timeLabel.text = object.timeText
        if object.isLiked == true{
            self.likeBtn.setImage(UIImage(named: "Heart"), for: .normal)
        }
        else{
            self.likeBtn.setImage(UIImage(named: "Heart1"), for: .normal)
        }
        if object.isSaved == true{
            self.saveBtn.setImage(UIImage(named: "Star2"), for: .normal)
        }
        else{
            self.saveBtn.setImage(UIImage(named: "Star1"), for: .normal)
        }
    }
    
    
    @IBAction func Like(_ sender: Any) {
    }
    
    @IBAction func Comment(_ sender: Any) {
    }
    
    @IBAction func Share(_ sender: Any) {
    }
    
    @IBAction func Save(_ sender: Any) {
    }
}
