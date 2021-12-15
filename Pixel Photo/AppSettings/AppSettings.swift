//
//  AppSettings.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 18/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import Foundation
import UIKit
import PixelPhotoSDK
struct AppConstant {
    static let key = "VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OalJteHhVMjA1YkZadGVGbFhhMmh6VjJ4YU5sRnFSbGhXUldzeFdrVldNMlZXVG5SaFJuQk9ZbXhLZWxkWE1IaFZiRUpTVUZRd1BTTldNakYzWW1zeFZrNVZhRk5pV0ZKUVZXdFdjMDFHVVhoVmF6Vk9VbTE0ZDFSVlVrTlViVlp5Vmxoa1ZWSnNTbmxVVkVGNFpFWlNXVlZyTlU1aE0wSXdWakZrZDFKdFZrWk5WbFpVWWxoQ1lWbHNXbFpOUVQwOVFERTFNems0TnpReE9EWWtNak16TVRnNU9UYz0="
}

struct ControlSettings {
    static let ShowFacebookLogin = false
    static let ShowGoogleLogin = false
    
    static let Show_ADMOB_Banner = false
    static let Show_ADMOB_Interstitial = false
    static let Show_ADMOB_RewardVideo = false
    
    static let addUnitId = "ca-app-pub-8388902143139352/2339698394"
    static let  interestialAddUnitId = "ca-app-pub-8388902143139352/7017310004"
    static let googleClientKey = "497109148599-u0g40f3e5uh53286hdrpsj10v505tral.apps.googleusercontent.com"
    static let oneSignalAppId = "b0f9d7c8-ce9b-4e67-8ba2-8fdcfd894314"
    static var shouldShowAddMobBanner:Bool = false
    static var interestialCount:Int? = 3
    static let  HelpLink = "\(API.baseURL)/contact_us"
    static let  reportlink = "\(API.baseURL)/contact_us"
    static let  termsOfUse = "\(API.baseURL)/terms-of-use"
    static let  privacyPolicy = "\(API.baseURL)/privacy-and-policy"
    static let BrainTreeURLScheme = "com.DeepSound.ScripSun.App.payments"
    static let paypalAuthorizationToken = "sandbox_zjzj7brd_fzpwr2q9pk2m568s"
    
    
    
    static let Show_ADMOB_Interstitial_Count = 3
    static let Show_ADMOB_RewardedVideo_Count = 3
    
    static let RunSoundControl = false
    static let RefreshChatActivitiesSeconds = 60
    
    static let ShowNotification = true
    
    static let ShowGalleryImage = true
    static let ShowGalleryVideo = true
    static let ShowMention = true
    static let ShowCamera = true
    static let ShowGif = true
    static let ShowEmbedVideo = true
    static let ShowBio = true
    
    static let EnableSocialLogin = false
    
    static let ShowSettingsGeneralAccount = true
    static let ShowSettingsAccountPrivacy = true
    static let ShowSettingsPassword = true
    static let ShowSettingsBlockedUsers = true
    static let ShowSettingsNotifications = false
    static let ShowSettingsDeleteAccount = true
    static let ShowSettingsWithdrawals = false
    static let ShowSettingsAffilities = false
    
    
}

extension UIColor {
    
    @nonobjc class var mainColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#f65599")
    }
    
    @nonobjc class var startColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#f65599")
    }
    
    @nonobjc class var buttonColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#f65599")
    }
    
    @nonobjc class var endColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#4d0316")
    }
}
