//
//  HomeVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 21/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Async
import PixelPhotoSDK
import GoogleMobileAds

class HomeVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    
    private var storiesArray = [FetchStoryModel.Datum]()
    private var homePostarray = [HomePostModel.Datum]()
    private var fundingArray = [FetchFundingModel.Datum]()
    
    var contentIndexPath : IndexPath?
    var shouldRefreshStories = false
    var isVideo = false
    private var refreshControl = UIRefreshControl()
    
    var pageNo:Int=1
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var isDataLoading:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.limit = 30
        self.offset = 0
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        self.setupUI()
        self.fetchHomePost(limit: self.limit, Offset: 1)
        for i in 1...2{
        }
        self.fetchStories()
        self.fetchFunding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        let vc = R.storyboard.chat.chatListVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func setupUI(){
        self.navigationItem.title = NSLocalizedString("App Name", comment: "")
        self.contentTblView.estimatedRowHeight = 400
        self.contentTblView.register(UINib(nibName: "PPYoutubeItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPYoutubeItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPMultiImageItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPMultiImageItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPLinkItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPLinkItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPVideoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPVideoItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPGIFItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPGIFItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPImageItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPImageItemTableViewCellID")
        self.contentTblView.register(UINib(nibName: "PPCollectionViewItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPCollectionViewItemTableViewCellID")
        self.contentTblView.register(R.nib.fundingTableItem(), forCellReuseIdentifier: R.reuseIdentifier.fundingTableItem.identifier)
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
        self.limit = 30
        self.offset = 0
        self.storiesArray.removeAll()
        self.homePostarray.removeAll()
        self.contentTblView.reloadData()
        self.fetchHomePost(limit: self.limit, Offset: 1)
        for i in 1...2{
        }
        self.fetchStories()
//        refreshControl.endRefreshing()
        
    }
    private func fetchStories(){
        if Connectivity.isConnectedToNetwork(){
            self.storiesArray.removeAll()
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                StoryManager.instance.FetchStory(accessToken: accessToken, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            log.debug("userList = \(success?.data ?? [])")
                            self.storiesArray = success?.data ?? []
                            self.contentTblView.reloadData()
                            
                            
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
    private func fetchHomePost(limit:Int,Offset:Int){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                HomePostManager.instance.fetchHomePost(accessToken: accessToken, limit: limit, offset: self.offset, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? [])")
                                for i in success?.data ?? []{
                                    print(i)
                                    self.homePostarray.append(i)
                                }
                                self.refreshControl.endRefreshing()
                                self.contentTblView.reloadData()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog { self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.refreshControl.endRefreshing()
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription ?? "")")
                                self.refreshControl.endRefreshing()
                            }
                        })
                    }
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.refreshControl.endRefreshing()

        }
    }
    private func fetchFunding(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                FundingManager.instance.fetchFunding(accessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? [])")
                                self.fundingArray = success?.data ?? []
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
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    func showAddStory(cell:UICollectionViewCell){
        ActionSheetStringPicker.show(withTitle: NSLocalizedString("Add Story", comment: ""),
                                     rows: [NSLocalizedString("Text", comment: ""),NSLocalizedString("Image", comment: ""),NSLocalizedString("Video", comment: ""),NSLocalizedString("Camera", comment: "")],
                                     initialSelection: 0,
                                     doneBlock: { (picker, value, index) in
                                        
                                        if value == 0 {
                                            self.shouldRefreshStories = true
                                            self.isVideo = false
                                            
                                            let vc = R.storyboard.story.createStoryTextVC()
                                            self.navigationController?.pushViewController(vc!, animated: true)
                                            
                                        }else if value == 1 {
                                            self.isVideo = false
                                            let imagePickerController = UIImagePickerController()
                                            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                                            imagePickerController.mediaTypes = ["public.image"]
                                            imagePickerController.delegate = self
                                            self.present(imagePickerController, animated: true, completion: nil)
                                        }else if value == 2 {
                                            self.isVideo = true
                                            let imagePickerController = UIImagePickerController()
                                            imagePickerController.sourceType = .photoLibrary
                                            imagePickerController.mediaTypes = ["public.movie"]
                                            imagePickerController.delegate = self
                                            self.present(imagePickerController, animated: true, completion: nil)
                                        }else{
                                            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                                                self.isVideo = false
                                                let imagePickerController = UIImagePickerController()
                                                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                                                imagePickerController.allowsEditing = false
                                                imagePickerController.delegate = self
                                                self.present(imagePickerController, animated: true, completion: nil)
                                            }else{
                                                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
                                        
                                        return
        }, cancel:  { ActionStringCancelBlock in return }, origin: cell)
    }
}
extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else {
            return (self.storiesArray.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPYourStoryItemCollectionViewCellID", for: indexPath) as! PPYourStoryItemCollectionViewCell
            
            let url = URL.init(string:AppInstance.instance.userProfile?.data?.avatar ?? "")
            cell.profileImageVIew.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PPStoryItemCollectionViewCellID", for: indexPath) as! PPStoryItemCollectionViewCell
            let object = self.storiesArray[indexPath.row]
            cell.profileNameLbl.text = object.username ?? ""
            let url = URL.init(string:object.avatar ?? "")
            cell.profileImg.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section != 0 {
            self.shouldRefreshStories = true
            PPStoriesItemsViewControllerVC = UIStoryboard(name: "Story", bundle: nil).instantiateViewController(withIdentifier: "StoriesItemVC") as! StoriesItemVC
            let vc = PPStoriesItemsViewControllerVC
            vc.refreshStories = {
                //                self.viewModel?.refreshStories.accept(true)
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.pages = (self.storiesArray)
            vc.currentIndex = indexPath.row
            self.present(vc, animated: true, completion: nil)
        }else{
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                return
            }
            
            self.showAddStory(cell: cell)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80 , height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
extension HomeVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if self.isVideo {
                let vidURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                
                let vc = R.storyboard.story.createVideoStoryVC()
                vc?.videoLinkString  = vidURL.absoluteString
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                
                let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                let vc = R.storyboard.story.createImageStoryVC()
                vc?.imageLInkString  = FileManager().savePostImage(image: img!)
                vc?.iamge = img
                vc?.isVideo = self.isVideo
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension HomeVC : UITableViewDataSource, UITableViewDelegate,DeletePostDelegate{
    func postDelete(index: Int) {
        self.homePostarray.remove(at: index)
        self.contentTblView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homePostarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.contentIndexPath = indexPath
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PPCollectionViewItemTableViewCellID") as! PPCollectionViewItemTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            cell.contentCollectionView.reloadData()
            self.contentTblView.rowHeight = 100.0
            return cell
        }else{
            if indexPath.row == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fundingTableItem.identifier) as! FundingTableItem
                cell.configure(self.fundingArray)
                self.contentTblView.rowHeight = 200.0
                cell.vc = self
                return cell
            }
            let object = self.homePostarray[indexPath.row]
            if object.type == "video" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPVideoItemTableViewCellID") as! PPVideoItemTableViewCell
                cell.homeBinding(item: object, index: indexPath.row)
                cell.homeVC = self
                if (object.datumDescription != "") && (object.comments?.count == 0){
                    self.contentTblView.rowHeight = 565.0
                    //Done
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                    self.contentTblView.rowHeight = 520.0
                    //Done
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                    self.contentTblView.rowHeight = 570.0
                    //Done
                }
                else{
                    self.contentTblView.rowHeight = 520.0
                    //Done
                }
                return cell
            }
            if object.type == "image" {
                if (object.mediaSet?.count ?? 0) == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TwoImageCell", for: indexPath) as! PostWithTwoImage
                    cell.post_id = object.postID ?? 0
                    cell.delegate = self
                    cell.vc = self
                    cell.bind(object: object, index: indexPath.row)
                    
                    if (object.datumDescription != "") && (object.comments?.count == 0){
                        self.contentTblView.rowHeight = 385.0
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                        self.contentTblView.rowHeight = 350.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                        self.contentTblView.rowHeight = 395.0
                    }
                    else{
                        self.contentTblView.rowHeight = 300.0
                    }
                    
                    return cell
                }
                else if (object.mediaSet?.count ?? 0) == 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeImageCell", for: indexPath) as! PostWithThreeImage
                    cell.post_id = object.postID ?? 0
                    cell.delegate = self
                    cell.vc = self
                    cell.bind(object: object, index: indexPath.row)
                    if (object.datumDescription != "") && (object.comments?.count == 0){
                        self.contentTblView.rowHeight = 395.0
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                        self.contentTblView.rowHeight = 365.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                        self.contentTblView.rowHeight = 405.0
                        //Done
                    }
                    else{
                        self.contentTblView.rowHeight = 350.0
                        //Done
                    }

                    return cell
                }
                    else if (object.mediaSet?.count ?? 0) == 4{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FourImageCell", for: indexPath) as! PostWithFourImage
                    cell.post_id = object.postID ?? 0
                    cell.delegate = self
                    cell.vc = self
                    cell.bind(object: object, index: indexPath.row)
                    if (object.datumDescription != "") && (object.comments?.count == 0){
                        self.contentTblView.rowHeight = 440.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                        self.contentTblView.rowHeight = 410.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                        self.contentTblView.rowHeight = 445.0
                        //Done
                    }
                    else{
                        self.contentTblView.rowHeight = 400.0
                        //Done
                        
                    }
                    return cell
                }
                else if ((object.mediaSet?.count ?? 0) == 1){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell") as! PostWithOneImageCell
                    cell.post_id = object.postID ?? 0
                    cell.delegate = self
                    cell.vc = self
                    cell.bind(object: object, index: indexPath.row)
                    
                    if (object.datumDescription != "") && (object.comments?.count == 0){
                        self.contentTblView.rowHeight = 380.0
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                        self.contentTblView.rowHeight = 350.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                    self.contentTblView.rowHeight = 385.0
                        //Done
                    }
                    else{
                        self.contentTblView.rowHeight = 310.0
                        //Done
                    }
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FourImageCell", for: indexPath) as! PostWithFourImage
                    cell.post_id = object.postID ?? 0
                    cell.delegate = self
                    cell.vc = self
                    cell.bind(object: object, index: indexPath.row)
                    if (object.datumDescription != "") && (object.comments?.count == 0){
                        self.contentTblView.rowHeight = 440.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                        self.contentTblView.rowHeight = 410.0
                        //Done
                    }
                    else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                        self.contentTblView.rowHeight = 445.0
                        //Done
                    }
                    else{
                        self.contentTblView.rowHeight = 400.0
                        //Done
                        
                    }
                    return cell
                }
            }
            else if (object.type == "youtube"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "PPYoutubeItemTableViewCellID") as! PPYoutubeItemTableViewCell
                cell.post_id = object.postID ?? 0
                cell.homeBinding(item: object, index: indexPath.row)
                cell.delegate = self
                cell.homeVC = self
                if (object.datumDescription != "") && (object.comments?.count == 0){
                    self.contentTblView.rowHeight = 520.0
                    //Done
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                    self.contentTblView.rowHeight = 470.0
                    //Done
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                    self.contentTblView.rowHeight = 520.0
                    //Done
                }
                else{
                    self.contentTblView.rowHeight = 450.0
                   ///Done
                }
                return cell
            }
            else if (object.type == "gif"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell") as! PostWithOneImageCell
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.vc = self
                cell.bind(object: object, index: indexPath.row)

                if (object.datumDescription != "") && (object.comments?.count == 0){
                    self.contentTblView.rowHeight = 380.0
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                    self.contentTblView.rowHeight = 350.0
                    //Done
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                self.contentTblView.rowHeight = 385.0
                    //Done
                }
                else{
                    self.contentTblView.rowHeight = 310.0
                    //Done
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageCell") as! PostWithOneImageCell
                cell.post_id = object.postID ?? 0
                cell.delegate = self
                cell.vc = self
                cell.bind(object: object, index: indexPath.row)

                if (object.datumDescription != "") && (object.comments?.count == 0){
                    self.contentTblView.rowHeight = 380.0
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription == ""){
                    self.contentTblView.rowHeight = 350.0
                    //Done
                }
                else if (object.comments?.count ?? 0 >= 1) && (object.datumDescription != ""){
                self.contentTblView.rowHeight = 385.0
                    //Done
                }
                else{
                    self.contentTblView.rowHeight = 310.0
                    //Done
                }
                
                return cell

            }

        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}
extension HomeVC{
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
                self.showProgressDialog(text: "loading..")
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.offset + 1
                self.fetchHomePost(limit: self.limit, Offset: self.offset)

//                for i in 1...2{
//                }
            }
        }
    }
}
