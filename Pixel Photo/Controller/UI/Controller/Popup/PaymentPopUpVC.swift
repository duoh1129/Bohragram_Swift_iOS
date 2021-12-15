//
//  PaymentPopUpVC.swift
//  Pixel Photo
//
//  Created by Mac on 08/04/2021.
//  Copyright © 2021 Olivin Esguerra. All rights reserved.
//

import UIKit

class PaymentPopUpVC: UIViewController {

   
    @IBOutlet weak var paypalButton : UIButton!
    @IBOutlet weak var creditCardButton : UIButton!
    @IBOutlet weak var banktransferButton : UIButton!
    @IBOutlet weak var closeButton : UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
    setupUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setupUI(){
        self.paypalButton.setTitle(NSLocalizedString("PayPal", comment: "PayPal"), for: .normal)
        self.creditCardButton.setTitle(NSLocalizedString("Credit Card", comment: "Credit Card"), for: .normal)
        self.banktransferButton.setTitle(NSLocalizedString("Bank Transfer", comment: "Bank Transfer"), for: .normal)
        self.closeButton.setTitle(NSLocalizedString("CLOSE", comment: "CLOSE"), for: .normal)

        
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
extension PaymentPopUpVC{
    @IBAction func proceedToPaypalPaymentMethod(_ sender: Any) {
        print("PayPal Fuction Pressed")
    }
    @IBAction func proceedToCreditCardPaymentMethod(_ sender: Any) {
        print("Credit Card Fucntion Pressed")
    }
    @IBAction func proceedToBankTransferPaymentMethod(_ sender: Any) {
        print("Bank Transfer Fucntion Pressed")
    }
    @IBAction func closePymnetPopUp(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
}
