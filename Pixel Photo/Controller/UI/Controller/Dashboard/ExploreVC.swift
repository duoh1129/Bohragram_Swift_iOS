//
//  ExploreVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 03/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
import GoogleMobileAds
import XLPagerTabStrip

class ExploreVC: BaseVC {
    

    @IBOutlet weak var contentTblView: UITableView!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var vc : ExploreVC!
    var currentIndexPath : CGFloat?
    var suggestedUsersArray = [SuggestedUserModel.Datum]()
    var explorePostArray = [ExplorePostModel.Datum]()
    var storePosts = [[String:Any]]()
    var storelimitArray = [[String:Any]]()
    var featuredPost = [[String:Any]]()
    var isDataLoading:Bool=false
    private var refreshControl = UIRefreshControl()
    
    var pageNo:Int=1
    var limit:Int = 9
    var offset:Int=0 //pageNo*limit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        print(AppInstance.instance.userId)
        self.fetchUserSuggestions()
        self.getStore(searchTitle: "", searchTags: "", searchCat: "", searchLicense: "", searchMin: "", searchMax: "", offset: 0)
        self.fetchFeaturedPost()
    }
    
    func setupUI(){
        self.navigationController?.isNavigationBarHidden = false
        
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("Search", comment: "Search")
        navigationItem.titleView = searchBar
        
        self.contentTblView.register(UINib(nibName: "PPHorizontalCollectionviewItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPHorizontalCollectionviewItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "VerticalCollectionviewItemTableViewCell", bundle: nil), forCellReuseIdentifier: "VerticalCollectionviewItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreTableCell")
        self.contentTblView.register(UINib(nibName: "ExploreTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreTableCell")
        self.contentTblView.register(UINib(nibName: "FeaturePostItem", bundle: nil), forCellReuseIdentifier: "FeaturePostTableCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        contentTblView.addSubview(refreshControl)
        
        //        if ControlSettings.shouldShowAddMobBanner{
        //
        //            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //            addBannerViewToView(bannerView)
        //            bannerView.adUnitID = ControlSettings.addUnitId
        //            bannerView.rootViewController = self
        //            bannerView.load(GADRequest())
        //            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
        //            let request = GADRequest()
        //            interstitial.load(request)
        //        }
        /////////////////////////////////////
        
    }
    
    @objc func refresh(sender:AnyObject) {
        self.limit = 30
        self.offset = 0
        self.suggestedUsersArray.removeAll()
        self.explorePostArray.removeAll()
        self.contentTblView.reloadData()
        self.fetchUserSuggestions()
        refreshControl.endRefreshing()
        
    }
    @IBAction func showStore(){
        print("Shit To Store Screen")
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "dashboard") as! BarButtonDashBoardVC
        vc.storePosts = self.storePosts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func reloadDataAndView(){
        let contentOffset = self.contentTblView.contentOffset
        self.contentTblView.reloadData()
        self.contentTblView.layoutIfNeeded()
        self.contentTblView.setContentOffset(contentOffset, animated: false)
    }
    private func fetchUserSuggestions(){
        if appDelegate.isInternetConnected{
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                SuggestedUserManager.instance.getsuggestedUser(accessToken: accessToken, limit: 20, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.suggestedUsersArray = success?.data ?? []
                            self.contentTblView.reloadData()
                            self.fetchExplorePost(limit: self.limit)
                        })
                    }else if sessionError != nil{
                        Async.main({
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                            self.view.makeToast(error?.localizedDescription ?? "")
                        })
                    }
                })
            })
        }else{
            log.error(InterNetError)
            self.view.makeToast(InterNetError)
        }
    }
    func fetchExplorePost(limit:Int){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                ExplorePostManager.instance.explorePost(accessToken: accessToken, limit: limit, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data?.count ?? 0)")
                                self.explorePostArray = success?.data ?? []
                                print(self.explorePostArray.count)
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
                                self.view.makeToast(error?.localizedDescription ?? "")
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
    private func getStore(searchTitle:String,searchTags:String,searchCat:String,searchLicense:String,searchMin:String,searchMax:String,offset:Int){
        return
        GetExploreAllStoreManager.sharedInstance.getAllStroe(searchTitle: searchTitle, searchTags: searchTags, searchCat: searchCat, searchLicense: searchLicense, searchMin: searchMin, searchMax: searchMax, offset: offset) { (success, authError, error) in
            if Connectivity.isConnectedToNetwork(){
                if success != nil{
                    Async.main({
                        self.storePosts = success!.data
                        var count = 0
                        for i in self.storePosts{
                            count += 1
                            if count == 8{
                                break
                            }
                            else{
                                self.storelimitArray.append(i)
                            }
                            
                        }
                        print(self.storePosts.count)
                        self.contentTblView.reloadData()
                    })
                }
                else if authError != nil{
                    Async.main({
                        self.view.makeToast(authError?.errors?.errorText ?? "")
                        log.error("sessionError = \(authError?.errors?.errorText ?? "")")
                    })
                }
                else if error != nil{
                    Async.main({
                        self.view.makeToast(error?.localizedDescription ?? "")
                        log.error("error = \(error?.localizedDescription ?? "")")
                        
                    })
                }
            }
            else{
                log.error("internetError = \(InterNetError)")
                self.view.makeToast(InterNetError)
            }
        }
    }
    
    private func fetchFeaturedPost(){
        var index = 0
        if Connectivity.isConnectedToNetwork(){
            Async.main({
                GetFeaturePostManager.SharedInstance.getFeaturePost(offset: "") { (success, authError, error) in
                    if (success != nil){
                        for i in success!.data{
                            if index != 6{
                                self.featuredPost.append(i)
                                index += 1
                                print("Nothing")
                            }
                            else{
                                break;
                            }
                        }
                        self.contentTblView.reloadData()
                        print(self.featuredPost)
                        print(self.featuredPost.count)
                    }
                    else if (authError != nil){
                        self.view.makeToast(authError?.errors?.errorText ?? "")
                    }
                    else if (error != nil){
                        self.view.makeToast(error?.localizedDescription)
                        
                    }
                    
                }
            })
        }
        
    }
    
}
extension ExploreVC : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.tintColor = .white
        searchBar.resignFirstResponder()
        let vc = R.storyboard.search.searchVC()
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}

extension ExploreVC : UITableViewDataSource , UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentIndexPath = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PPHorizontalCollectionviewItemTableViewCellID") as! PPHorizontalCollectionviewItemTableViewCell
            cell.vc = self
            cell.horizontalCollectionView.reloadData()
            return cell
        }
        else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableCell") as! StoreTableViewCell
            cell.storePostArray = self.storePosts
            cell.limitArray = self.storelimitArray
            cell.collectionView.reloadData()
            cell.vc = self
            return cell
        }
        else if (indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturePostTableCell") as! FeaturePostItem
            cell.featuredPost = self.featuredPost
            cell.vc = self
            cell.collectionView.reloadData()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableCell") as! ExploreTableViewCell
            cell.explorePostArray = self.explorePostArray
            cell.collectionView.reloadData()
            cell.vc = self
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0){
            return 190.0
        }
        else if (indexPath.row == 1){
            return 0.0
        }
        else if (indexPath.row == 2){
            return 250.0
        }
        else {
            let a = view.frame.width / 1.8
            let c = view.frame.width / 3
            return 40 + a + c
        }
    }
    
}

extension ExploreVC{
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
                self.offset=self.limit * self.pageNo
                self.fetchExplorePost(limit: limit)
                
            }
        }
    }
}

