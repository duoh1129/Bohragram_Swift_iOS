//
//  DeleteAccountVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 24/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import BEMCheckBox
import Async
import PixelPhotoSDK

class DeleteAccountVC: BaseVC {
    
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var deleteAccountView: GradientView!
    @IBOutlet weak var deleteAccountCheckBox: BEMCheckBox!
    @IBOutlet weak var deleteAccountLbl: UILabel!
    @IBOutlet weak var removeAccountLbl: UILabel!

    
    @IBOutlet weak var deleteBtn: RoundButton!
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
    
    func setupUI(){
        self.title = NSLocalizedString("Delete Account", comment: "Delete Account")
        self.passwordTxtFld.placeholder = NSLocalizedString("Password", comment: "")
        self.removeAccountLbl.text = NSLocalizedString("Yes, I want to delete permanently from PixelPhoto Account.", comment: "Yes, I want to delete permanently from PixelPhoto Account.")
        self.deleteBtn.setTitle(NSLocalizedString("Remove Account", comment: "Remove Account"), for: .normal)
    }

  //  @objc func removeAccountTapped(_ sender: UITapGestureRecognizer) {
      //  self.deleteAccount()
    //}
    private func deleteAccount(){
        if appDelegate.isInternetConnected{
            if self.deleteAccountCheckBox.on {
            }else{
                if (self.passwordTxtFld.text?.isEmpty)!{
                    let securityAlertVC = R.storyboard.popup.securityPopupVC()
                    securityAlertVC?.titleText  = "Security"
                    securityAlertVC?.errorText = "Please enter current password."
                    self.present(securityAlertVC!, animated: true, completion: nil)
                }else{
                    self.deleteAccounApi()
                }
            }
        }
    }
    private func deleteAccounApi(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let password = self.passwordTxtFld.text ?? ""
        let accessToken = AppInstance.instance.accessToken ?? ""
        Async.background({
            ProfileManger.instance.removeAccount(accessToken: accessToken, password: password, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
                            self.logout()
                            
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
    private func logout(){
            UserDefaults.standard.clearUserDefaults()
            let vc = R.storyboard.main.loginVC()
            appDelegate.window?.rootViewController = vc
    }
    
    @IBAction func DeleteAccount(_ sender: Any) {
           self.deleteAccount()
    }
    
}

