
//
//  BaseVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 18/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import Toast_Swift
import JGProgressHUD
import SwiftEventBus
import ContactsUI
import Async
import SDWebImage
import PixelPhotoSDK
import GoogleMobileAds


class BaseVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var hud : JGProgressHUD?
    //    var bannerView: GADBannerView!
    //       var interstitial: GADInterstitial!
    
    //    private var noInternetVC: NoInternetDialogVC!
    var userId:String? = nil
    var sessionId:String? = nil
    var contactNameArray = [String]()
    var contactNumberArray = [String]()
    var deviceID:String? = ""
    var interstitial : GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        //        self.deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
        //        noInternetVC = R.storyboard.main.noInternetDialogVC()
        //
        //        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            //            self.CheckForUserCAll()
            //            log.verbose("Internet connected!")
            //            self.noInternetVC.dismiss(animated: true, completion: nil)
            
        }
        
        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            //            log.verbose("Internet dis connected!")
            //                self.present(self.noInternetVC, animated: true, completion: nil)
            
        }
        
        
        
        //        if ControlSettings.shouldShowAddMobBanner{
        //
        //                 bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //                 addBannerViewToView(bannerView)
        //                 bannerView.adUnitID = ControlSettings.addUnitId
        //                 bannerView.rootViewController = self
        //                 bannerView.load(GADRequest())
        //                 interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
        //                 let request = GADRequest()
        //                 interstitial.load(request)
        //
        //             }
        ////////////////////////////////////
        
    }
    //    deinit {
    //        SwiftEventBus.unregister(self)
    //    }
    override func viewWillAppear(_ animated: Bool) {
        //        if !Connectivity.isConnectedToNetwork() {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        ////                self.present(self.noInternetVC, animated: true, completion: nil)
        //            })
        //        }
    }
    func getUserSession(){
        
        log.verbose("getUserSession = \(UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session))")
        let localUserSessionData = UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session)
        
        self.userId = localUserSessionData[Local.USER_SESSION.User_id] as! String
        self.sessionId = localUserSessionData[Local.USER_SESSION.Access_token] as! String
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
    func CreateAd() -> GADInterstitialAd? {
        let interstitial = GADInterstitialAd.load(withAdUnitID: ControlSettings.interestialAddUnitId, request: nil) { (sucess, err) in
            if let error = err{
                print("Failed to load interstitial ad with error:- \(error.localizedDescription)")
                return
            }
            self.interstitial = sucess
            
        }
        return self.interstitial//GADInterstitialAd.load(adUnitID:  ControlSettings.interestialAddUnitId)
     
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}

