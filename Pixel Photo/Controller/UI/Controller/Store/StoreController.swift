//
//  StoreController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/21/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
import XLPagerTabStrip

class StoreController: BaseVC,storeFilterDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: RoundButton!
    
    var storeArray = [[String:Any]]()
    var isStore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Store", comment: "Store")
        
        self.navigationController?.navigationItem.title = "Explore"
        
        self.collectionView.register(UINib(nibName: "StoreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "StoreCollectionCell")
        self.collectionView.register(UINib(nibName: "AllStoreCells", bundle: nil), forCellWithReuseIdentifier: "AllStorecells")
        self.collectionView.register(UINib(nibName: "NoStoreCell", bundle: nil), forCellWithReuseIdentifier: "NoStoreCells")
        
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        //        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem =
            UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "abacus"), style: .plain, target: self, action: #selector(self.Filter(sender:)))
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        addButton.backgroundColor = UIColor.mainColor
    }
    
    private func getStore(searchTitle:String,searchTags:String,searchCat:String,searchLicense:String,searchMin:String,searchMax:String,offset:Int){
        GetExploreAllStoreManager.sharedInstance.getAllStroe(searchTitle: searchTitle, searchTags: searchTags, searchCat: searchCat, searchLicense: searchLicense, searchMin: searchMin, searchMax: searchMax, offset: offset) { (success, authError, error) in
            if Connectivity.isConnectedToNetwork(){
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            for i in success!.data{
                                self.storeArray.append(i)
                            }
                            if self.storeArray.isEmpty == true{
                                self.isStore = false
                            }
                            else{
                                self.isStore = true
                            }
                            print(self.storeArray)
                            self.collectionView.reloadData()
                        }
                    })
                }
                else if authError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(authError?.errors?.errorText ?? "")
                            log.error("sessionError = \(authError?.errors?.errorText ?? "")")
                        }
                    })
                }
                else if error != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            log.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
            else{
                self.dismissProgressDialog {
                    log.error("internetError = \(InterNetError)")
                    self.view.makeToast(InterNetError)
                }
            }
        }
    }
    
    func filter(title: String, tag: String, category: Int, license: String, price_Min: String, price_Max: String) {
        print(title,tag,category,license,price_Min,price_Max)
        self.storeArray.removeAll()
        self.collectionView.reloadData()
        self.showProgressDialog(text: "Loading")
        self.getStore(searchTitle: title, searchTags: tag, searchCat: "\(category)", searchLicense: license, searchMin: price_Min, searchMax: price_Max, offset: 0)
    }
    
    
    @IBAction func CreateStore(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CreateStoreVC") as! CreateStoreController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Filter(sender:UIBarButtonItem){
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreFilterVC") as! StoreFilterController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}
extension StoreController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
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

extension StoreController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Store")
    }
}
