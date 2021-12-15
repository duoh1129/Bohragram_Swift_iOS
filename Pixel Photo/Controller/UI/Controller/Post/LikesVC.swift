//
//  LikesVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 06/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift
import Async
import PixelPhotoSDK

class LikesVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    
    
    private var postLikeArray = [GetLikesModel.Datum]()
    private var refreshControl = UIRefreshControl()
    
    var disposeBag = DisposeBag()
    var alreadyInitialize = false
    var contentIndexPath : IndexPath?
    var postId:Int? = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupUI()
        self.contentTblView.tableFooterView = UIView()
        self.fetchLikes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        showImage.tintColor = UIColor.mainColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = false
        }
    }
    func setupUI(){
        
        self.title = "Likes"
        self.showImage.isHidden = true
        self.showLabel.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        contentTblView.addSubview(refreshControl)
        
        self.contentTblView.register(UINib(nibName: "PPProfileCheckBoxItemTableViewCell", bundle: nil), forCellReuseIdentifier: "PPProfileCheckBoxItemTableViewCellID")
        
        self.showLabel.text = NSLocalizedString("No Comments Yet", comment: "")
    }
    @objc func refresh(sender:AnyObject) {
        self.postLikeArray.removeAll()
        self.contentTblView.reloadData()
        self.fetchLikes()
        refreshControl.endRefreshing()
    }
    private func fetchLikes(){
        if Connectivity.isConnectedToNetwork(){
            self.postLikeArray.removeAll()
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let postID = postId ?? 0
            Async.background({
                LikeManager.instance.getLike(accessToken: accessToken, postId: postID, limit: 10, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                                self.postLikeArray = success?.data ?? []
                                if self.postLikeArray.isEmpty{
                                    self.showImage.isHidden = false
                                    self.showLabel.isHidden = false
                                    self.contentTblView.reloadData()
                                }else{
                                    self.showImage.isHidden = true
                                    self.showLabel.isHidden = true
                                    self.contentTblView.reloadData()
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
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
    
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension LikesVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.postLikeArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PPProfileCheckBoxItemTableViewCellID") as! PPProfileCheckBoxItemTableViewCell
        let object = postLikeArray[indexPath.row]
        cell.vcLikes = self
        cell.userId = object.userID ?? 0
        cell.profileNameLbl.text = object.username ?? ""
        cell.userNameLbl.text = "Last seen \(object.timeText ?? "")"
        let url = URL.init(string:object.avatar ?? "")
        cell.profileImgView.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
        if object.userID == AppInstance.instance.userId ?? 0{
            cell.followBtn.isHidden = true
            //            cell.checkBox.isHidden = true
        }else{
            cell.followBtn.isHidden = false
            //            cell.checkBox.isHidden = true
            
        }
        if object.isFollowing == 1{
            
            cell.followBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr1"), for: .normal)
            cell.followBtn.borderColor = .clear
            cell.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            cell.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
            
            
            //            cell.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            //            cell.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
            
        }else{
            cell.followBtn.setBackgroundImage(nil, for: .normal)
            cell.followBtn.backgroundColor = .clear
            cell.followBtn.setTitle(NSLocalizedString("Follow", comment: ""), for: UIControl.State.normal)
            //            cell.followBtn.setTitleColor(UIColor.mainColor, for: UIControl.State.normal)
            //            cell.followBtn.setTitle(NSLocalizedString("Follow", comment: ""), for: UIControl.State.normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
        //            UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.post.showUserProfileVC()
        var isFollow: Bool? = nil
        let object = self.postLikeArray[indexPath.row]
        if object.isFollowing == 0{
            isFollow = false
        }
        else{
            isFollow = true
        }
        
        vc?.privacy = object.userData?.pPrivacy ?? ""
        vc?.gender = object.userData?.gender ?? ""
        vc?.descriptionString = object.userData?.about ?? ""
        vc?.email = object.userData?.email ?? ""
        vc?.businessAccount = object.userData?.businessAccount ?? 0
        let objectToSend = ShowUserProfileData(fname: object.userData?.fname, lname: object.userData?.lname, username: object.userData?.username, aboutMe: object.userData?.about, followersCount: object.userData?.followers, followingCount: object.userData?.following, postCount: object.userData?.posts, isFollowing: isFollow ?? false, userId: object.userData?.userID,imageString: object.userData?.avatar,timeText: object.timeText ?? "",isAdmin: object.userData?.admin)
            vc!.object = objectToSend
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

