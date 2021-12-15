//
//  FundingManager.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/28/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class FundingManager{
    
    static let instance = FundingManager()
    
    func fetchFunding(accessToken:String,limit:Int,offset:Int, completionBlock: @escaping (_ Success:FetchFundingModel.FetchFundingSuccessModel?,_ SessionError:FetchFundingModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.limit: limit,
            API.PARAMS.offset: offset,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.FUNDING_METHODS.FETCH_FUNDING_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.FUNDING_METHODS.FETCH_FUNDING_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(FetchFundingModel.FetchFundingSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(FetchFundingModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func createFunding(AccesToken: String,title:String,amount:Int,Description:String,fundingImageData:Data?, completionBlock: @escaping (_ Success:AddFundingModel.AddFundingSuccessModel?,_ sessionError:AddFundingModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.access_token : AccesToken,
            API.PARAMS.title : title,
            API.PARAMS.description : Description,
            API.PARAMS.amount : amount,
            API.PARAMS.server_key : API.SERVER_KEY.serverKey
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = fundingImageData{
                multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/png")
                
            }
            
        }, to: API.FUNDING_METHODS.CREATE_FUNDING_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AddFundingModel.AddFundingSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(AddFundingModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editFunding(AccesToken: String,id:Int,title:String,amount:Int,Description:String,fundingImageData:Data?, completionBlock: @escaping (_ Success:EditFundingModel.EditFundingSuccessModel?,_ sessionError:EditFundingModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.access_token : AccesToken,
            API.PARAMS.id : id,
            API.PARAMS.title : title,
            API.PARAMS.description : Description,
            API.PARAMS.amount : amount,
            API.PARAMS.server_key : API.SERVER_KEY.serverKey
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = fundingImageData{
                multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/png")
                
            }
        }, to: API.FUNDING_METHODS.EDIT_FUNDING_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(EditFundingModel.EditFundingSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditFundingModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }


}
/*
 { (result) in
 switch result{
 case .success(let upload, _, _):
 upload.responseJSON { response in
 print("Succesfully uploaded")
 log.verbose("response = \(response.value ?? nil )")
 if (response.value != nil){
 guard let res = response.value as? [String:Any] else {return}
 guard let apiStatus = res["code"]  as? String else {return}
 if apiStatus ==  API.ERROR_CODES.E_200{
 log.verbose("apiStatus Int = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
 let result = try? JSONDecoder().decode(AddFundingModel.AddFundingSuccessModel.self, from: data!)
 completionBlock(result,nil,nil)
 }else{
 log.verbose("apiStatus String = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
 let result = try? JSONDecoder().decode(AddFundingModel.SessionAndServerError.self, from: data!)
 log.error("AuthError = \(result?.errors?.errorText ?? "")")
 completionBlock(nil,result,nil)
 }
 }else{
 log.error("error = \(response.error?.localizedDescription ?? "")")
 completionBlock(nil,nil,response.error)
 }
 }
 case .failure(let error):
 log.verbose("Error in upload: \(error.localizedDescription ?? "")")
 completionBlock(nil,nil,error)
 
 }
 }
 */
/*
 { (result) in
 switch result{
 case .success(let upload, _, _):
 upload.responseJSON { response in
 print("Succesfully uploaded")
 log.verbose("response = \(response.value ?? nil )")
 if (response.value != nil){
 guard let res = response.value as? [String:Any] else {return}
 guard let apiStatus = res["code"]  as? String else {return}
 if apiStatus ==  API.ERROR_CODES.E_200{
 log.verbose("apiStatus Int = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
 let result = try? JSONDecoder().decode(EditFundingModel.EditFundingSuccessModel.self, from: data!)
 completionBlock(result,nil,nil)
 }else{
 log.verbose("apiStatus String = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
 let result = try? JSONDecoder().decode(EditFundingModel.SessionAndServerError.self, from: data!)
 log.error("AuthError = \(result?.errors?.errorText ?? "")")
 completionBlock(nil,result,nil)
 }
 }else{
 log.error("error = \(response.error?.localizedDescription ?? "")")
 completionBlock(nil,nil,response.error)
 }
 }
 case .failure(let error):
 log.verbose("Error in upload: \(error.localizedDescription ?? "")")
 completionBlock(nil,nil,error)
 
 }
 }
 */
