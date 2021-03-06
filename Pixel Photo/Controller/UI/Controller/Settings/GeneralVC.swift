//
//  GeneralVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 24/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK

class GeneralVC: BaseVC {
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBrn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    
    private var genderString:String? = ""
    
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
    @IBAction func femalePressed(_ sender: Any) {
        
        self.femaleBrn.setImage(R.image.ic_radioOn(), for: .normal)
        self.maleBtn.setImage(R.image.ic_radioOff(), for: .normal)
        self.genderString = "female"
    }
    
    @IBAction func malePressed(_ sender: Any) {
        self.maleBtn.setImage(R.image.ic_radioOn(), for: .normal)
        self.femaleBrn.setImage(R.image.ic_radioOff(), for: .normal)
        self.genderString = "male"
        
    }
    private func setupUI(){
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "")
        self.emailTextField.placeholder = NSLocalizedString("Email", comment: "")
        self.genderLabel.text = NSLocalizedString("Gender", comment: "Gender")
        self.maleLabel.text  = NSLocalizedString("Male", comment: "Male")
        self.femaleLabel.text = NSLocalizedString("Female", comment: "Female")
        
        self.usernameTextField.text = AppInstance.instance.userProfile?.data?.username ?? ""
        self.emailTextField.text = AppInstance.instance.userProfile?.data?.email ?? ""
        if AppInstance.instance.userProfile?.data?.gender == "male"{
            
            self.maleBtn.setImage(R.image.ic_radioOn(), for: .normal)
            self.femaleBrn.setImage(R.image.ic_radioOff(), for: .normal)
            self.genderString = AppInstance.instance.userProfile?.data?.gender ?? ""
        }else{
            self.femaleBrn.setImage(R.image.ic_radioOn(), for: .normal)
            self.maleBtn.setImage(R.image.ic_radioOff(), for: .normal)
            self.genderString = AppInstance.instance.userProfile?.data?.gender ?? ""
        }
        self.title = NSLocalizedString("General", comment: "General")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let Save = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"), style: .done, target: self, action: #selector(self.Save))
        self.navigationItem.rightBarButtonItem = Save
    }
    @objc func Save(){
        self.updateGeneral()
    }
    
    private func updateGeneral(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let email = emailTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let genderString = self.genderString ?? ""
        let accessToken = AppInstance.instance.accessToken ?? ""
        Async.background({
            ProfileManger.instance.updateGeneral(accessToken: accessToken, username: username, email: email, gender: genderString, completionBlock: { (success, sessionError, error) in
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
