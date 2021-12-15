//
//  VerificationController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/6/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class VerificationController: BaseVC,uploadImageDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var passport: UIImageView!
    @IBOutlet weak var nameField: RoundTextField!
    @IBOutlet weak var messageField: RoundTextField!
    @IBOutlet weak var photoBtn: RoundButton!
    @IBOutlet weak var passportBtn: RoundButton!
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var verificationLabel: UILabel!
    @IBOutlet weak var submitBtn: RoundButton!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var imageSV: UIStackView!
    
    var photoImage : Data?
    var passportImage : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // ic_verified
        self.updateUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        submitBtn.backgroundColor = UIColor.mainColor
    }
    
    func updateUI(){
        if AppInstance.instance.userProfile?.data?.verified == 1 {
            
            self.selectLabel.text = NSLocalizedString("Welcome To Bohragram", comment: "Welcome To Bohragram")
            self.verificationLabel.text = NSLocalizedString("Congratulations, you are verified. Thanks for verifying ID", comment: "Congratulations, you are verified. Thanks for verifying ID")
            self.verifiedImageView.isHidden = false
            self.imageSV.isHidden = true
            self.photoBtn.isHidden = true
            self.passportBtn.isHidden = true
            nameField.isHidden = true
            messageField.isHidden = true
            submitBtn.isHidden = true
        }else{
            self.selectLabel.text = NSLocalizedString("Please Select a recent Picture of your Passport or id", comment: "Please Select a recent Picture of your Passport or id")
            self.verificationLabel.text = NSLocalizedString("Verification of the Profile!", comment: "Verification of the Profile!")
            self.verifiedImageView.isHidden = true
            self.imageSV.isHidden = false
            self.photoBtn.isHidden = false
            self.passportBtn.isHidden = false
            nameField.isHidden = false
            messageField.isHidden = false
            submitBtn.isHidden = false
        }
        self.title = NSLocalizedString("Verification", comment: "Verification")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.photoBtn.setTitle(NSLocalizedString("Your Photo", comment: "Your Photo"), for: .normal)
        self.passportBtn.setTitle(NSLocalizedString("Passport", comment: "Passport"), for: .normal)
        self.nameField.placeholder = NSLocalizedString("Name", comment: "Name")
        self.messageField.placeholder = NSLocalizedString("Message", comment: "Message")
        self.submitBtn.setTitle(NSLocalizedString("Request Submit", comment: "Request Submit"), for: .normal)
    }
    
    private func verify(){
        if (self.nameField.text?.isEmpty == true){
            self.view.makeToast(NSLocalizedString("Enter Name", comment: "Enter Name"))
        }
        else if (self.messageField.text?.isEmpty == true){
            self.view.makeToast(NSLocalizedString("Enter message", comment: "Enter message"))
        }
        else if self.photo.image == nil{
            self.view.makeToast(NSLocalizedString("Please add Photo image", comment: "Please add Photo image"))
        }
        else if self.passport.image == nil{
            self.view.makeToast(NSLocalizedString("Please add passport image", comment: "Please add passport image"))
        }
        else {
      //  self.showProgressDialog(text: NSLocalizedString("Lodaing...", comment: "Lodaing..."))
        UserVerificationManager.sharedInstance.userVerify(name: self.nameField.text!, message: self.messageField.text!, photo: photoImage!, passport: passportImage!) { (success, authError, error) in
            
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
            print("successs ...")
        }
            print("successs 2233 ...")
            
            self.showAlert(withTitle: NSLocalizedString("Verification", comment: "Verification"), message: NSLocalizedString("Account Verification Request Submitted Successfully", comment: "Verification Request Submitted Successfully")) {
                self.navigationController?.popViewController(animated: true)

            }
//            self.view.makeToast(NSLocalizedString("Account Verification Request Submitted Successfully", comment: "Verification Request Submitted Successfully"))
           // let vc = R.storyboard.settings.settingVC()
   
      }
        
    }
    
    func showAlert(withTitle title: String, message: String, completion: (() -> Void)? = nil)
    {
        let okAction = UIAlertAction(title: "Ok", style: .default){ (action) in
            completion?()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func uploadImage(imageType: String, image: UIImage) {
        if imageType == "photo"{
        self.photo.image = image
        let image1 =  image.jpegData(compressionQuality: 0.1)
        self.photoImage = image1
        }
        else {
            let image2 =  image.jpegData(compressionQuality: 0.1)
            self.passportImage = image2
            self.passport.image = image
        }
//        self.images.append(image)
        
    }
    
    @IBAction func Submit(_ sender: Any) {
        self.verify()
    }
    
    
    @IBAction func AddImageBtn(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
            vc.delegate = self
            vc.imageType = "photo"
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case 1:
            let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
            vc.delegate = self
            vc.imageType = "passport"
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        default:
            print("Nothing")
        }
    }
    
}
