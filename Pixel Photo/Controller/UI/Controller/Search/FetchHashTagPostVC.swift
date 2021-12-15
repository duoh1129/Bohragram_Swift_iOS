//
//  FetchHashTagPostVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 23/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Async
import PixelPhotoSDK

class FetchHashTagPostVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    private var postHashArray = [PostByHashTagModel.Datum]()
    
    var contentIndexPath : IndexPath?
    var shouldRefreshStories = false
    var isVideo = false
    private var refreshControl = UIRefreshControl()
    var hashString:String? = ""
    
    var pageNo:Int = 1
    var limit:Int = 20
    var offset:Int = 1 //pageNo*limit
    var isDataLoading:Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchHomePost(limit: self.limit, Offset: 1)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = false
       
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        let vc = R.storyboard.chat.chatListVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func setupUI(){
        self.title = "HashTag"
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        self.contentTblView.estimatedRowHeight = 400
        self.contentTblView.register(UINib(nibName: "PPYoutubeItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPYoutubeItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPMultiImageItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPMultiImageItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPLinkItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPLinkItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPVideoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPVideoItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPGIFItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPGIFItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPImageItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPImageItemTableViewCellID")
        
        self.contentTblView.register(UINib(nibName: "PostWithTwoImage", bundle: nil), forCellReuseIdentifier: "TwoImageCell")
        self.contentTblView.register(UINib(nibName: "PostWithThreeImage", bundle: nil), forCellReuseIdentifier: "ThreeImageCell")
        self.contentTblView.register(UINib(nibName: "PostWithFourImage", bundle: nil), forCellReuseIdentifier: "FourImageCell")
        self.contentTblView.register(UINib(nibName: "PostWithOneImageCell", bundle: nil), forCellReuseIdentifier: "OneImageCell")
        
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        contentTblView.addSubview(refreshControl)
        
    }
    @objc func refresh(sender:AnyObject) {
        self.postHashArray.removeAll()
        self.contentTblView.reloadData()
        
        self.fetchHomePost(limit: self.limit, Offset: 1)
        
        refreshControl.endRefreshing()
        
    }
    
    private func fetchHomePost(limit:Int,Offset:Int){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let hashStr = self.hashString ?? ""
            Async.background({
                PostByHashManager.instance.fetchPostByHash(accessToken: accessToken, hash: hashStr, limit: limit, Offset: Offset, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? [])")
                                self.postHashArray = success?.data ?? []
                                self.contentTblView.reloadData()
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog { self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}


extension FetchHashTagPostVC : UITableViewDataSource, UITableViewDelegate,DeletePostDelegate {
    func postDelete(index: Int) {
        self.postHashArray.remove(at: index)
        self.contentTblView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postHashArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.contentIndexPath = indexPath
        let object = self.postHashArray[indexPath.row]
        if object.type == "video" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PPVideoItemTableViewCellID") as! PPVideoItemTableViewCell
            cell.hashTagBinding(item: object, index: indexPath.row)
            cell.hashTagVC = self
            return cell
        }
        if object.type == "image" {
            if (object.mediaSet?.count ?? 0) == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoImageCell", for: indexPath) as! PostWithTwoImage
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.hashTagVC = self
                cell.hashTagBinding(item: object, index: indexPath.row)
                //                bind(object: object, index: indexPath.row)
                self.contentTblView.estimatedRowHeight = 348.0
                self.contentTblView.rowHeight = UITableView.automaticDimension
                return cell
            }
            else if (object.mediaSet?.count ?? 0) == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeImageCell", for: indexPath) as! PostWithThreeImage
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.hashTagVC = self
                cell.hashTagBinding(item: object, index: indexPath.row)
                self.contentTblView.estimatedRowHeight = 362.0
                self.contentTblView.rowHeight = UITableView.automaticDimension
                return cell
            }
            else if (object.mediaSet?.count ?? 0) == 4{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FourImageCell", for: indexPath) as! PostWithFourImage
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.hashTagVC = self
                cell.hashTagBinding(item: object, index: indexPath.row)
                self.contentTblView.estimatedRowHeight = 390.0
                self.contentTblView.rowHeight = UITableView.automaticDimension
                return cell
            }
            else if (object.mediaSet?.count ?? 0) == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell") as! PostWithOneImageCell
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.hashTagVC = self
                cell.hashTagBinding(item: object, index: indexPath.row)
                self.contentTblView.estimatedRowHeight = 337.0
                self.contentTblView.rowHeight = UITableView.automaticDimension
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FourImageCell", for: indexPath) as! PostWithFourImage
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.hashTagVC = self
                cell.hashTagBinding(item: object, index: indexPath.row)
                self.contentTblView.estimatedRowHeight = 390.0
                self.contentTblView.rowHeight = UITableView.automaticDimension
                return cell
            }
        }
        
        if object.type == "gif" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell") as! PostWithOneImageCell
            cell.post_id = object.postID ?? 0
            cell.delegate = self
            cell.hashTagVC = self
            cell.hashTagBinding(item: object, index: indexPath.row)
            self.contentTblView.estimatedRowHeight = 337.0
            self.contentTblView.rowHeight = UITableView.automaticDimension
            return cell
        }
        else if (object.type == "youtube"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PPYoutubeItemTableViewCellID") as! PPYoutubeItemTableViewCell
            cell.post_id = object.postID ?? 0
            cell.hashtagBinding(item: object, index:  indexPath.row)
            cell.delegate = self
            cell.hashTagVC = self
            self.contentTblView.estimatedRowHeight = 400.0
            self.contentTblView.rowHeight = UITableView.automaticDimension
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell") as! PostWithOneImageCell
              cell.post_id = object.postID ?? 0
              cell.delegate = self
              cell.hashTagVC = self
              cell.hashTagBinding(item: object, index: indexPath.row)
              self.contentTblView.estimatedRowHeight = 337.0
              self.contentTblView.rowHeight = UITableView.automaticDimension
              return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
    }
    
}
extension FetchHashTagPostVC{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((contentTblView.contentOffset.y + contentTblView.frame.size.height) >= contentTblView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.offset + 1
                for i in 1...2{
                    self.fetchHomePost(limit: self.limit, Offset: self.offset)
                }
            }
        }
    }
}
