//
//  PostByHashTagModel.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 23/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//
 

import Foundation
class PostByHashTagModel:BaseModel{
    
    struct PostByHashTagSuccessModel: Codable {
        let code, status: String?
        let data: [Datum]?
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let postID, userID: Int?
        let datumDescription: String?
        let link: String?
        let youtube, vimeo, dailymotion, playtube: String?
        let mp4, time, type, registered: String?
        let views, boosted: Int?
        let avatar: String?
        let username: String?
        var likes, votes: Int?
        let mediaSet: [MediaSet]?
        let comments: [Comment]?
        var isOwner, isLiked, isSaved, reported: Bool?
        let isVerified: Int?
        let isShouldHide: Bool?
        let userData: UserData?
        let name, timeText: String?
        
        enum CodingKeys: String, CodingKey {
            case postID = "post_id"
            case userID = "user_id"
            case datumDescription = "description"
            case link, youtube, vimeo, dailymotion, playtube, mp4, time, type, registered, views, boosted, avatar, username, likes, votes
            case mediaSet = "media_set"
            case comments
            case isOwner = "is_owner"
            case isLiked = "is_liked"
            case isSaved = "is_saved"
            case reported
            case isVerified = "is_verified"
            case isShouldHide = "is_should_hide"
            case userData = "user_data"
            case name
            case timeText = "time_text"
            
        }
    }
    
    // MARK: - Comment
    struct Comment: Codable {
        let id, userID, postID: Int?
        let text, time, username: String?
        let avatar: String?
        let isOwner: Bool?
        let likes, isLiked, replies: Int?
        let timeText, name: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case postID = "post_id"
            case text, time, username, avatar
            case isOwner = "is_owner"
            case likes
            case isLiked = "is_liked"
            case replies
            case timeText = "time_text"
            case name
        }
    }
    
    // MARK: - MediaSet
    struct MediaSet: Codable {
        let id, postID, userID: Int?
        let file: String?
        let extra: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case postID = "post_id"
            case userID = "user_id"
            case file, extra
        }
    }
    
    // MARK: - UserData
    struct UserData: Codable {
        let userID: Int?
        let username, email, ipAddress, password: String?
        let fname, lname, gender, emailCode: String?
        let language: String?
        let avatar: String?
        let cover: String?
        let countryID: Int?
        let about, google, facebook, twitter: String?
        let website: String?
        let active, admin, verified: Int?
        let lastSeen, registered: String?
        let isPro, posts: Int?
        let pPrivacy, cPrivacy, nOnLike, nOnMention: String?
        let nOnComment, nOnFollow, nOnCommentLike, nOnCommentReply: String?
        let startupAvatar, startupInfo, startupFollow: Int?
        let src, searchEngines, mode, deviceID: String?
        let balance, wallet: String?
        let referrer, profile, businessAccount: Int?
        let paypalEmail, bName, bEmail, bPhone: String?
        let bSite, bSiteAction, name, uname: String?
        let url, edit: String?
        let followers, following: Bool?
        let favourites, postsCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
            case ipAddress = "ip_address"
            case password, fname, lname, gender
            case emailCode = "email_code"
            case language, avatar, cover
            case countryID = "country_id"
            case about, google, facebook, twitter, website, active, admin, verified
            case lastSeen = "last_seen"
            case registered
            case isPro = "is_pro"
            case posts
            case pPrivacy = "p_privacy"
            case cPrivacy = "c_privacy"
            case nOnLike = "n_on_like"
            case nOnMention = "n_on_mention"
            case nOnComment = "n_on_comment"
            case nOnFollow = "n_on_follow"
            case nOnCommentLike = "n_on_comment_like"
            case nOnCommentReply = "n_on_comment_reply"
            case startupAvatar = "startup_avatar"
            case startupInfo = "startup_info"
            case startupFollow = "startup_follow"
            case src
            case searchEngines = "search_engines"
            case mode
            case deviceID = "device_id"
            case balance, wallet, referrer, profile
            case businessAccount = "business_account"
            case paypalEmail = "paypal_email"
            case bName = "b_name"
            case bEmail = "b_email"
            case bPhone = "b_phone"
            case bSite = "b_site"
            case bSiteAction = "b_site_action"
            case name, uname, url, edit, followers, following, favourites
            case postsCount = "posts_count"
        }
    }
}


