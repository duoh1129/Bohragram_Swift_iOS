//
//  GetExploreAllStoreManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/24/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import PixelPhotoSDK
import Alamofire

class GetExploreAllStoreManager{
   
    func getAllStroe(searchTitle:String,searchTags:String,searchCat:String,searchLicense:String,searchMin:String,searchMax:String,offset:Int,completionBlock: @escaping (_ Success:GetExploreAllStoreModal.getExploreAllStore_SuccessModal?,_ SessionError:GetExploreAllStoreModal.SessionAndServerError?,Error?)->()){
        
    let params = [API.PARAMS.searchTitle:searchTitle,API.PARAMS.searchTags:searchTags,API.PARAMS.searchCat:searchCat,API.PARAMS.searchLicense:searchLicense,API.PARAMS.searchMin:searchMin,API.PARAMS.searchMax:searchMax,API.PARAMS.offset:offset,API.PARAMS.access_token:AppInstance.instance.accessToken ?? "", API.PARAMS.server_key: API.SERVER_KEY.serverKey] as [String : Any]
        
        AF.request(API.POST_CONSTANT_METHODS.FETCH_AllStore, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    let result = GetExploreAllStoreModal.getExploreAllStore_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LoginModel.SessionAndServerError.self, from: data!)
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
    static var sharedInstance = GetExploreAllStoreManager()
    private init() {}
}


    
    

