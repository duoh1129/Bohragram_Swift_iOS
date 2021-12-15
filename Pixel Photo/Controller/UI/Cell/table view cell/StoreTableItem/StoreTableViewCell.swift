//
//  StoreTableViewCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/20/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import SDWebImage

class StoreTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var viewMoreLabel: UILabel!
    
    var storePostArray = [[String:Any]]()
    var limitArray = [[String:Any]]()
    var vc: ExploreVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "StoreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "StoreCollectionCell")
        self.storeLabel.text = NSLocalizedString("Store", comment: "Store")
        self.viewMoreLabel.text = NSLocalizedString("ViewMore", comment: "ViewMore")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.limitArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionCell", for: indexPath) as! StoreCollectionCell
        let index = self.limitArray[indexPath.row]
        if let coverImg = index["thumb"] as? String{
            let url = URL(string: coverImg)
            cell.coverImage.sd_setImage(with: url, completed: nil)
        }
        if let cat = index["category_name"] as? String{
            cell.CategoryLabel.text = cat
        }
        if let price = index["sells"] as? Int{
            cell.price.text = "\("$")\(price)"
        }
        if let download = index["downloads"] as? Int{
            cell.downloadLabel.text = "\(download)"
        }
        if let views = index["views"] as? Int{
            cell.views.text = "\(views)\(" Views")"
        }
        cell.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cell.widthAnchor.constraint(equalToConstant: (collectionView.frame.width / 1.5)).isActive = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailsController
        vc.storeDetails = self.limitArray[indexPath.row]
        self.vc?.modalPresentationStyle = .fullScreen
        self.vc?.modalTransitionStyle = .coverVertical
        self.vc?.present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    @IBAction func ViewMore(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreVC") as! StoreController
        vc.storeArray = self.storePostArray
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
}
