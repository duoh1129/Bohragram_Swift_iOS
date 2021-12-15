//
//  SettingVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 24/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//


import UIKit
import IoniconsSwift
import PixelPhotoSDK

struct List{
    var img: UIImage
    var name: String
}

class SettingVC: BaseVC {
    
    @IBOutlet weak var contentTblView: UITableView!

    var list = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    func setupUI(){
        
        self.title = NSLocalizedString("Settings", comment: "Settings")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.contentTblView.isScrollEnabled = true
        self.contentTblView.showsVerticalScrollIndicator = false
        self.contentTblView.showsHorizontalScrollIndicator = false
        self.title = NSLocalizedString("Settings", comment: "")
        self.contentTblView.register(R.nib.ppSettingsItemTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.ppSettingsItemTableViewCellID.identifier)
        self.contentTblView.register(R.nib.nightModeTableItem(), forCellReuseIdentifier: R.reuseIdentifier.nightModeTableItem.identifier)
        let setting = List(img: #imageLiteral(resourceName: "Generals"), name: NSLocalizedString("General", comment: "General"))
        let profile = List(img: #imageLiteral(resourceName: "Profile"), name: NSLocalizedString("Profile", comment: "Profile"))
        let pass = List(img: #imageLiteral(resourceName: "key"), name: NSLocalizedString("Change Password", comment: "Change Password"))
        let account = List(img: #imageLiteral(resourceName: "eyess"), name: NSLocalizedString("Account privacy", comment: "Account privacy"))
        let notification = List(img: #imageLiteral(resourceName: "ic_notificationBell"), name: NSLocalizedString("Notification", comment: "Notification"))
        let session = List(img: #imageLiteral(resourceName: "identification"), name: NSLocalizedString("Manage Sessions", comment: "Manage Sessions"))
        let businessAccount = List(img: UIImage(named: "portfolio")!, name: NSLocalizedString("Business Account", comment: "Business Account"))
        let verification = List(img: #imageLiteral(resourceName: "correct"), name: NSLocalizedString("Verification", comment: "Verification"))
        let block = List(img: #imageLiteral(resourceName: "forbidden"), name: NSLocalizedString("Blocked User", comment: "Blocked User"))
        
        let withdraw = List(img: #imageLiteral(resourceName: "forbi"), name: NSLocalizedString("Widthdrawals", comment: "Widthdrawals"))
        let affilities = List(img: #imageLiteral(resourceName: "friend"), name: NSLocalizedString("My Affilities", comment: "My Affilities"))
        
        let deleteAccount = List(img: #imageLiteral(resourceName: "deletets"), name: NSLocalizedString("Delete Account", comment: "Delete Account"))
        let nightMode = List(img: #imageLiteral(resourceName: "Moon"), name: NSLocalizedString("Night Mode", comment: "Night Mode"))
        let Logout = List(img: #imageLiteral(resourceName: "logouts"), name: NSLocalizedString("Logout", comment: "Logout"))
        self.list.append(setting)
        self.list.append(profile)
        self.list.append(pass)
        self.list.append(account)
        self.list.append(notification)
        self.list.append(session)
        self.list.append(nightMode)
        self.list.append(businessAccount)
        self.list.append(verification)
        self.list.append(block)
        
//        if ControlSettings.ShowSettingsWithdrawals {
//            self.list.append(withdraw)
//        }
//        if ControlSettings.ShowSettingsAffilities {
//            self.list.append(affilities)
//        }
        
        self.list.append(deleteAccount)
        self.list.append(Logout)
    }
}
extension SettingVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.nightModeTableItem.identifier) as! NightModeTableItem
            cell.config()
            cell.titleLabel.text = self.list[indexPath.row].name
            cell.iconimage.image = self.list[indexPath.row].img
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ppSettingsItemTableViewCellID.identifier) as! PPSettingsItemTableViewCell
            cell.titleLbl.text = self.list[indexPath.row].name
            cell.iconImgView.image = self.list[indexPath.row].img
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = R.storyboard.settings.generalVC()
            self.pushToVC(vc: vc!)
        }else if indexPath.row == 1 {
            let vc = R.storyboard.settings.settingsProfileVC()
            self.pushToVC(vc: vc!)
        }else if indexPath.row == 2 {
            let vc = R.storyboard.settings.changePasswordVC()
            self.pushToVC(vc: vc!)
        }else if indexPath.row == 3 {
            let vc = R.storyboard.settings.accountPrivacyVC()
            self.pushToVC(vc: vc!)
        }else if indexPath.row == 4 {
            let vc = R.storyboard.settings.notificationSettingsVC()
            self.pushToVC(vc: vc!)
        }else if indexPath.row == 5 {
            let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "ManageSessionVC") as! ManageSessions
            // self.vc?.navigationController?.pushViewController(vc, animated: true)
            self.pushToVC(vc: vc)
        }else if indexPath.row == 7 {
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "BusinessAccountVC") as! BusinessAccountController
            self.pushToVC(vc: vc)
        }else if indexPath.row == 8 {
            let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationController
            self.pushToVC(vc: vc)
        }
        else if indexPath.row == 9 {
            let vc = R.storyboard.settings.blockUserVC()
            self.pushToVC(vc: vc!)
        }
//        else if indexPath.row == 10{
//            let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
//            let vc = Storyboard.instantiateViewController(withIdentifier: "WithdrawalVC") as! WidthdrawalsController
//            self.pushToVC(vc: vc)
//        }
//        else if (indexPath.row == 11){
//            let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
//            let vc = Storyboard.instantiateViewController(withIdentifier: "MyAffilitiesVC") as! MyAffilitesController
//            self.pushToVC(vc: vc)
//        }
        else if indexPath.row == 10{
            let vc = R.storyboard.settings.deleteAccountVC()
            self.pushToVC(vc: vc!)
        }
        else if (indexPath.row == 11){
            let alert = UIAlertController(title: NSLocalizedString("Logout", comment: "Logout"), message: NSLocalizedString("Are you sure you want to logout", comment: "Are you sure you want to logout"), preferredStyle: .alert)
            let logout = UIAlertAction(title: NSLocalizedString("Logout", comment: "Logout"), style: .default) { (action) in
                UserDefaults.standard.clearUserDefaults()
                let vc = R.storyboard.main.loginVC()
                let navigationController = UINavigationController.init(rootViewController: vc!)
                self.appDelegate.window?.rootViewController = navigationController
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
            alert.addAction(logout)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
//        return UITableView.automaticDimension
    }
    
    private func pushToVC(vc:UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
