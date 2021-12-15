//
//  UserVerificationManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/6/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import PixelPhotoSDK
import Alamofire

class UserVerificationManager{
    
    func userVerify(name: String,message:String,photo:Data?,passport:Data?,completionBlock: @escaping (_ Success:UserVerifiactionModal.UserVerification_SuccessModal?,_ SessionError:UserVerifiactionModal.SessionAndServerError?,Error?)->()){
        let params = [API.PARAMS.server_key:API.SERVER_KEY.serverKey ?? "", API.PARAMS.access_token:AppInstance.instance.accessToken ?? "",API.PARAMS.name:name,API.PARAMS.message:message]
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = photo{
                multipartFormData.append(data, withName: "photo", fileName: "photo.jpg", mimeType: "image/png")
            }
            if let data1 = passport{
                multipartFormData.append(data1, withName: "passport", fileName: "passport.jpg", mimeType: "image/png")
            }
        }, to: API.UserVerification_Method.UserVerification, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode  as? Int  ==  200{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(UserVerifiactionModal.UserVerification_SuccessModal.self, from: data) else{return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(UserVerifiactionModal.SessionAndServerError.self, from: data) else{return}
                    completionBlock(nil,result,nil)
                }
            }
        }
    }
    
    static let sharedInstance = UserVerificationManager()
    private init() {}
}
/*
 
 { (result) in
 switch result{
 case .success(let upload, _, _):
 upload.responseJSON { (response) in
 print(response.value)
 if response.value != nil {
 guard let res = response.value as? [String:Any] else {return}
 guard let apiStatusCode = res["code"] as? Any else {return}
 if apiStatusCode  as? Int  ==  200{
 guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
 guard let result = try? JSONDecoder().decode(UserVerifiactionModal.UserVerification_SuccessModal.self, from: data) else{return}
 completionBlock(result,nil,nil)
 }
 else{
 guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
 guard let result = try? JSONDecoder().decode(UserVerifiactionModal.SessionAndServerError.self, from: data) else{return}
 completionBlock(nil,result,nil)
 }
 }
 }
 case .failure(let error):
 print("Error in upload: \(error.localizedDescription)")
 completionBlock(nil,nil,error)
 }
 }
 */
