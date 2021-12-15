//
//  ActivitiesModel.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 2/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
class ActivitiesModel:BaseModel{
    struct ActivitiesSuccessModel: Codable {
        let code, status: String?
        let data: [Datum]?
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id, userID, postID, followingID: Int?
        let type: String?
        let time: String?
        let userData: UserDataClass? = nil
        let activityLink: String?
        let text: String?
        let followingData: FollowingData? = nil
        let postData: PostDataUnion? = nil
        
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case postID = "post_id"
            case followingID = "following_id"
            case type, time
            case userData = "user_data"
            case activityLink = "activity_link"
            case text
            case followingData = "following_data"
            case postData = "post_data"
        }
    }
    
    enum FollowingData: Codable {
        case string(String)
        case userDataClass(UserDataClass)
        var stringValue : String? {
                   guard case let .string(value) = self else { return nil }
                   return value
               }
               
               var userDataClassValue : UserDataClass? {
                   guard case let .userDataClass(value) = self else { return nil }
                   return value
               }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            if let x = try? container.decode(UserDataClass.self) {
                self = .userDataClass(x)
                return
            }
            throw DecodingError.typeMismatch(FollowingData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FollowingData"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let x):
                try container.encode(x)
            case .userDataClass(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - UserDataClass
    struct UserDataClass: Codable {
        let userID: Int?
        let username, email: String?
        let password, fname, lname: String?
        let emailCode: String?
        let language: Language?
        let avatar: String?
        let cover: Cover?
        let countryID: Int?
        let about: String?
        let google, facebook, twitter: String?
        let website: String?
        let active, admin, verified: Int?
        let lastSeen: String?
        let registered: Registered?
        let isPro, posts: Int?
        let pPrivacy, cPrivacy, nOnLike, nOnMention: String?
        let nOnComment, nOnFollow, nOnCommentLike, nOnCommentReply: String?
        let startupAvatar, startupInfo, startupFollow: Int?
        let src: Src?
        let searchEngines: String?
        let mode: Mode?
        let deviceID, balance, wallet: String?
        let referrer, profile, businessAccount: Int?
        let paypalEmail, bName, bEmail, bPhone: String?
        let bSite, bSiteAction, name, uname: String?
        let url, edit: String?
        let followers, following, favourites, postsCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
            case password, fname, lname
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
    
    enum About: String, Codable {
        case empty = ""
        case thisIsBrBrMe = "This is  <br> <br>Me ?"
    }
    
    enum Cover: String, Codable {
        case mediaImgDCoverJpg = "media/img/d-cover.jpg"
    }
    
    enum Gender: String, Codable {
        case male = "male"
    }
    
    enum IPAddress: String, Codable {
        case empty = ""
        case the0000 = "0.0.0.0"
        case the122175120213 = "122.175.120.213"
        case the191106171129 = "191.106.171.129"
    }
    
    enum Language: String, Codable {
        case arabic = "arabic"
        case english = "english"
    }
    
    enum Mode: String, Codable {
        case day = "day"
    }
    
    enum Registered: String, Codable {
        case the00000 = "0000/0"
        case the20187 = "2018/7"
        case the201911 = "2019/11"
    }
    
    enum Src: String, Codable {
        case empty = ""
        case facebook = "Facebook"
    }
    
    enum PostDataUnion: Codable {
        case postDataClass(PostDataClass)
        case string(String)
        var stringValue : String? {
            guard case let .string(value) = self else { return nil }
            return value
        }
        
        var postDataClassValue : PostDataClass? {
            guard case let .postDataClass(value) = self else { return nil }
            return value
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            if let x = try? container.decode(PostDataClass.self) {
                self = .postDataClass(x)
                return
            }
            throw DecodingError.typeMismatch(PostDataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PostDataUnion"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .postDataClass(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - PostDataClass
    struct PostDataClass: Codable {
        let postID, userID: Int?
        let postDataDescription: String?
        let link: String?
        let youtube, vimeo, dailymotion, playtube: String?
        let mp4: JSONNull?
        let time, type, registered: String?
        let views, boosted: Int?
        let avatar: String?
        let username: String?
        let likes, votes: Int?
        let mediaSet: [MediaSet]?
        let comments: [Comment]?
        let isOwner, isLiked, isSaved, reported: Bool?
        let userData: UserData?
        let isVerified: Int?
        let isShouldHide: Bool?
        let name, timeText: String?
        
        enum CodingKeys: String, CodingKey {
            case postID = "post_id"
            case userID = "user_id"
            case postDataDescription = "description"
            case link, youtube, vimeo, dailymotion, playtube, mp4, time, type, registered, views, boosted, avatar, username, likes, votes
            case mediaSet = "media_set"
            case comments
            case isOwner = "is_owner"
            case isLiked = "is_liked"
            case isSaved = "is_saved"
            case reported
            case userData = "user_data"
            case isVerified = "is_verified"
            case isShouldHide = "is_should_hide"
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
        let file, extra: String?
        
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
        let username, email, password: String?
        let fname, lname, gender, emailCode: String?
        let language: Language?
        let avatar: String?
        let cover: Cover?
        let countryID: Int?
        let about: String?
        let google, facebook, twitter, website: String?
        let active, admin, verified: Int?
        let lastSeen, registered: String?
        let isPro, posts: Int?
        let pPrivacy, cPrivacy, nOnLike, nOnMention: String?
        let nOnComment, nOnFollow, nOnCommentLike, nOnCommentReply: String?
        let startupAvatar, startupInfo, startupFollow: Int?
        let src: Src?
        let searchEngines: String?
        let mode: Mode?
        let deviceID, balance, wallet: String?
        let referrer, profile, businessAccount: Int?
        let paypalEmail, bName, bEmail, bPhone: String?
        let bSite, bSiteAction, name, uname: String?
        let url, edit: String?
        let followers, following: Bool?
        let favourites, postsCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, email
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
    
    enum TypeEnum: String, Codable {
        case commentedOnPost = "commented_on_post"
        case followedUser = "followed_user"
        case likedPost = "liked__post"
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
}
