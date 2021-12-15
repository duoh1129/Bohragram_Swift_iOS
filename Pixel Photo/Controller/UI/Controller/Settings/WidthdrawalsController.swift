//
//  WidthdrawalsController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import PixelPhotoSDK
class WidthdrawalsController: BaseVC {

    @IBOutlet weak var balanceLabel: RoundLabel!
    @IBOutlet weak var amountField: RoundTextField!
    @IBOutlet weak var emailField: RoundTextField!
    
    @IBOutlet weak var requestBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Widthdrawals", comment: "Widthdrawals")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.requestBtn.setTitle(NSLocalizedString("REQUEST WITHDRAWAL", comment: "REQUEST WITHDRAWAL"), for: .normal)
        self.balanceLabel.text = NSLocalizedString("Your balance is $0, minimum withdrawal request is $50", comment: "Your balance is $0, minimum withdrawal request is $50")
        self.amountField.placeholder = NSLocalizedString("Amount", comment: "Amount")
        self.emailField.placeholder = NSLocalizedString("PayPal E-mail", comment: "PayPal E-mail")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        balanceLabel.backgroundColor = UIColor.mainColor
        requestBtn.backgroundColor = UIColor.mainColor
    }
    
    
    private func withDrawal(){
        if self.amountField.text?.isEmpty == true || self.amountField.text == ""{
            self.view.makeToast(NSLocalizedString("Please Enter amount", comment: "Please Enter amount"))
        }
        else if (self.emailField.text?.isEmpty == true) || (self.emailField.text == ""){
            self.view.makeToast(NSLocalizedString("Please Enter Paypal Email", comment: "Please Enter Paypal Email"))
        }
        else{
            if Connectivity.isConnectedToNetwork(){
                self.self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
                WithDrawalManager.sharedInstance.withDraw(paypalEmail: self.emailField.text!, amount: self.amountField.text!) { (success, authError, error) in
                    if success != nil{
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.status)
                        }
                    }
                    else if (authError != nil){
                        self.dismissProgressDialog {
                            self.view.makeToast(authError?.errors?.errorText)
                        }
                    }
                    else if (error != nil){
                        self.dismissProgressDialog {
                            self.view.makeToast(authError?.errors?.errorText)
                        }
                    }
                }
            }
            else{
                log.error("internetError = \(InterNetError)")
                self.view.makeToast(InterNetError)
            }
        }
    }

    @IBAction func Request(_ sender: Any) {
        self.withDrawal()
    }
    
}
