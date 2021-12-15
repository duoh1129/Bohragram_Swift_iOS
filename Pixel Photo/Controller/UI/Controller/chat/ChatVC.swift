//
//  ChatVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 29/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import DropDown
import SwiftEventBus
import PixelPhotoSDK
import ActionSheetPicker_3_0
import JGProgressHUD
import BSImagePicker
import Photos

class ChatVC: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTxtViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var contentTblView: UITableView!
    
    var userID:Int? = 0
    var imagePickerController = UIImagePickerController()
    var username:String? = ""
    var lastSeen:String? = ""
    var isAdmin:Int? = 0
    private let moreDropdown = DropDown()
    private var messagesArray = [GetUserChatModel.Message]()
    private var scrollStatus:Bool? = true
    private var messageCount:Int? = 0
    
    var hud : JGProgressHUD?
    //For imagePicker
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    let imagePicker = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.customizeDropdown()
        self.fetchChatList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = true
        }
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchChatList()
            
        }
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabVC = self.tabBarController as? TabbarController {
            tabVC.button.isHidden = false
        }
        self.navigationController?.isNavigationBarHidden = false
        
    }
    deinit {
        SwiftEventBus.unregister(self)
        
    }
    
    @IBAction func uploadImageClicked(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Upload", rows: ["camera", "gallery"], initialSelection: 0, doneBlock: { (picker, index, values) in
            
            
            if index == 0{
                self.imagePickerController.delegate = self
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else{
                self.presentImagePicker(self.imagePicker, select: { (asset) in
                }, deselect: { (asset) in
                    // User deselected an asset. Cancel whatever you did when asset was selected.
                }, cancel: { (assets) in
                    // User canceled selection.
                }, finish: { (assets) in
                    if !(assets.count > 20){
                        for index in 0..<assets.count{
                            let image = self.getAssetThumbnail(asset: assets[index])
                            let imageData = image.jpegData(compressionQuality: 0.1)
                            ChatManager.instance.sendImage(receipent_id: "\(self.userID ?? 0)", imageMimeType: imageData?.mimeType, image_data: imageData) { (success, sessionErr, Err) in
                                if success != nil {
                                    self.fetchChatList()
                                }else if sessionErr != nil {
                                    self.view.makeToast("\(sessionErr?.errors?.errorText ?? "Error sending message")")
                                }else {
                                    self.view.makeToast("Error sending message")
                                }
                            }
//                            ChatManager.instance.sendImage(receipent_id: "\(self.userID)", imageMimeType: imageData?.mimeType, image_data: imageData) { _,_,_ in (success, sessionErr, err)
//                                if success != nil {
//                                    Async.background({
//                                        self.fetchChatList()
//                                    }
//                                }else if sessionErr != nil {
//                                    self.vc.makeToas("Unable to send message")
//                                }else {
//                                    self.vc.makeToast("Error sending image")
//                                }
//                            }
                        }
                    }else{
  
                        self.view.makeToast("Error")
                    }
                })
            }
            
            
            return
            
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                image = result!
            })
            return image
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendPressed(_ sender: Any) {
        if self.messageTxtView.text == "Your Message here..."{
            log.verbose("will not send message as it is PlaceHolder...")
        }else{
            self.sendMessage()
        }
    }
    @IBAction func morePressed(_ sender: Any) {
        self.moreDropdown.show()
    }
    func setupUI(){
        log.verbose("userId = \(self.userID ?? 0)")
        self.usernameLabel.text = self.username ?? ""
        self.timeLabel.text = "last seen \(self.lastSeen ?? "")"
        
        self.contentTblView.separatorStyle = .none
        self.contentTblView.register(R.nib.ppSenderChatItemTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.ppSenderChatItemTableViewCellID.identifier)
        
        self.contentTblView.register(R.nib.ppReceiverChatItemTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.ppReceiverChatItemTableViewCellID.identifier)
        self.contentTblView.register(UINib(nibName: "ChatReceiverImage-TableCell", bundle: nil), forCellReuseIdentifier: "ChatReceiverImage_TableCell")
        self.contentTblView.register(UINib(nibName: "ChatSenderImage-TableCell", bundle: nil), forCellReuseIdentifier: "ChatSenderImage_TableCell")
        self.textViewPlaceHolder()
        self.imageButton.tintColor = .label
        self.messageTxtView.textColor = .label
    }
    
    private func sendMessage(){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageTxtView.text ?? ""
        let recipientId = self.userID ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendMessage(accessToken: accessToken, userId: recipientId, hashId: messageHashId, text: messageText, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if self.messagesArray.count == 0{
                                log.verbose("Will not scroll more")
                                self.textViewPlaceHolder()
                                self.view.resignFirstResponder()
                            }else{
                                self.textViewPlaceHolder()
                                self.view.resignFirstResponder()
                                log.debug("userList = \(success?.code ?? "")")
                                let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                self.contentTblView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                            }
                            
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                            
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            })
        })
    }
    
    private func clearChat(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let accessToken = AppInstance.instance.accessToken ?? ""
        let userID = self.userID ?? 0
        Async.background({
            ChatManager.instance.clearChat(accessToken: accessToken, userId: userID, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            })
        })
    }
    private func blockUser(){
        if self.isAdmin == 1{
            let alert = UIAlertController(title: "", message: "You cannot block this user because it is administrator", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion:nil)
        }else{
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userId = self.userID ?? 0
            Async.background({
                BlockUsersManager.instance.blockUnBlockUsers(accessToken: accessToken, userId: userId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data?.message ?? "")")
                                self.view.makeToast(NSLocalizedString("User has been blocked!", comment: "User has been blocked!"))
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
                
            })
        }
    }
    private func fetchChatList(){
        let userId = self.userID ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        Async.background({
            ChatManager.instance.getUserChats(accessToken: accessToken, userId: userId, limit: 0, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.code ?? "")")
                            self.messagesArray = success?.data.messages ?? []
                            self.messagesArray.reverse()
                            self.contentTblView.reloadData()
                            if self.scrollStatus!{
                                if self.messagesArray.count == 0{
                                    log.verbose("Will not scroll more")
                                }else{
                                    self.scrollStatus = false
                                    self.messageCount = self.messagesArray.count ?? 0
                                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                    self.contentTblView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                }
                            }else{
                                if self.messagesArray.count > self.messageCount!{
                                    
                                    self.messageCount = self.messagesArray.count ?? 0
                                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                    self.contentTblView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                }else{
                                    log.verbose("Will not scroll more")
                                }
                                log.verbose("Will not scroll more")
                                
                            }
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            })
        })
    }
    private func adjustHeight(){
        let size = self.messageTxtView.sizeThatFits(CGSize(width: self.messageTxtView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        messageTxtViewHeightConstraints.constant = size.height
        self.viewDidLayoutSubviews()
        self.messageTxtView.setContentOffset(CGPoint.zero, animated: false)
    }
    private func textViewPlaceHolder(){
        messageTxtView.delegate = self
        messageTxtView.text = NSLocalizedString("Your Message here...", comment: "Your Message here...")
        messageTxtView.textColor = UIColor.lightGray
    }
    
    private func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("Block", comment: "Block") , NSLocalizedString("Clear Chat", comment: "Clear Chat")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.blockUser()
            }else if index == 1{
                self.clearChat()
                
            }
            print("Index = \(index)")
        }
    }
    func showProgressDialog(text: String) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = text
        hud?.show(in: self.view)
    }
    
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
        
    }
}

extension ChatVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustHeight()
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            self.messageTxtView.text = ""
            textView.textColor = UIColor.black
            
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message here..."
            textView.textColor = UIColor.lightGray
            
            
        }
    }
    
    func setLocalDate(timeStamp: String?) -> String{
        guard let time = timeStamp else { return "" }
        let localTime = Double(time) //else { return ""}
        let date = Date(timeIntervalSince1970: localTime!)
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "h:mm a "
        format.amSymbol = "AM"
        format.pmSymbol = "PM"
        let currentDateStr = format.string(from: date)
        return currentDateStr
    }
}

extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.messagesArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = self.messagesArray[indexPath.row]
        print("====== \(object)")
        if object.mediaType == "image" || object.mediaFile != ""{
            
            if object.position == "right" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderImage_TableCell", for: indexPath) as! ChatSenderImage_TableCell
                cell.selectionStyle = .none
                cell.fileImage.isHidden = false
                cell.videoView.isHidden = true
                cell.playBtn.isHidden = true
                let url = URL.init(string:object.mediaFile ?? "")
                cell.fileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "img_profile_placeholder"))
                var time = object.timeText//setLocalDate(timeStamp: object.time)
                if object.seen != "0" {
                    time += "  seen"
                }
                cell.timeLabel.text = time
                cell.backView.backgroundColor = UIColor.mainColor
                cell.backgroundColor = .clear
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverImage_TableCell", for: indexPath) as! ChatReceiverImage_TableCell
                cell.selectionStyle = .none
                cell.fileImage.isHidden = false
                cell.videoView.isHidden = true
                cell.playBtn.isHidden = true
                let url = URL.init(string:object.mediaFile ?? "")
                cell.fileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "img_profile_placeholder"))
                cell.timeLabel.text = object.timeText
                cell.backgroundView?.backgroundColor = UIColor.mainColor
                cell.backgroundColor = .clear
                return cell
            }
        }else {
            if object.position == "right" {
                let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.ppSenderChatItemTableViewCellID.identifier ) as! PPSenderChatItemTableViewCell
                
                cell.messageTxtView.text = object.text ?? ""
                cell.timeLbl.text =  object.timeText ?? ""
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ppReceiverChatItemTableViewCellID.identifier) as! PPReceiverChatItemTableViewCell
            cell.messageTxtView.text = object.text ?? ""
            cell.timeLbl.text =  object.timeText ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func sendImageMsg(){
//        ChatManager.instance.send
    }
    
}
extension ChatVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image:UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            log.verbose("image = \(image ?? nil)")
            let imageData = image?.jpegData(compressionQuality: 0.1)
            log.verbose("MimeType = \(imageData?.mimeType)")
            
            ChatManager.instance.sendImage(receipent_id: "\(self.userID ?? 0)", imageMimeType: imageData?.mimeType, image_data: imageData) { (success, sessionErr, Err) in
                if success != nil {
                    self.fetchChatList()
                }else if sessionErr != nil {
                    self.view.makeToast("\(sessionErr?.errors?.errorText ?? "Error sending message")")
                }else {
                    self.view.makeToast("Error sending message")
                }
            }
        }
        
        if let fileURL:URL? = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            if let url = fileURL {
                let videoData = try? Data(contentsOf: url)
                log.verbose("MimeType = \(videoData?.mimeType)")
                print(videoData?.mimeType)
//                sendSelectedData(imageData: nil, videoData: videoData, imageMimeType: nil, VideoMimeType: videoData?.mimeType, Type: "video", fileData: nil, fileExtension: nil, FileMimeType: nil)
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
