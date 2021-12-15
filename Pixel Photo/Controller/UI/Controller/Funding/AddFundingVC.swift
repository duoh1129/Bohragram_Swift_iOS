//
//  AddFundingVC.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/30/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
class AddFundingVC: BaseVC {
    
    @IBOutlet weak var descriptionTextFiled: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    
    private let imagePickerController = UIImagePickerController()
    private var imageData:Data? = nil
    
    var dataObject:FetchFundingModel.Datum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if self.dataObject != nil{
            self.editFunding(ImageData: self.imageData!)
        }else{
            self.addFunding(ImageData: self.imageData!)

        }
    }
    private func setupUI(){
        
        if self.dataObject != nil{
            self.title = NSLocalizedString("Update Funding", comment: "Update Funding")
            self.titleTextField.text = dataObject?.title ?? ""
            self.descriptionTextFiled.text = dataObject?.datumDescription ?? ""
            self.priceTextField.text = dataObject?.amount ?? ""
            let coverImage = URL(string: dataObject?.image ?? "")
            self.coverImage.sd_setImage(with: coverImage , placeholderImage:R.image.img_item_placeholder())
            self.imageData = self.coverImage.image?.jpegData(compressionQuality: 0.2)
            
        }else{
            self.title = NSLocalizedString("Funding Request", comment: "Funding Request")
        }
        let tapGesture1 = UITapGestureRecognizer(target: self, action:#selector(self.coverImageHandleTap))
        coverImage.addGestureRecognizer(tapGesture1)
    }
    @IBAction func selectImagePressed(_ sender: Any) {
        self.coverImageHandleTap()
    }
    @objc func coverImageHandleTap(){
        log.verbose("thanks ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    private func addFunding(ImageData:Data?){
        if self.titleTextField.text!.isEmpty{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter title."
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else  if self.priceTextField.text!.isEmpty{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter amount"
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else  if self.descriptionTextFiled.text!.isEmpty{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter description"
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else  if self.imageData == nil{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please select atleast one Image."
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else {
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let title = self.titleTextField.text ?? ""
            let description = self.descriptionTextFiled.text ?? ""
            let amount = Int(self.priceTextField.text ?? "")
            let imageData = ImageData ?? Data()
            if Connectivity.isConnectedToNetwork(){
                let coverImageData = imageData ?? Data()
                Async.background({
                    FundingManager.instance.createFunding(AccesToken: accessToken, title: title, amount: amount ?? 0, Description: description, fundingImageData: imageData) { (success, sessionError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("success = \(success?.code ?? "")")
                                    self.view.makeToast("Funding has been Added.")
                                    self.navigationController?.popViewController(animated: true)
                                }
                            })
                            
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                    self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                }
                            })
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                            })
                        }
                    }
                })
            }else{
                log.error("internetErrro = \(InterNetError)")
                self.view.makeToast(InterNetError)
            }
        }
    }
    private func editFunding(ImageData:Data?){
        if self.titleTextField.text!.isEmpty{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter title."
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else  if self.priceTextField.text!.isEmpty{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter amount"
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else  if self.descriptionTextFiled.text!.isEmpty{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter description"
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else  if self.imageData == nil{
            let securityAlertVC = R.storyboard.popup.securityPopupVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please select atleast one Image."
            self.present(securityAlertVC!, animated: true, completion: nil)
        }else {
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let title = self.titleTextField.text ?? ""
            let description = self.descriptionTextFiled.text ?? ""
            let amount = Int(self.priceTextField.text ?? "")
            let id = self.dataObject?.id ?? 0
            let imageData = ImageData ?? Data()
            if Connectivity.isConnectedToNetwork(){
                let coverImageData = imageData ?? Data()
                Async.background({
                    FundingManager.instance.editFunding(AccesToken: accessToken, id: id, title: title, amount: amount ?? 0, Description: description, fundingImageData: imageData) { (success, sessionError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("success = \(success?.code ?? "")")
                                    self.view.makeToast("Funding has been updated.")
                                    self.navigationController?.popViewController(animated: true)
                                }
                            })
                            
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                    self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                }
                            })
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                            })
                        }
                    }
                })
            }else{
                log.error("internetErrro = \(InterNetError)")
                self.view.makeToast(InterNetError)
            }
        }
    }
}

extension  AddFundingVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.coverImage.image = image
        self.imageData = self.coverImage.image?.jpegData(compressionQuality: 0.2)
        self.addFunding(ImageData: self.imageData)
        self.dismiss(animated: true, completion: nil)
        
    }
}
