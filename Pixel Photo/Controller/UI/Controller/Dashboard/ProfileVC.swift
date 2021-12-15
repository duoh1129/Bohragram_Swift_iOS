//
//  ProfileVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 23/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
import XLPagerTabStrip
import JGProgressHUD
//ButtonBarPagerTabStripViewController
class ProfileVC:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let imagePickerController = UIImagePickerController()
    private var imageStatus:Bool? = false
    private var avatarImage:UIImage? = nil
    var isPost = 1
    var isGrid = 1
    var isList = 0
    var imageHeight: CGFloat = 0.0
    private var userPostArray  = [FetchPostModel.UserPost]()
    var user_Data: FetchPostModel.DataUserData?

    var hud : JGProgressHUD?
    private var refreshControl = UIRefreshControl()

    let redColor = UIColor(red: 221/255.0, green: 0/255.0, blue: 19/255.0, alpha: 1.0)
    let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
    

    var userInfo: [String : Any]?
    
    override func viewDidLoad() {
        //        self.setupPagerTab()
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "UserDetailCell", bundle: nil), forCellReuseIdentifier: "UserdetailCell")
        self.tableView.register(UINib(nibName: "UserImgesCell", bundle: nil), forCellReuseIdentifier: "UserImagescell")
        self.tableView.separatorStyle = .none
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        self.fetchUserPostByUserId()

    }
    
    
    @objc func refresh(sender:AnyObject) {
        self.userPostArray.removeAll()
        self.tableView.reloadData()
        self.fetchUserPostByUserId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        
    }

    @IBAction func settingPressed(_ sender: Any) {
        let vc = R.storyboard.settings.settingVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    private func setupUI(){
        self.navigationItem.title = NSLocalizedString("My Profile", comment: "My Profile")
        print(AppInstance.instance.userProfile?.data?.username ?? "")
        self.user_Data?.username = AppInstance.instance.userProfile?.data?.username ?? ""
        self.user_Data?.name = AppInstance.instance.userProfile?.data?.name ?? ""
        self.user_Data?.about =  AppInstance.instance.statusText ?? "Hi there i am using Bohragram"
        self.user_Data?.followers = AppInstance.instance.userProfile?.data?.followers ?? 0
        self.user_Data?.following = AppInstance.instance.userProfile?.data?.following ?? 0
        self.user_Data?.favourites = AppInstance.instance.userProfile?.data?.favourites ?? 0
        self.user_Data?.avatar = AppInstance.instance.userProfile?.data?.avatar ?? ""
        print(self.user_Data?.username)
        print(self.user_Data?.avatar)

//        self.user_Data = data
        self.tableView.reloadData()
    }
    
    private func fetchUserPostByUserId(){
        
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userid = AppInstance.instance.userId ?? 0
            Async.background({
                FetchPostManager.instance.fetchPostByUserId(accessToken: accessToken, userId: userid, limit: 30, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
//                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                self.user_Data = success?.data?.userData
                                self.userPostArray = (success?.data?.userPosts ?? [])
                                self.refreshControl.endRefreshing()
                                self.tableView.reloadData()
                            }
//                        })
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
                                print(error?.localizedDescription)
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                                self.refreshControl.endRefreshing()
                            }
                        })
                    }
                })
            })

        }
        else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.refreshControl.endRefreshing()
        }
    }
    
   
    
    
    func updateAvatar(imageData:Data){
        
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            
            ProfileManger.instance.updateAvatar(accessToken: accessToken, avatar_data: imageData, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
                            AppInstance.instance.fetchUserProfile()
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            
                        }                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("error = \(error?.localizedDescription)")
                            self.view.makeToast(error?.localizedDescription ?? "")
                        }
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
}
//
//extension  ProfileVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        self.profileImage.image = image
//        self.avatarImage  = image ?? nil
//        let avatarData = self.avatarImage?.jpegData(compressionQuality: 0.2)
//        updateAvatar(imageData: avatarData ??  Data())
//        self.dismiss(animated: true, completion: nil)
//    }
//}
extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserdetailCell") as! UserDetailCell
            let index = self.user_Data
            cell.userName.text = "\("@ ")\(index?.username ?? "")"
            cell.profileName.text = index?.name ?? ""
            cell.status.text = index?.about ?? "Hi there i am using Bohragram"
            cell.followersCount.text = "\(index?.followers ?? 0)"
            cell.followingCount.text = "\(index?.following ?? 0)"
            cell.favouriteCount.text = "\(index?.favourites ?? 0)"
            cell.blueTickImageView.isHidden = (AppInstance.instance.userProfile?.data?.verified == 1) ? false : true
            let url = URL.init(string: index?.avatar ?? "")
            cell.profileImage.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
            if (cell.status.text == ""){
                cell.status.text = "Hi there i am using Bohragram"
            }
             cell.vc = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImagescell") as! UserImgesCell
            cell.vc = self
            cell.userPosts = self.userPostArray
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 215.0
        }
        else{
            let height = self.tableView.frame.height
            print(height)
            let rowHeight = (height - 180.0)
            return height
        }
    }
}
