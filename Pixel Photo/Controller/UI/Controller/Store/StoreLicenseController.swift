//
//  StoreLicenseController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class StoreLicenseController: UIViewController {

    
    var delegate :storeLicenseDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LicesnseType(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.dismiss(animated: true) {
                self.delegate.checkLicenseName(name: "rights_managed_license")
            }
        case 1:
            self.dismiss(animated: true) {
                self.delegate.checkLicenseName(name: "editorial_use_license")
            }
        case 2:
            self.dismiss(animated: true) {
                self.delegate.checkLicenseName(name: "royalty_free_license")
            }
        case 3:
            self.dismiss(animated: true) {
             self.delegate.checkLicenseName(name: "royalty_free_extended_license")
            }
        case 4:
            self.dismiss(animated: true) {
                self.delegate.checkLicenseName(name: "creative_commons_license")
            }
        case 5:
            self.dismiss(animated: true) {
                self.delegate.checkLicenseName(name: "public_domain")
            }
        default:
            print("Nothing")
        }
        
    }
    

    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
