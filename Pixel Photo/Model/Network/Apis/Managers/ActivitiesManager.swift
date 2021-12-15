//
//  ActivitiesManager.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 2/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class ActivitiesManager{
    
    static let instance = ActivitiesManager()

    func fetchUserActivities(accessToken:String,limit:Int,Offset:Int, completionBlock: @escaping (_ Success:ActivitiesModel.ActivitiesSuccessModel?,_ SessionError:ActivitiesModel.SessionAndServerError?, Error?) ->()){
        
        let params = [
            API.PARAMS.limit: limit,
            API.PARAMS.access_token: accessToken,
            API.PARAMS.server_key: API.SERVER_KEY.serverKey
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.ACTIVITIES_METHODS.FETCH_ACTIVITIES_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.ACTIVITIES_METHODS.FETCH_ACTIVITIES_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? String else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ActivitiesModel.ActivitiesSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ActivitiesModel.SessionAndServerError.self, from: data!)
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
