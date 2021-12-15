//
//  StoreFilterController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class StoreFilterController: UIViewController,storeLicenseDelegate,storeCategoryDelegate {
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var tagsField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var licenseType: UITextField!
    @IBOutlet weak var priceMin: UITextField!
    @IBOutlet weak var priceMax: UITextField!
    
    @IBOutlet weak var filterLbl: UILabel!
    
    
    @IBOutlet weak var filterBtn: RoundButton!
    
    var cat_Id: Int? = nil
    var delegate : storeFilterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryField.inputView = UIView()
        self.licenseType.inputView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.filterBtn.setTitle(NSLocalizedString("APPLY FILTER", comment: "APPLY FILTER"), for: .normal)
        self.titleField.placeholder = NSLocalizedString("Title", comment: "Title")
        self.tagsField.placeholder = NSLocalizedString("Tags", comment: "Tags")
        self.categoryField.placeholder = NSLocalizedString("Category", comment: "Category")
        self.licenseType.placeholder = NSLocalizedString("License Type", comment: "License Type")
        self.priceMax.placeholder = NSLocalizedString("Price Max", comment: "Price Max")
        self.priceMin.placeholder = NSLocalizedString("Price Min", comment: "Price Min")
        self.filterLbl.text = NSLocalizedString("Filter", comment: "Filter")
        filterBtn.backgroundColor = UIColor.mainColor
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func checkLicenseName(name: String) {
        self.licenseType.resignFirstResponder()
        self.licenseType.text = name
        print("LicenseName",name)
    }
    func checkCategoryID(id: Int, name: String) {
        self.categoryField.resignFirstResponder()
        self.categoryField.text = name
        self.cat_Id = id
        print("id",id)
        print("name",name)
    }
    
    
    @IBAction func LicenseTap(_ sender: Any) {
        self.licenseType.resignFirstResponder()
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreLicenseVC") as! StoreLicenseController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func CategoryTap(_ sender: Any) {
        self.categoryField.resignFirstResponder()
        let Storyboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "StoreCategoryVC") as! StoreCategoryController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Filter(_ sender: Any) {
            self.dismiss(animated: true) {
                self.delegate.filter(title: self.titleField.text ?? " ", tag: self.tagsField.text ?? " ", category: self.cat_Id ?? 0, license: self.licenseType.text ?? " ", price_Min: self.priceMin.text ?? " ", price_Max: self.priceMax.text ?? " ")
            }
        
    }
}
