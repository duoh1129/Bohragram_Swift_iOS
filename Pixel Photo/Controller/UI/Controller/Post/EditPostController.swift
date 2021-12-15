//
//  EditPostController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/18/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class EditPostController: BaseVC,UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var caption = ""
    var post_id: Int? = nil
    var delegate: EditPostDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("Edit Post", comment: "Edit Post")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        //        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem =
            UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.Save(sender:)))
        if caption == "" {
            self.textView.text! = NSLocalizedString("Add post caption, #hashtag.. @mention?", comment: "Add post caption, #hashtag.. @mention?")
        }
        else{
            self.textView.text! = self.caption
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == NSLocalizedString("Add post caption, #hashtag.. @mention?", comment: "Add post caption, #hashtag.. @mention?"){
            textView.text = nil
            self.textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Add post caption, #hashtag.. @mention?", comment: "Add post caption, #hashtag.. @mention?")
            self.caption = ""
        }
    }
    
    private func editPost(){
        EditPostManager.sharedInsatnce.editPost(text: self.caption, post_id: self.post_id ?? 0) { (success, authError, error) in
            if (success != nil){
                self.view.makeToast(success?.message)
                self.dismissProgressDialog {
                    self.delegate.editPost(text: self.caption)
                    self.navigationController?.popViewController(animated: true)
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
    }

    @IBAction func Save(sender:UIBarButtonItem){
        if (self.textView.text! == NSLocalizedString("Add post caption, #hashtag.. @mention?", comment: "Add post caption, #hashtag.. @mention?")){
            self.caption = ""
        }
        else{
            self.caption = self.textView.text ?? ""
        }
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        self.editPost()
    }
    
}
