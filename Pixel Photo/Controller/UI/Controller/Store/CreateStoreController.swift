//
//  CreateStoreController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK

class CreateStoreController: BaseVC,uploadImageDelegate,storeLicenseDelegate,storeCategoryDelegate {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var licenseField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var tagField: UITextField!
    
    @IBOutlet weak var imageBtn: RoundButton!
    var photoImage : Data?
    var cat_Id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Create", comment: "Create"), style: .done, target: self, action: #selector(self.Create(sender:)))
        self.navigationItem.largeTitleDisplayMode = .never
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.categoryField.inputView = UIView()
        self.licenseField.inputView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titleField.placeholder = NSLocalizedString("Title", comment: "Title")
        self.categoryField.placeholder = NSLocalizedString("Category", comment: "Category")
        self.licenseField.placeholder = NSLocalizedString("License Type", comment: "License Type")
        self.priceField.placeholder = NSLocalizedString("Price", comment: "Price")
        self.tagField.placeholder = NSLocalizedString("Tags", comment: "Tags")
        imageBtn.backgroundColor = UIColor.mainColor
        
    }
    
    private func createStore(){
        if Connectivity.isConnectedToNetwork(){
            Async.main({
                CreateStoreManager.sharedInstance.createStore(title: self.titleField.text!, tags: self.tagField.text!, license: self.licenseField.text!, price: self.priceField.text!, category: self.categoryField.text!, photo: self.photoImage) { (success, authError, error) in
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
                            self.view.makeToast(error?.localizedDescription)
                            
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func Category(_ sender: Any) {
          self.categoryField.resignFirstResponder()
           let Storyboard = UIStoryboard(name: "Store", bundle: nil)
           let vc = Storyboard.instantiateViewController(withIdentifier: "StoreCategoryVC") as! StoreCategoryController
           vc.delegate = self
           vc.modalPresentationStyle = .fullScreen
           vc.modalTransitionStyle = .crossDissolve
           self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func License(_ sender: Any) {
        self.licenseField.resignFirstResponder()
          let Storyboard = UIStoryboard(name: "Store", bundle: nil)
          let vc = Storyboard.instantiateViewController(withIdentifier: "StoreLicenseVC") as! StoreLicenseController
          vc.delegate = self
          vc.modalPresentationStyle = .fullScreen
          vc.modalTransitionStyle = .crossDissolve
          self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Create(sender:UIBarButtonItem){
        if (self.titleField.text?.isEmpty == true) || (self.titleField.text! == " "){
            self.view.makeToast(NSLocalizedString("Enter Title", comment: "Enter Title"))
        }
        else if (self.categoryField.text?.isEmpty == true) || (self.categoryField.text! == " "){
            self.view.makeToast(NSLocalizedString("Enter Category name", comment: "Enter Category name"))
        }
        else if (self.licenseField.text?.isEmpty == true) || (self.licenseField.text! == " "){
            self.view.makeToast(NSLocalizedString("Enter License name", comment: "Enter License name"))
        }
        else if (self.priceField.text?.isEmpty == true) || (self.priceField.text! == " "){
            self.view.makeToast(NSLocalizedString("Enter Price", comment: "Enter Price"))
        }
        else if (self.tagField.text?.isEmpty == true) || (self.tagField.text! == " "){
            self.view.makeToast(NSLocalizedString("Enter Tag", comment: "Enter Tag"))
        }
        else if (self.photoImage == nil){
            self.view.makeToast(NSLocalizedString("Select Image", comment: "Select Image"))
        }
        else{
            self.showProgressDialog(text: "Loading...")
            self.createStore()
        }

    }
    

    @IBAction func AddImage(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
        vc.delegate = self
        vc.imageType = "photo"
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func uploadImage(imageType: String, image: UIImage) {
        if imageType == "photo"{
        self.imageView.image = image
        let image1 =  image.jpegData(compressionQuality: 0.1)
        self.photoImage = image1
        }
    }
    
    func checkLicenseName(name: String) {
        self.licenseField.resignFirstResponder()
        self.licenseField.text = name
        print("LicenseName",name)
    }
    
    func checkCategoryID(id: Int, name: String) {
        self.categoryField.resignFirstResponder()
        self.categoryField.text = name
        self.cat_Id = id
        print("CategoryField",name,id)
    }
    
}
