//
//  FollowersVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 28/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//


import UIKit
import Async
import PixelPhotoSDK

class FollowersVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    
    private var followersArray = [FollowFollowingModel.Datum]()
    private var refreshControl = UIRefreshControl()
    var userid:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchFollowers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = true
        showImage.tintColor = UIColor.mainColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = false
        
    }
    func setupUI(){
        
        self.title = NSLocalizedString("Followers", comment: "Followers")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
           self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.showImage.isHidden = true
        self.showLabel.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        contentTblView.addSubview(refreshControl)
        
        self.contentTblView.separatorStyle = .singleLine
        self.contentTblView.tableFooterView = UIView()
        self.contentTblView.register(R.nib.ppProfileCheckBoxItemTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.ppProfileCheckBoxItemTableViewCellID.identifier)
        
        self.showLabel.text = NSLocalizedString("There are no users", comment: "")
        
    }
    @objc func refresh(sender:AnyObject) {
        self.followersArray.removeAll()
        self.contentTblView.reloadData()
        self.fetchFollowers()
        refreshControl.endRefreshing()
        
    }
    
    private func fetchFollowers(){
        if Connectivity.isConnectedToNetwork(){
            self.followersArray.removeAll()
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userId = userid ?? 0
            Async.background({
                FollowFollowingManager.instance.fetchFollowers(userId: userId, accessToken: accessToken, limit: 10, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                                self.followersArray = success?.data ?? []
                                if self.followersArray.isEmpty{
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
}

extension FollowersVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.followersArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ppProfileCheckBoxItemTableViewCellID.identifier) as! PPProfileCheckBoxItemTableViewCell
        let object = followersArray[indexPath.row]
        cell.vcFollowers = self
        cell.userId = object.userID ?? 0
        cell.profileNameLbl.text = object.name ?? ""
        cell.userNameLbl.text = "Last seen \(object.timeText ?? "")"
        let url = URL.init(string:object.avatar ?? "")
        cell.profileImgView.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
        if object.isFollowing!{
            cell.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
            cell.followBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr1"), for: .normal)
            cell.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            cell.followBtn.borderColor = .clear
        }else{
            cell.followBtn.setBackgroundImage(nil, for: .normal)
            cell.followBtn.backgroundColor = .clear
            cell.followBtn.borderColor = UIColor.hexStringToUIColor(hex: "73348D")
            cell.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#73348D"), for: UIControl.State.normal)
            cell.followBtn.setTitle(NSLocalizedString("Follow", comment: ""), for: UIControl.State.normal)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.post.showUserProfileVC()
        let object = followersArray[indexPath.row]
        vc?.privacy = object.pPrivacy ?? ""
        vc?.gender = object.gender ?? ""
        vc?.descriptionString = object.about ?? ""
        vc?.email = object.email ?? ""
        vc?.businessAccount = object.businessAccount ?? 0
        let objectToSend = ShowUserProfileData(fname: object.fname, lname: object.lname, username: object.username, aboutMe: object.about, followersCount: object.followers, followingCount: object.following, postCount: object.posts, isFollowing: object.isFollowing, userId: object.userID,imageString: object.avatar,timeText: object.timeText,isAdmin: object.admin)
        vc!.object = objectToSend
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
