//
//  ContactsVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 30/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK

class ContactsVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    
    private var followingArray = [FollowFollowingModel.Datum]()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchFollowings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = true
        showImage.tintColor = UIColor.mainColor
    }
    func setupUI(){
        
        self.title = NSLocalizedString("Following", comment: "Following")
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
        self.contentTblView.register(R.nib.contactsTableCell(), forCellReuseIdentifier: R.reuseIdentifier.contactsTableCell.identifier)
         self.contentTblView.register(R.nib.ppProfileCheckBoxItemTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.ppProfileCheckBoxItemTableViewCellID.identifier)
        self.showLabel.text = NSLocalizedString("There are no users", comment: "")
        
    }
    @objc func refresh(sender:AnyObject) {
        self.followingArray.removeAll()
        self.contentTblView.reloadData()
        self.fetchFollowings()
        refreshControl.endRefreshing()
        
    }
    
    private func fetchFollowings(){
        if Connectivity.isConnectedToNetwork(){
            self.followingArray.removeAll()
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userId = AppInstance.instance.userId ?? 0
            Async.background({
                
                FollowFollowingManager.instance.fetchFollowings(userId: userId, accessToken: accessToken, limit: 10, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                                self.followingArray = success?.data ?? []
                                if self.followingArray.isEmpty{
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

extension ContactsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.followingArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contactsTableCell.identifier) as! ContactsTableCell
        let object = followingArray[indexPath.row]
        cell.profileNameLbl.text = object.name ?? ""
        cell.userNameLbl.text = "Last seen \(object.timeText ?? "")"
        let url = URL.init(string:object.avatar ?? "")
        cell.profileImgView.sd_setImage(with: url , placeholderImage:R.image.img_item_placeholder())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
//            UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        log.verbose("Did Selected")
        let object = self.followingArray[indexPath.row]
        let vc = R.storyboard.chat.chatVC()
        vc?.userID = object.userID ?? 0
        vc?.username = object.name ?? ""
        vc?.lastSeen = object.timeText ?? ""
        vc?.isAdmin = object.admin ?? 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

