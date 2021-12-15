//
//  SignUpVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 18/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
import DropDown
import DialCountries

class SignUpVC: BaseVC, uploadImageDelegate{
    
    @IBOutlet weak var createAccountLbl: UILabel!
    @IBOutlet weak var termServicesBtn: UIButton!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var confirmPasswordTxtfld: UITextField!
    @IBOutlet weak var registeringTermsLbl: UILabel!
    @IBOutlet weak var alreadyHaveAnAccountLbl: UILabel!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var dobButton: UIButton!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var verificationImageView: UIImageView!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var verificationDoCButton: UIButton!
    @IBOutlet weak var selfieButton: UIButton!
    
    var picker  = UIPickerView()
    var textfield = UITextField()
    
    var datePicker = UIDatePicker()
    var dateTF = UITextField()
    
    var genderArr = ["Select Gender","Male","Female"]
    let utcTime = "yyyy-MM-dd HH:mm:ss"
    let kDateFormat_App = "yyyy-MM-dd"
    var imageSelected = 0
    
    var verificationImage : Data?
    var selfieImage : Data?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.registerView.isRoundedRect(cornerRadius: 5)
        //        self.registerView.applyGradient(colours: [UIColor.startColor, UIColor.endColor], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0), borderColor: UIColor.clear)
        let l1 = CAGradientLayer()
        l1.colors = [UIColor.hexStringToUIColor(hex: "#73348D").cgColor, UIColor.hexStringToUIColor(hex: "#D83880").cgColor]
        l1.startPoint = CGPoint(x: 0, y: 0.5)
        l1.endPoint = CGPoint(x: 1, y: 0.5)
        l1.frame = self.registerView.bounds
        self.registerView.layer.insertSublayer(l1, at: 0)
    }
    
    
    @IBAction func signInPressed(_ sender: Any) {
        let vc = R.storyboard.main.loginVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func TermAndServicesPressed(_ sender: Any) {
    }
    
    func setupUI(){
        self.navigationController?.isNavigationBarHidden = false
        self.title = NSLocalizedString("Register", comment: "")
        
        self.emailTxtFld.placeholder = NSLocalizedString("Email", comment: "")
        self.usernameTxtFld.placeholder = NSLocalizedString("Username", comment: "")
        self.passwordTxtFld.placeholder = NSLocalizedString("Password", comment: "")
        self.confirmPasswordTxtfld.placeholder = NSLocalizedString("Confirm Password", comment: "")
        self.createAccountLbl.text = NSLocalizedString("CREATE AN ACCOUNT", comment: "")
        self.registeringTermsLbl.text = NSLocalizedString("BY REGISTERING YOU AGREE TO OUR", comment: "")
        self.termServicesBtn.setTitle(NSLocalizedString("TERMS AND SERVICES", comment: ""), for: UIControl.State.normal)
        self.alreadyHaveAnAccountLbl.text = NSLocalizedString("ALREADY HAVE AN ACCOUNT?", comment: "")
        self.signInBtn.setTitle(NSLocalizedString("SIGN IN", comment: ""), for: UIControl.State.normal)
        
        let registertap = UITapGestureRecognizer(target: self, action: #selector(self.registerTapped(_:)))
        self.registerView.isUserInteractionEnabled = true
        self.registerView.addGestureRecognizer(registertap)
        
        self.view.addSubview(textfield)
        self.view.addSubview(dateTF)
        picker.delegate = self
        picker.dataSource = self
        textfield.inputView = picker
        
        dateTF.delegate = self
        dateTF.inputView = datePicker
        textfield.text = self.utcToLocalDate(date: Date(), currentFormat: utcTime, convertedFormat: kDateFormat_App)
        self.dobButton.setTitle(textfield.text ?? "", for: .normal)
        self.dobButton.setTitleColor(.black, for: .normal)
        datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: datePicker.date)
        self.dobButton.setTitle(str , for: .normal)
    }
    
    func utcToLocalDate( date:Date,currentFormat : String? , convertedFormat : String?) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = currentFormat
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter1.dateFormat = convertedFormat
        dateFormatter1.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter1.string(from: date)
        return timeStamp
    }
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //
    //
    //    }
    
    @IBAction func verificationDocImageButonAction(_ sender: Any) {
        //        self.imageSelected = 1
        //        self.addImageFromGallery {
        //
        //        }
        let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
        vc.delegate = self
        vc.imageType = "photo"
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func selfiButtonAction(_ sender: Any) {
        //        self.imageSelected = 2
        //        self.addImageFromGallery {
        //
        //        }
        let Storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
        vc.delegate = self
        vc.imageType = "passport"
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func uploadImage(imageType: String, image: UIImage) {
        if imageType == "photo"{
            self.verificationImageView.image = image
            let image1 =  image.jpegData(compressionQuality: 0.1)
            self.verificationImage = image1
        } else {
            let image2 =  image.jpegData(compressionQuality: 0.1)
            self.selfieImage = image2
            self.selfieImageView.image = image
        }
    }
    
    
    @IBAction func genderButtonAction(_ sender: Any) {
        textfield.becomeFirstResponder()
        picker.reloadAllComponents()
    }
    @IBAction func dobButtonAction(_ sender: Any) {
        dateTF.inputView = datePicker
        datePicker.tag = 1
        textfield.tag = 1
        datePicker.datePickerMode = .date
        dateTF.becomeFirstResponder()
        
    }
    
    @IBAction func countryButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            let cv = DialCountriesController(locale: Locale.current)
            cv.delegate = self
            cv.show(vc: self)
        }
    }
    
    
    @objc func registerTapped(_ sender: UITapGestureRecognizer) {
        registerPressed()
    }
    
    private func registerPressed(){
        if appDelegate.isInternetConnected{
            if (self.emailTxtFld.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter email.", comment: "Please enter email.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.usernameTxtFld.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter username.", comment: "Please enter username.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.passwordTxtFld.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter password.", comment: "Please enter password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.confirmPasswordTxtfld.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter confirm password.", comment: "Please enter confirm password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.passwordTxtFld.text != self.confirmPasswordTxtfld.text){
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = "Password do not match."
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if !((emailTxtFld.text?.isEmail)!){
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Email is badly formatted.", comment: "Email is badly formatted.")
                self.present(securityAlertVC!, animated: true, completion: nil)
            } else if (phoneNumTF.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter phone number.", comment: "Please enter phone number.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            } else if countryButton.currentTitle == "Select Country"{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please select the country.", comment: "Please select the country.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            } else if genderButton.currentTitle == "Select Gender"{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please select the gender.", comment: "Please select the gender.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            } else if self.verificationImage == nil{
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please add Verification image", comment: "Please add Verification image")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }
            else if self.selfieImage == nil{
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please add Selfie image", comment: "Please add Selfie image")
                self.present(securityAlertVC!, animated: true, completion: nil)
            } else{
                    // Sign Up to Welcome
                    self.registerPressedfunc()
                    //                let alert = UIAlertController(title: "Sign Up to Welcome", message: NSLocalizedString("By registering you agree to our terms of service", comment: "By registering you agree to our terms of service"), preferredStyle: .alert)
                    //                let okay = UIAlertAction(title: NSLocalizedString("OKAY", comment: "OKAY"), style: .default) { (action) in
                    //                    self.registerPressedfunc()
                    //                }
                    //                let termsOfService = UIAlertAction(title: "TERMS OF SERVICE", style: .default) { (action) in
                    //                    let url = URL(string: ControlSettings.termsOfUse)!
                    //                    if UIApplication.shared.canOpenURL(url) {
                    //                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    //
                    //                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    //                            print("Open url : \(success)")
                    //                        })
                    //                    }
                    //                }
                    //                let privacy = UIAlertAction(title: NSLocalizedString("PRIVACY", comment: "PRIVACY"), style: .default) { (action) in
                    //                    let url = URL(string: ControlSettings.privacyPolicy)!
                    //                    if UIApplication.shared.canOpenURL(url) {
                    //                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    //
                    //                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    //                            print("Open url : \(success)")
                    //                        })
                    //                    }
                    //                }
                    //                alert.addAction(termsOfService)
                    //                alert.addAction(privacy)
                    //                alert.addAction(okay)
                    //                self.present(alert, animated: true, completion: nil)
                }
                
            }else{
                self.dismissProgressDialog {
                    let securityAlertVC = R.storyboard.popup.securityPopupVC()
                    securityAlertVC?.titleText  = NSLocalizedString("Internet Error ", comment: "Internet Error ")
                    securityAlertVC?.errorText = InterNetError
                    self.present(securityAlertVC!, animated: true, completion: nil)
                    log.error("internetError - \(InterNetError)")
                }
            }
        }
        
        private func registerPressedfunc(){
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let username = self.usernameTxtFld.text ?? ""
            let email = self.emailTxtFld.text ?? ""
            let password = self.passwordTxtFld.text ?? ""
            // let confirmPassword = self.confirmPasswordTxtfld.text ?? ""
            let gender = self.genderButton.titleLabel?.text ?? ""
            let dob = self.dobButton.titleLabel?.text ?? ""
            let country = self.countryButton.titleLabel?.text ?? ""
            let phoneNum = self.phoneNumTF.text ?? ""
            
            
            Async.background({
                UserManager.instance.registerUser(userName: username, password: password, email: email, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main{
                            self.dismissProgressDialog{ [self] in
                                log.verbose("Success = \(success?.data?.accessToken ?? "")")
                                var saveSettingDict = [String:String]()
                                if AppInstance.instance.getUserSession(){
                                    saveSettingDict = ["gender": "\(gender.lowercased())", "phone_number": "\(phoneNum)","date_of_waras": "\(dob.lowercased())", "country": "\(country)",API.PARAMS.server_key:API.SERVER_KEY.serverKey ?? "", API.PARAMS.access_token:AppInstance.instance.accessToken ?? ""]
                                }
                                UserManager.instance.saveSettingUser(dict: saveSettingDict, completionBlock: { (success, sessionError, error) in
                                    if success != nil{
                                        if self.verificationImageView.image == nil{
                                            self.view.makeToast(NSLocalizedString("Please add Photo image", comment: "Please add Photo image"))
                                        }
                                        else if self.selfieImageView.image == nil{
                                            self.view.makeToast(NSLocalizedString("Please add passport image", comment: "Please add passport image"))
                                        }
                                        else {
                                            //self.showProgressDialog(text: NSLocalizedString("Lodaing...", comment: "Lodaing..."))
                                            UserVerificationManager.sharedInstance.userVerify(name: username, message: "Registration Request", photo: verificationImage!, passport: selfieImage!) { (success, authError, error) in
                                                if success != nil{
                                                    print(".......... success ..........")
                                                    let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                                    securityAlertVC?.titleText  = NSLocalizedString("Welcome", comment: "Welcome")
                                                    securityAlertVC?.errorText = NSLocalizedString("Your request is submitted and within 24hours you will be notified", comment: "Your request is submitted and within 24hours you will be notified")
                                                    self.present(securityAlertVC!, animated: true, completion: nil)
                                                    //                                            self.dismissProgressDialog {
                                                    //                                                self.view.makeToast(success?.status)
                                                    //                                            }
                                                }
                                                else if (authError != nil){
                                                    //                                            self.dismissProgressDialog {
                                                    //                                                self.view.makeToast(authError?.errors?.errorText)
                                                    //                                            }
                                                }
                                                else if (error != nil){
                                                    //                                            self.dismissProgressDialog {
                                                    //                                                self.view.makeToast(error?.localizedDescription)
                                                    //                                            }
                                                }
                                                print("Success1111")
                                            }
                                            print("Success2222")
                                            self.showAlert(withTitle: NSLocalizedString("Welcome", comment: "Welcome"), message: NSLocalizedString("Your request is submitted and within 24hours you will be notified", comment: "Your request is submitted and within 24hours you will be notified")) {
                                                let vc = R.storyboard.main.loginVC()
                                                log.verbose("Tapped")
                                                self.navigationController?.pushViewController(vc!, animated: true)
                                            }
                                        }
                                        
                                    }
                                    
                                })
                                
                                AppInstance.instance.fetchUserProfile()
                                UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
                                
                                //                            let vc = R.storyboard.profile.editProfileVC()
                                //                            self.navigationController?.pushViewController(vc!, animated: true)
                                //   self.view.makeToast("Login Successfull!!")
                            }
                            
                        }
                        
                    }else if sessionError != nil{
                        Async.main{
                            
                            self.dismissProgressDialog {
                                log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
                                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                securityAlertVC?.titleText = NSLocalizedString("Security", comment: "Security")
                                securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                            }
                        }
                        
                    }else {
                        Async.main({
                            
                            self.dismissProgressDialog {
                                log.verbose("error = \(error?.localizedDescription ?? "")")
                                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                            }
                        })
                    }
                })
            })
        }
    }
    
    
extension SignUpVC: DialCountriesControllerDelegate {
        func didSelected(with country: Country) {
            print(country)
            self.countryButton.setTitle(country.name, for: .normal)
        }
        
        
    }
    
    
    //MARK:- picker delegate methods
extension SignUpVC : UIPickerViewDataSource, UIPickerViewDelegate {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.genderArr.count
        }
        
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            return self.genderArr[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {
            if (textfield.tag == 1)
            {
                self.dobButton.setTitle("\(textfield.text ?? "")", for: .normal)
                self.dobButton.setTitleColor(.black, for: .normal)
            }
            else{
                self.genderButton.setTitle("\(self.genderArr[row])", for: .normal)
                self.genderButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate,UITextFieldDelegate{
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if (info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String) != nil {
                let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
                if imageSelected == 1 {
                    self.verificationImageView.image = image
                }else if imageSelected == 2 {
                    self.selfieImageView.image = image
                    
                }
                picker.dismiss(animated: true) {}
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
        
        func addImageFromGallery(completion : @escaping ()->(Void)) {
            let alertController = UIAlertController(title: "Choose Media", message: nil, preferredStyle: .actionSheet);
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            let galleryAction = UIAlertAction(title: "Add Image", style: .default){ (action) in
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                picker.mediaTypes = ["public.image"]
                self.navigationController?.present(picker, animated: true, completion: nil)
            }
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                
                if (UIImagePickerController.isSourceTypeAvailable(.camera))
                {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = .camera
                    picker.mediaTypes = ["public.image"]
                    self.navigationController?.present(picker, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(galleryAction)
            alertController.addAction(cameraAction)
            alertController.addAction(cancelAction)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
