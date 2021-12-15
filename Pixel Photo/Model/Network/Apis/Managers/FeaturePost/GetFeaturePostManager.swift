//
//  GetFeaturePostManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/25/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class GetFeaturePostManager{
    
    func getFeaturePost(offset:String,completionBlock: @escaping (_ Success:GetFeaturePostModal.getFeaturePost_SuccessModal?,_ SessionError:GetFeaturePostModal.SessionAndServerError?,Error?)->()){
        
        let params = [API.PARAMS.offset:offset,API.PARAMS.access_token:AppInstance.instance.accessToken ?? "", API.PARAMS.server_key: API.SERVER_KEY.serverKey] as [String : Any]
        AF.request(API.POST_CONSTANT_METHODS.FetchFeaturedPost, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    let result = GetFeaturePostModal.getFeaturePost_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GetFeaturePostModal.SessionAndServerError.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }
            else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let SharedInstance = GetFeaturePostManager()
    private init() {}
}
