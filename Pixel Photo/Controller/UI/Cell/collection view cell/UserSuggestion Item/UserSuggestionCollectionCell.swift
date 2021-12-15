//
//  UserSuggestionCollectionCell.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 21/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
class UserSuggestionCollectionCell: UICollectionViewCell {
    @IBOutlet weak var followBtn: RoundButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    var vc:UserSuggestionVC?
    var vc1:PPHorizontalCollectionviewItemTableViewCell?
    var userId : Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //        self.profileImgView.isCircular()
        self.containerView.addShadow()
        self.followBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: UIControl.State.normal)
        
        self.followBtn.borderColor = .mainColor
        self.followBtn.setTitleColor(.mainColor, for: .normal)
        
        //        self.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    
    
    @IBAction func followPressed(_ sender: Any) {
        followUnFollow()
    }
    
    private func followUnFollow(){
        if vc != nil{
            if self.vc!.appDelegate.isInternetConnected{
                let accessToken = AppInstance.instance.accessToken ?? ""
                let userID = self.userId ?? 0
                
                Async.background({
                    FollowUnFollowManager.instance.followUnFollow(accessToken: accessToken, userId: userID, completionBlock: { (success, sessionError, error) in
                        if success != nil{
                            Async.main({
                                log.verbose("Success = \(success?.type!)")
                                if success?.type ?? 0 == 1{
                                    self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "backGr1"), for: .normal)
                                    self.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                                    self.followBtn.borderColor = .clear
                                    self.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
                                }else{
                                    
                                    self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#73348D"), for: UIControl.State.normal)
                                    self.followBtn.setBackgroundImage(nil, for: .normal)
                                    self.followBtn.borderColor = UIColor.hexStringToUIColor(hex: "73348D")
                                    self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "73348D"), for: .normal)
                                    self.followBtn.setTitle(NSLocalizedString("Follow", comment: ""), for: UIControl.State.normal)
                                }
                                
                            })
                        }else if sessionError != nil{
                            Async.main({
                                
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.vc!.view.makeToast(sessionError?.errors?.errorText ?? "")
                            })
                            
                        }else {
                            Async.main({
                                log.error("error = \(error?.localizedDescription ?? "")")
                                self.vc!.view.makeToast(error?.localizedDescription ?? "")
                            })
                        }
                    })
                })
            }else{
                log.error(InterNetError)
                self.vc!.view.makeToast(InterNetError)
            }
        }else{
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let userID = self.userId ?? 0
            
            Async.background({
                FollowUnFollowManager.instance.followUnFollow(accessToken: accessToken, userId: userID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.verbose("Success = \(success?.type!)")
                            if success?.type ?? 0 == 1{
                                
                                //                                    self.followBtn.backgroundColor = UIColor.startColor
                                self.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                                let l2 = CAGradientLayer()
                                l2.colors = [UIColor.hexStringToUIColor(hex: "#73348D").cgColor, UIColor.hexStringToUIColor(hex: "#D83880").cgColor]
                                l2.startPoint = CGPoint(x: 0, y: 0.5)
                                l2.endPoint = CGPoint(x: 1, y: 0.5)
                                l2.frame = self.followBtn.bounds
                                self.followBtn.layer.insertSublayer(l2, at: 0)
                                
                                self.followBtn.setTitle(NSLocalizedString("Following", comment: ""), for: UIControl.State.normal)
                            }else{
                                //                                self.followBtn.applyGradient(colours: [UIColor.white , UIColor.white], start:  CGPoint(x: 0.0, y: 1.0), end:  CGPoint(x: 1.0, y: 1.0), borderColor: UIColor.mainColor)
                                self.followBtn.setTitleColor(UIColor.mainColor, for: UIControl.State.normal)
                                self.followBtn.setTitle(NSLocalizedString("Follow", comment: ""), for: UIControl.State.normal)
                            }
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            self.vc1!.contentView.makeToast(sessionError?.errors?.errorText ?? "")
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                            self.vc1!.contentView.makeToast(error?.localizedDescription ?? "")
                        })
                    }
                })
            })
            
        }
        
    }
}


