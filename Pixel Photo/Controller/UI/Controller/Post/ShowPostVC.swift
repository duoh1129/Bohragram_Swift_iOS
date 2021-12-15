//
//  ShowPostVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 05/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PixelPhotoSDK

class ShowPostVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    
    
    var disposeBag = DisposeBag()
    var object:ShowPostModel?
    var post_height : CGFloat? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.tabBarController?.tabBar.isHidden = true
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        print(self.post_height)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func setupUI(){
        
        self.contentTblView.delegate = self
        self.contentTblView.dataSource = self
        
        self.contentTblView.register(UINib(nibName: "PPYoutubeItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPYoutubeItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPMultiImageItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPMultiImageItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPLinkItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPLinkItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPVideoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPVideoItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPGIFItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPGIFItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPImageItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPImageItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPCollectionViewItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPCollectionViewItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPCommentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPCommentItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PostWithOneImageCell", bundle: nil), forCellReuseIdentifier: "OneImageCell")
    }

}

extension ShowPostVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.viewModel?.item.value == nil {
//            return 0
//        }
//        return (self.viewModel?.item.value!.comments?.count)! + 1
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //self.contentIndexPath = indexPath
        
//        if indexPath.row == 0 {
            if self.object?.type == "video" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPVideoItemTableViewCellID") as! PPVideoItemTableViewCell
                cell.bind(item: object!)
                self.contentTblView.estimatedRowHeight = 550
                self.contentTblView.rowHeight = UITableView.automaticDimension
                cell.vc = self
                return cell
            }else if self.object?.type == "image" {
                
                if (self.object?.mediaCount ?? 0) > 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPMultiImageItemTableViewCellID") as! PPMultiImageItemTableViewCell
                cell.bind(item: object!)
                cell.vc = self
                cell.imageCollectionView.reloadData()
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PPImageItemTableViewCellID") as! PPImageItemTableViewCell
//                 cell.heightConstraint.constant = 0.0
//                  cell.heightConstraint.constant = self.post_height ?? 0.0
                   cell.bind(item: object!)
                   print(self.post_height ?? "dwdew","Height")
//                   cell.height = self.post_height ?? 0.0
                   cell.vc = self
//                    self.contentTblView.estimatedRowHeight = 550
                    self.contentTblView.rowHeight = UITableView.automaticDimension
                    return cell
                }
                
            }else if self.object?.type == "gif" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPImageItemTableViewCellID") as! PPImageItemTableViewCell
                cell.bind(item: object!)
                cell.height = self.post_height ?? 0.0
                self.contentTblView.rowHeight = UITableView.automaticDimension
                cell.vc = self
                return cell
            }
            else if (self.object?.type == "youtube"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPYoutubeItemTableViewCellID") as! PPYoutubeItemTableViewCell
                cell.bind(item: object!)
                cell.vc = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPImageItemTableViewCellID") as! PPImageItemTableViewCell
                 cell.bind(item: object!)
                 cell.vc = self
                 return cell
            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//            UITableView.automaticDimension
    }
    
}

