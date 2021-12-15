//
//  ShowUserProfileVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 05/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import DropDown
import PixelPhotoSDK
import XLPagerTabStrip
import JGProgressHUD
class ShowUserProfileVC:  UIViewController,DeletePostDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoriteStack: UIStackView!
    @IBOutlet weak var followingStack: UIStackView!
    @IBOutlet weak var followersStack: UIStackView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var messageBtn: RoundButton!
    @IBOutlet weak var followBtn: RoundButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    var object:ShowUserProfileData?
    private var userDataArray : FetchPostModel.DataClass?
    private var userPostArray  = [FetchPostModel.UserPost]()
    private let moreDropdown = DropDown()
    var hud : JGProgressHUD?
    var privacy:String? =  ""
    var gender:String? = ""
    var email:String? = ""
    var isPost = 1
    var isGrid = 1
    var isList = 0
    var descriptionString:String? = ""
    var businessAccount:Int?  = 0
    var user_id = 0
    let redColor = UIColor(red: 255/255.0, green: 100/255.0, blue: 140/255.0, alpha: 1.0)
    let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
    var pro_url: String? = nil
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        //        self.setupPagerTab()
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "ExploreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCell")
        self.collectionView.register(UINib(nibName: "NoPostCell", bundle: nil), forCellWithReuseIdentifier: "NoPostcell")
        self.collectionView.register(UINib(nibName: "FeaturedPostCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedPostcell")
        self.collectionView.register(UINib(nibName: "PostWithImageCell", bundle: nil),forCellWithReuseIdentifier: "postImageCell")
        self.collectionView.register(UINib(nibName: "PostWithTwoImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TwoImageCollectionCell")
        self.collectionView.register(UINib(nibName: "PostWithThreeImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ThreeImageCollectionCell")
        self.collectionView.register(UINib(nibName: "PostWithFourImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FourImageCollectionCell")
        self.collectionView.register(UINib(nibName: "PostWithOneImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "postOneImageCollectionCell")
        self.collectionView.register(UINib(nibName: "YoutubeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "YouTubeCollectionCell")
        self.collectionView.register(UINib(nibName: "VideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionCells")
         
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NSLocalizedString("User Profile", comment: "User Profile")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_action_more"), style: .plain, target: self, action: #selector(self.More(sender:)))
        self.messageBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr1"), for: .normal)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func More(sender:UIBarButtonItem){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Report", comment: "Report"), style: .default, handler: { (_) in
            self.reportUser(userId: self.object?.userId ?? 0)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Block", comment: "Block"), style: .default, handler: { (_) in
            self.blockUser()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Link To Profile", comment: "Copy Link To Profile"), style: .default, handler: { (_) in
            UIPasteboard.general.string = self.pro_url ?? ""
            self.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    private func fetchUserPostByUserId(userId: Int){
        print(object?.userId)
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                FetchPostManager.instance.fetchPostByUserId(accessToken: accessToken, userId: userId, limit: 10, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                self.usernameLabel.text = success?.data?.userData?.username ?? ""
                                self.followersCountLabel.text = "\(success?.data?.userData?.followers ?? 0)"
                                self.followingsCountLabel.text = "\(success?.data?.userData?.following ?? 0)"
                                self.favoriteCountLabel.text = "\(success?.data?.userData?.postsCount ?? 0)"
                                self.profileName.text = success?.data?.userData?.name ?? ""
                                self.pro_url = success?.data?.userData?.url ?? ""
                                self.statusLabel.text = success?.data?.userData?.about ?? "Hi there i am using PixelPhoto"
                                if self.statusLabel.text == ""{
                                    self.statusLabel.text = "Hi there i am using PixelPhoto"
                                }
                                
                                //                                    if success?.data?.userData.
                                self.userPostArray = success?.data?.userPosts ?? []
                                if (self.userPostArray.count == 0){
                                    self.isPost = 0
                                }
                                else{
                                    self.isPost = 1
                                }
                                if (success?.data?.isFollowing == true){
                                    self.followBtn.setBackgroundImage(nil, for: .normal)
                                    self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "E6E6E6")
                                    self.followBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
                                    self.followBtn.borderColor = .clear
                                    self.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
                                }
                                else{
                                    self.followBtn.borderColor = .clear
                                    self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr2"), for: .normal)
                                    self.followBtn.setTitleColor(.white, for: .normal)
                                    self.followBtn.setTitle("Follow", for: .normal)
                                }
                                self.collectionView.reloadData()
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
    
    @IBAction func chatPressed(_ sender: Any) {
        let vc = R.storyboard.chat.chatVC()
        vc?.userID = object?.userId ?? 0
        vc?.username = object?.username ?? ""
        vc?.lastSeen = object?.timeText ?? ""
        vc?.isAdmin = object?.isAdmin ?? 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func followingPressed(_ sender: Any) {
        self.followUnFollow()
        
    }
    
    private func setupUI(){
        
        print(object?.username ?? "")
        print(object?.followersCount  ?? 0)
        print(object?.followingCount  ?? 0)
        
        self.usernameLabel.text = object?.username ?? ""
        self.profileName.text = "\(object?.fname ?? "")\(" ")\(object?.lname ?? "")"
        self.followersCountLabel.text = "\(object?.followersCount  ?? 0)"
        self.followingsCountLabel.text = "\(object?.followingCount  ?? 0)"
        self.favoriteCountLabel.text = "\(object?.postCount  ?? 0)"
        self.statusLabel.text = object?.aboutMe ?? "Hi there i am using PixelPhoto"
        let url = URL.init(string:object?.imageString  ?? "")
        self.profileImage.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
        
        //
        if object!.isFollowing!{
            self.followBtn.setBackgroundImage(nil, for: .normal)
            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "E6E6E6")
            self.followBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.followBtn.borderColor = .clear
            self.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
        }else{
            self.followBtn.borderColor = .clear
            self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr2"), for: .normal)
            self.followBtn.setTitleColor(.white, for: .normal)
            self.followBtn.setTitle("Follow", for: .normal)
        }
        if object?.fname == ""{
            self.profileName.text = object?.username ?? ""
        }
        let followersTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followersTapped(tapGestureRecognizer:)))
        self.followersStack.isUserInteractionEnabled = true
        self.followersStack.addGestureRecognizer(followersTapGestureRecognizer)
        //
        let followingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followingTapped(tapGestureRecognizer:)))
        self.followingStack.isUserInteractionEnabled = true
        self.followingStack.addGestureRecognizer(followingTapGestureRecognizer)
        self.fetchUserPostByUserId(userId: object?.userId ?? 0)
        self.messageBtn.setTitle(NSLocalizedString("Message", comment: "Message"), for: .normal)
        self.followersLabel.text = NSLocalizedString("Followers", comment: "Followers")
        self.followingLabel.text = NSLocalizedString("Following", comment: "Following")
        self.postsLabel.text = NSLocalizedString("Posts", comment: "Posts")
        self.aboutMeLabel.text = NSLocalizedString("AboutMe", comment: "AboutMe")

    }
    
    @objc func followersTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let vc = R.storyboard.profile.followersVC()
        vc?.userid = object?.userId ?? 0
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func followingTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let vc = R.storyboard.profile.followingVC()
        vc?.userid = object?.userId ?? 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    private func customizeDropdown(){
        moreDropdown.dataSource = ["Block"]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        //        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.blockUser()
            
            print("Index = \(index)")
        }
    }
    
    private func reportUser(userId: Int){
        if Connectivity.isConnectedToNetwork(){
            ReportUserManager.sharedInstance.reportUser(user_id: userId) { (success, authError, error) in
                if (success != nil){
                    self.view.makeToast(success?.data.message)
                }
                else if (authError != nil){
                    self.view.makeToast(authError?.errors?.errorText)
                }
                else if (error != nil){
                    self.view.makeToast(error?.localizedDescription)
                }
            }
        }
        else{
            self.view.makeToast(InterNetError)
        }
    }
    
    private func blockUser(){
        if self.object?.isAdmin == 1{
            let alert = UIAlertController(title: "", message: "You cannot block this user because it is administrator", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion:nil)
        }else{
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userId = self.object?.userId ?? 0
            Async.background({
                BlockUsersManager.instance.blockUnBlockUsers(accessToken: accessToken, userId: userId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data?.message ?? "")")
                                self.view.makeToast(NSLocalizedString("User has been blocked!", comment: "User has been blocked!"))
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
    }
    
    private func followUnFollow(){
        let accessToken = AppInstance.instance.accessToken ?? ""
        let userID = object?.userId ?? 0
        
        Async.background({
            
            FollowUnFollowManager.instance.followUnFollow(accessToken: accessToken, userId: userID, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        log.verbose("Success = \(success?.type!)")
                        
                        if success?.type ?? 0 == 1{
                            
                            self.followBtn.setBackgroundImage(nil, for: .normal)
                            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "E6E6E6")
                            self.followBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
                            self.followBtn.borderColor = .clear
                            self.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
                        }else{
                            self.followBtn.borderColor = .clear
                            self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr2"), for: .normal)
                            self.followBtn.setTitleColor(.white, for: .normal)
                            self.followBtn.setTitle("Follow", for: .normal)
                        }
                        
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
        
    }
    func showProgressDialog(text: String) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = text
        hud?.show(in: self.view)
    }
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
    }
    
    @IBAction func Grid(_ sender: Any) {
        self.isList = 0
        self.isGrid = 1
        self.collectionView.reloadData()
        print("Grid")
    }
    
    @IBAction func List(_ sender: Any) {
        self.isList = 1
        self.isGrid = 0
        self.collectionView.reloadData()
        print("List")
    }
    
    func postDelete(index: Int) {
        self.userPostArray.remove(at: index)
        self.collectionView.reloadData()
    }
}
extension ShowUserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isPost == 0 {
            return 1
        }
        else{
            return self.userPostArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCell", for: indexPath) as! ExploreCollectionCell
        if self.isPost == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPostcell", for: indexPath) as! NoPostCell
            return cell
        }
        else{
            if self.isGrid == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPostcell", for: indexPath) as! FeaturedPostCell
                let index = self.userPostArray[indexPath.row]
                let image = index.mediaSet?[0].file
                let url = URL(string: image!)
                let exten = url?.pathExtension
                if exten == "mp4"{
                    cell.videoBtn.isHidden = false
                    cell.videoIcon.isHidden = false
                    let previewURl = index.mediaSet?[0].extra
                    let url = URL(string: previewURl ?? "")
                    cell.imageView.sd_setImage(with: url, completed: nil)
                }
                else{
                    cell.videoBtn.isHidden = true
                    cell.videoIcon.isHidden = true
                    cell.imageView.sd_setImage(with: url, completed: nil)
                }
                return cell
            }
                
            else{
                let index = self.userPostArray[indexPath.row]
                if (index.type == "image"){
                if (index.mediaSet?.count ?? 0) == 2{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoImageCollectionCell", for: indexPath) as! PostWithTwoImageCollectionCell
                    cell.post_id = index.postID ?? 0
                    cell.delegate = self
                    cell.userProVC = self
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else if (index.mediaSet?.count ?? 0) == 3{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThreeImageCollectionCell", for: indexPath) as! PostWithThreeImageCollectionCell
                    cell.post_id = index.postID ?? 0
                    cell.delegate = self
                    cell.userProVC = self
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else if(index.mediaSet?.count ?? 0) == 4{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourImageCollectionCell", for: indexPath) as! PostWithFourImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.userProVC = self
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postOneImageCollectionCell", for: indexPath) as! PostWithOneImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.userProVC = self
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
            }
                else if (index.type == "youtube"){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouTubeCollectionCell", for: indexPath) as! YoutubeCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.userProVC = self
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
                else if (index.type == "video"){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionCells", for: indexPath) as! VideoCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.userProVC = self
                    cell.bind(item: index, index: indexPath.row)
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postOneImageCollectionCell", for: indexPath) as! PostWithOneImageCollectionCell
                    cell.delegate = self
                    cell.post_id = index.postID ?? 0
                    cell.userProVC = self
                    cell.bind(object: index, index: indexPath.row)
                    return cell
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isPost == 0{
            return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
        }
        else{
            if self.isGrid == 1{
                let collectionWidth = collectionView.frame.size.width - 10
                let widht = (collectionWidth / 3)
                return CGSize(width: widht , height: widht)
            }
            else{
                let index = self.userPostArray[indexPath.row]
                if (index.type == "image"){
                if (index.mediaSet?.count ?? 0) == 2{
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 385.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 345.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 390.0)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 330.0)
                    }
                }
                else if (index.mediaSet?.count ?? 0) == 3{
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 400.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 345.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 410.0)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 330.0)
                    }
        
                }
                else if ((index.mediaSet?.count ?? 0) == 4){
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 445.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 425.0)
                        //Ok
                    }
                }
                else if ((index.mediaSet?.count ?? 0) == 1){
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 350.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 337.0)
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                    return CGSize(width: collectionView.frame.width, height: 370.0)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 320.0)
                    }
                }
                else{
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 445.0)
                        //Done
                    }
                    else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                        return CGSize(width: collectionView.frame.width, height: 480.0)
                        //Done
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: 425.0)
                        //Ok
                    }
                 }
                }
                else if (index.type == "video"){
                    if (index.userPostDescription != "") && (index.comments?.count == 0){
                          return CGSize(width: collectionView.frame.width, height: 400.0)
                      }
                      else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription == ""){
                        return CGSize(width: collectionView.frame.width, height: 555.0)
                        //Done
                      }
                      else if (index.comments?.count ?? 0 >= 1) && (index.userPostDescription != ""){
                          return CGSize(width: collectionView.frame.width, height: 600.0)
                        //Done
                      }
                      else{
                          return CGSize(width: collectionView.frame.width, height: 550.0)
                        //Done
                      }
                }
                else{
                    return CGSize(width: collectionView.frame.width, height: 370.0)

                }

            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.isGrid == 1){
            let index = self.userPostArray[indexPath.row]
            let userItem = index.userData
            var mediaSet = [String]()
            if (index.mediaSet!.count) > 1{
                index.mediaSet?.forEach({ (it) in
                    mediaSet.append(it.file ?? "")
                })
            }
            
            let vc = R.storyboard.post.showPostsVC()
            let objectToSend = ShowUserProfileData(fname: userItem?.fname, lname: userItem?.lname, username: userItem?.username, aboutMe: userItem?.about, followersCount: 0, followingCount: 0, postCount: userItem?.postsCount, isFollowing: true, userId: userItem?.userID,imageString: userItem?.avatar,timeText: index.timeText,isAdmin: userItem?.admin)
            let object = ShowPostModel(userId: index.userID, imageString: index.avatar, username: index.username, type: index.type, timeText: index.timeText, MediaURL: index.mediaSet![0].file, likesCount: index.likes, commentCount: index.comments?.count, isLiked: index.isLiked, isSaved: index.isSaved, showUserProfile: objectToSend,mediaCount:index.mediaSet?.count,postId: index.postID,description: index.userPostDescription,youtube: index.youtube,MediaUrlsArray: mediaSet)
            vc!.object = object
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
}


