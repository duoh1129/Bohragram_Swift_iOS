//
//  FundingTableItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/28/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class FundingTableItem: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fundingLabel: UILabel!
    var fundingArray = [FetchFundingModel.Datum]()
    
    @IBOutlet weak var promotedLbl: UILabel!
    @IBOutlet weak var viewMoreLbl: UILabel!
    var vc:HomeVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fundingLabel.text = NSLocalizedString("Funding", comment: "Funding")
        self.viewMoreLbl.text = NSLocalizedString("ViewMore", comment: "ViewMore")
        self.promotedLbl.text = NSLocalizedString("Promoted", comment: "Promoted")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        collectionView.register(R.nib.fundingCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.fundingCollectionItem.identifier)
    }
    func configure(_ object: [FetchFundingModel.Datum] ){
        self.fundingArray = object
        self.collectionView.reloadData()
    }
    
    @IBAction func viewFundingMorePressed(_ sender: Any) {
        let vc = R.storyboard.funding.showFundingVC()
//        vc?.fundingArray  = self.fundingArray
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension FundingTableItem:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fundingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.fundingCollectionItem.identifier, for: indexPath) as? FundingCollectionItem
        let object = self.fundingArray[indexPath.row]
        cell?.bind(object)
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.storyboard.funding.showFundingDetailsVC()
        vc!.dataObject = self.fundingArray[indexPath.row]
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       }
       
       func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       
       func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       
    
    
}
