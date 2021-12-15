//
//  CreateStoreManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/30/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class CreateStoreManager{
    
    func createStore(title: String,tags: String,license: String,price: String,category:String,photo:Data?,completionBlock: @escaping (_ Success:CreateStoreModal.createStore_SuccessModal?,_ SessionError:CreateStoreModal.SessionAndServerError?,Error?)->()){
        let params = [API.PARAMS.server_key:API.SERVER_KEY.serverKey ?? "",API.PARAMS.access_token:AppInstance.instance.accessToken ?? "",API.PARAMS.title:title,"tags":tags,"license":license,"price":price,"category":category]
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = photo{
                multipartFormData.append(data, withName: "photo", fileName: "photo.jpg", mimeType: "image/png")
            }
            
        }, to: API.POST_CONSTANT_METHODS.CreateStoreApi, usingThreshold: UInt64.init(), method: .post, headers: nil).responseJSON { (result) in
            if result.value != nil {
                guard let res = result.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode  as? Int  ==  200{
                    guard let data = try? JSONSerialization.data(withJSONObject: result.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(CreateStoreModal.createStore_SuccessModal.self, from: data) else{return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: result.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(CreateStoreModal.SessionAndServerError.self, from: data) else{return}
                    completionBlock(nil,result,nil)
                }
            }
        }
    }
    
    static let sharedInstance = CreateStoreManager()
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
 guard let result = try? JSONDecoder().decode(CreateStoreModal.createStore_SuccessModal.self, from: data) else{return}
 completionBlock(result,nil,nil)
 }
 else{
 guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
 guard let result = try? JSONDecoder().decode(CreateStoreModal.SessionAndServerError.self, from: data) else{return}
 completionBlock(nil,result,nil)
 }
 }
 }
 case .failure(let error):
 print("Error in upload: \(error.localizedDescription)")
 completionBlock(nil,nil,error)
 }
 }
 }
 */
