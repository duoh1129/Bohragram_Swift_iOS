//
//  ChatManager.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 28/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class ChatManager{
    static let instance = ChatManager()
    func getChatList(accessToken:String,limit:Int,offset:Int, completionBlock: @escaping (_ Success:GetChatModel.GetChatSuccessModel?,_ SessionError:GetChatModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.limit: limit,
            API.PARAMS.offset: offset,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.GET_CHAT_LIST_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.GET_CHAT_LIST_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(GetChatModel.GetChatSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GetChatModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func getUserChats(accessToken:String,userId:Int,limit:Int, completionBlock: @escaping (_ Success:GetUserChatModel.GetUserChatSuccessModel?,_ SessionError:GetUserChatModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.limit: limit,
            API.PARAMS.user_id: userId,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.GET_USER_CHAT_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.GET_USER_CHAT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(GetUserChatModel.GetUserChatSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GetUserChatModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func sendMessage(accessToken:String,userId:Int,hashId:Int,text:String, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ SessionError:SendMessageModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.hash_id: hashId,
            API.PARAMS.user_id: userId,
            API.PARAMS.text: text,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.SEND_MESSAGE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.SEND_MESSAGE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(SendMessageModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    
    //
    func sendMessageWithImage(imageMimeType:String?,imageData:Data?,accessToken:String,userId:Int,hashId:Int,text:String, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ SessionError:SendMessageModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.hash_id: hashId,
            API.PARAMS.user_id: userId,
            API.PARAMS.text: text,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.SEND_MESSAGE_API)")
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName:"file", fileName: "image.jpg", mimeType: imageMimeType ?? "")
            }
            
            
            
        }, to: API.MESSAGE_CONSTANT_METHODS.SEND_MESSAGE_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            
                    if (response.value != nil){
                        guard let res = response.value as? [String:Any] else {return}
                        log.verbose("Response = \(res)")
                        guard let apiStatus = res["api_status"]  as? Any else {return}
                        if apiStatus is Int{
                            log.verbose("apiStatus Int = \(apiStatus)")
                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                            let result = try! JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data)
                            
                            completionBlock(result,nil,nil)
                        }
//                        else{
//                            let apiStatusString = apiStatus as? String
//                            if apiStatusString == "400" {
//                                log.verbose("apiStatus String = \(apiStatus)")
//                                let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                                let result = try! JSONDecoder().decode(SendMessageModel.SendMessageErrorModel.self, from: data)
//                                log.error("AuthError = \(result.errors!.errorText)")
//                                completionBlock(nil,result,nil)
//                            }
                        else if apiStatus as! String == "404" {
                                let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                                let result = try! JSONDecoder().decode(SendMessageModel.ServerKeyErrorModel.self, from: data)
//                                log.error("AuthError = \(result.errors!.errorText)")
//                                completionBlock(nil,nil,result)
                            }
                        
                    }else{
                        log.error("error = \(response.error?.localizedDescription)")
                        completionBlock(nil,nil,response.error)
                    }
                    
                
           
        }
    }
    
    func clearChat(accessToken:String,userId:Int, completionBlock: @escaping (_ Success:ClearChatModel.ClearChatSuccessModel?,_ SessionError:ClearChatModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.user_id: userId,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.CLEAR_CHAT_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.CLEAR_CHAT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ClearChatModel.ClearChatSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ClearChatModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteChat(accessToken:String,userId:Int, completionBlock: @escaping (_ Success:DeleteChatModel.DeleteChatSuccessModel?,_ SessionError:DeleteChatModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.user_id: userId,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.DELETE_CHAT_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.DELETE_CHAT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(DeleteChatModel.DeleteChatSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(DeleteChatModel.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func sendImage(receipent_id:String, imageMimeType:String?, image_data:Data?, completionBlock: @escaping (_ Success:SendImageMessage.SendImageSuccessModel?,_ SessionError:SendImageMessage.SessionAndServerError?,Error?)->()){
        
        let params = [
            API.PARAMS.access_token: AppInstance.instance.accessToken ?? "",
            API.PARAMS.user_id: receipent_id,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
        ] as [String : Any]
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = image_data{
                multipartFormData.append(data, withName:"send_file", fileName: "image.jpg", mimeType: imageMimeType ?? "")
            }
        }, to: API.MESSAGE_CONSTANT_METHODS.SEND_MEDIA_MESSAGE, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"] as? String else { return }
                if apiStatus == "200" {
                let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SendImageMessage.SendImageSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" || apiStatusString == "401"{
                        let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                        let result = try? JSONDecoder().decode(SendImageMessage.SessionAndServerError.self, from: data!)
                        completionBlock(nil,result,nil)
                    }
                }
            }else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
