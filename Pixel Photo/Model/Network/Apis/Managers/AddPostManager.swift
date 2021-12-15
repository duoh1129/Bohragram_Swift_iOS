//
//  AddPostManager.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 15/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class AddPostManager{
    
    static let instance = AddPostManager()
    
    func addImages(accessToken: String,caption:String,imageDataArray:[Data]?, completionBlock: @escaping (_ Success:AddToPostModel.AddToPostSuccessModel?,_ AuthError:AddToPostModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.access_token : accessToken,
            API.PARAMS.caption : caption,
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
            for data in imageDataArray!{
                multipartFormData.append(data, withName: "images[]", fileName: "file.jpg", mimeType: "image/png")
            }
            
        }, to: API.POST_CONSTANT_METHODS.POST_IMAGES_API, usingThreshold: UInt64.init(), method: .post, headers: headers) .responseJSON { (result) in
            if (result.value != nil){
                print("Succesfully uploaded")
                log.verbose("response = \(result.value)")
                guard let res = result.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: result.value, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.AddToPostSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.message ?? nil)")
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: result.value, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors!.errorText)")
                    completionBlock(nil,result,nil)
                    
                }
                
            }else{
                log.error("error = \(result.error?.localizedDescription)")
                completionBlock(nil,nil,result.error)
            }
            
        }
    }
    func addVideo(accessToken: String,caption:String,videoData:Data?,thumbImageData:Data?, completionBlock: @escaping (_ Success:AddToPostModel.AddToPostSuccessModel?,_ AuthError:AddToPostModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            
            
            API.PARAMS.access_token : accessToken,
            API.PARAMS.caption : caption,
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
            if let data = videoData{
                multipartFormData.append(data, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
            }
            if let data = thumbImageData{
                multipartFormData.append(data, withName: "thumb", fileName: "file.jpg", mimeType: "image/png")
            }
            
        }, to: API.POST_CONSTANT_METHODS.POST_VIDEO_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.AddToPostSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.message ?? nil)")
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors!.errorText)")
                    completionBlock(nil,result,nil)
                    
                }
                
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,response.error)
            }
            
        }
    }
    func postGiF(accessToken:String,GIFUrl:String,caption:String, completionBlock: @escaping (_ Success:AddToPostModel.AddToPostSuccessModel?,_ SessionError:AddToPostModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.caption : caption,
            API.PARAMS.gif_url: GIFUrl,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
        ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.POST_CONSTANT_METHODS.POST_GIF_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.POST_CONSTANT_METHODS.POST_GIF_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.AddToPostSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func postEmbbedLinks(accessToken:String,VidoeLink:String,caption:String, completionBlock: @escaping (_ Success:AddToPostModel.AddToPostSuccessModel?,_ SessionError:AddToPostModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.video_url : VidoeLink,
            API.PARAMS.caption: caption,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
        ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.POST_CONSTANT_METHODS.POST_EMBBED_LINK_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.POST_CONSTANT_METHODS.POST_EMBBED_LINK_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.AddToPostSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(AddToPostModel.SessionAndServerError.self, from: data!)
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
 log.verbose("response = \(response.value)")
 if (response.value != nil){
 guard let res = response.value as? [String:Any] else {return}
 log.verbose("Response = \(res)")
 guard let apiStatus = res["code"]  as? String else {return}
 if apiStatus ==  API.ERROR_CODES.E_200{
 log.verbose("apiStatus Int = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
 let result = try? JSONDecoder().decode(AddToPostModel.AddToPostSuccessModel.self, from: data!)
 log.debug("Success = \(result?.message ?? nil)")
 completionBlock(result,nil,nil)
 }else{
 log.verbose("apiStatus String = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
 let result = try? JSONDecoder().decode(AddToPostModel.SessionAndServerError.self, from: data!)
 log.error("AuthError = \(result?.errors!.errorText)")
 completionBlock(nil,result,nil)
 
 }
 
 }else{
 log.error("error = \(response.error?.localizedDescription)")
 completionBlock(nil,nil,response.error)
 }
 
 }
 case .failure(let error):
 log.verbose("Error in upload: \(error.localizedDescription)")
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
 log.verbose("response = \(response.value)")
 if (response.value != nil){
 guard let res = response.value as? [String:Any] else {return}
 log.verbose("Response = \(res)")
 guard let apiStatus = res["code"]  as? String else {return}
 if apiStatus ==  API.ERROR_CODES.E_200{
 log.verbose("apiStatus Int = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
 let result = try? JSONDecoder().decode(AddToPostModel.AddToPostSuccessModel.self, from: data!)
 log.debug("Success = \(result?.message ?? nil)")
 completionBlock(result,nil,nil)
 }else{
 log.verbose("apiStatus String = \(apiStatus)")
 let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
 let result = try? JSONDecoder().decode(AddToPostModel.SessionAndServerError.self, from: data!)
 log.error("AuthError = \(result?.errors!.errorText)")
 completionBlock(nil,result,nil)
 
 }
 
 }else{
 log.error("error = \(response.error?.localizedDescription)")
 completionBlock(nil,nil,response.error)
 }
 
 }
 case .failure(let error):
 log.verbose("Error in upload: \(error.localizedDescription)")
 completionBlock(nil,nil,error)
 
 }
 }
 */
