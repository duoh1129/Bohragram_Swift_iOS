//
//  SettingsProfileVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 24/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK

class SettingsProfileVC: BaseVC {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var googleTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileLbl : UILabel!
    @IBOutlet weak var socialLbl : UILabel!
    var commingFrom:String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

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
        if commingFrom == "profile"{
            self.tabBarController?.tabBar.isHidden = false
            if let tabVC = self.tabBarController as? TabbarController {
                tabVC.button.isHidden = false
            }
        }
    }
    private func setupUI(){
        self.profileLbl.text = NSLocalizedString("My Profile", comment: "My Profile")
        self.socialLbl.text = NSLocalizedString("Social Links", comment: "Socail Links")
        self.title = NSLocalizedString("Profile", comment: "Profile")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let Save = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"), style: .done, target: self, action: #selector(self.Save))
        self.navigationItem.rightBarButtonItem = Save
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.aboutTextField.placeholder = NSLocalizedString("About you", comment: "About you")
        self.facebookTextField.placeholder = NSLocalizedString("Your facebook profile url", comment: "Your facebook profile url")
        self.googleTextField.placeholder = NSLocalizedString("Your google-plus profile url", comment: "Your google-plus profile url")
        self.twitterTextField.placeholder = NSLocalizedString("Your twitter profile url", comment: "Your twitter profile url")
        self.googleTextField.text = AppInstance.instance.userProfile?.data?.google ?? ""
        self.facebookTextField.text = AppInstance.instance.userProfile?.data?.facebook ?? ""
        self.firstNameTextField.text = AppInstance.instance.userProfile?.data?.fname ?? ""
        self.lastNameTextField.text = AppInstance.instance.userProfile?.data?.lname ?? ""
        self.aboutTextField.text = AppInstance.instance.userProfile?.data?.about ?? ""
        self.twitterTextField.text = AppInstance.instance.userProfile?.data?.twitter ?? ""
        
    }
    @objc func Save(){
        self.updateProfile()
    }
    private func updateProfile(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        
        let firstname = self.firstNameTextField.text ?? ""
        let lastname = lastNameTextField.text ?? ""
        let about = self.aboutTextField.text ?? ""
        let facebook = facebookTextField.text ?? ""
        let google = self.googleTextField.text ?? ""
        let twitter = twitterTextField.text ?? ""
        let accessToken = AppInstance.instance.accessToken ?? ""
        Async.background({
            ProfileManger.instance.updateEditProfile(accessToken: accessToken, firsName: firstname, lastName: lastname, about: about, facebook: facebook, google: google, twitter: twitter, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                            AppInstance.instance.fetchUserProfile()
                            self.view.makeToast(success?.message ?? "")
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
    }
}
