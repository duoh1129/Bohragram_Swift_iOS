//
//  MyDownloadsVC.swift
//  Pixel Photo
//
//  Created by Abdul Moid on 16/04/2021.
//  Copyright © 2021 Olivin Esguerra. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyDownloadsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: RoundButton!
    
    var storeArray = [[String:Any]]()
    var isStore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.backgroundColor = UIColor.mainColor
        self.collectionView.register(UINib(nibName: "StoreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "StoreCollectionCell")
        self.collectionView.register(UINib(nibName: "AllStoreCells", bundle: nil), forCellWithReuseIdentifier: "AllStorecells")
        self.collectionView.register(UINib(nibName: "NoStoreCell", bundle: nil), forCellWithReuseIdentifier: "NoStoreCells")
        self.isStore = false
        self.collectionView.reloadData()
    }
        
    @IBAction func CreateStore(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CreateStoreVC") as! CreateStoreController
        self.present(vc, animated: true, completion: nil)
    }
}

extension MyDownloadsVC: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isStore == true{
            return storeArray.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isStore == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllStorecells", for: indexPath) as! AllStoreCells
            //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionCell", for: indexPath) as! StoreCollectionCell
            let index = self.storeArray[indexPath.row]
            if let coverImg = index["thumb"] as? String{
                let url = URL(string: coverImg)
                cell.coverImage.sd_setImage(with: url, completed: nil)
            }
            if let cat = index["category_name"] as? String{
                cell.categoryLabel.text = cat
            }
            if let price = index["sells"] as? Int{
                cell.price.text = "\("$")\(price)"
            }
            if let title = index["title"] as? String{
                cell.title.text = title
            }
            if let price = index["license_options"] as? [String : Any]{
                for value in Array(price) {
                    cell.price.text = ("\(value.key) $ \(value.value)")
                }
            }
            cell.layer.cornerRadius = 20
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoStoreCells", for: indexPath) as! NoStoreCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isStore == true{
            let collectionWidth = collectionView.frame.size.width
            let widht = collectionWidth / 2
            return CGSize(width: self.collectionView.frame.width , height: 230.0)
        }
        else{
            return CGSize(width: self.collectionView.frame.width , height: self.collectionView.frame.height)
        }
        //         return CGSize(width: widht , height: 210)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailsController
        vc.storeDetails = self.storeArray[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MyDownloadsVC: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Download")
    }
}


