//
//  BusinessAccountController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/27/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import PixelPhotoSDK


class BusinessAccountController: BaseVC {
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var webField: UITextField!
    
    @IBOutlet weak var submitBtn: RoundButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLabel.text = NSLocalizedString("Enter Your Information!", comment: "Enter Your Information!")
        self.businessName.text = NSLocalizedString("Business Name", comment: "Business Name")
        self.EmailField.text = NSLocalizedString("Email", comment: "Email")
        self.phoneField.text = NSLocalizedString("Phone Number", comment: "Phone Number")
        self.webField.text = NSLocalizedString("Website", comment: "Website")
        self.submitBtn.setTitle(NSLocalizedString("Submit Request", comment: "Submit Request"), for: .normal)
        self.title = NSLocalizedString("Business Account", comment: "Business Account")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        submitBtn.backgroundColor = UIColor.mainColor
    }
    
    
    private func createBusinessAccount(){
        if Connectivity.isConnectedToNetwork(){
            BusinessAccountManager.sharedInstance.createBusinessAccount(b_Name: self.businessName.text!, b_email: self.EmailField.text!, b_phone: self.phoneField.text!, b_site: self.webField.text!) { (success, authError, error) in
                if (success != nil){
                    self.view.makeToast(success?.status)
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
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
    
    @IBAction func Submit(_ sender: Any) {
        if (self.businessName.text?.isEmpty == true) || (self.businessName.text == " "){
            self.view.makeToast(NSLocalizedString("Enter BusinessName", comment: "Enter BusinessName"))
        }
        else if (self.EmailField.text?.isEmpty == true) || (self.businessName.text == " "){
            self.view.makeToast(NSLocalizedString("Enter Email", comment: "Enter Email"))
        }
        else if (self.phoneField.text?.isEmpty == true) || (self.phoneField.text == " "){
            self.view.makeToast(NSLocalizedString("Enter PhoneNumber", comment: "Enter PhoneNumber"))
        }
        else if (self.webField.text?.isEmpty == true) || (self.webField.text == " "){
            self.view.makeToast(NSLocalizedString("Enter Website", comment: "Enter Website"))
        }
        else{
            self.createBusinessAccount()
        }
        
    }
    
    
}
