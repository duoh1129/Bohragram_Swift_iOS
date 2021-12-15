//
//  BusinessAccountManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/27/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK

class BusinessAccountManager{
    
    func createBusinessAccount(b_Name:String,b_email:String,b_phone:String,b_site:String,completionBlock: @escaping (_ Success:BusinessAccountModal.BusinessAccount_SuccessModal?,_ SessionError:BusinessAccountModal.SessionAndServerError?,Error?)->()){
        
        let params = [API.PARAMS.server_key:API.SERVER_KEY.serverKey,API.PARAMS.access_token:AppInstance.instance.accessToken ?? "",API.PARAMS.business_Name:b_Name,API.PARAMS.business_Email:b_email,API.PARAMS.business_Phone:b_phone,API.PARAMS.bussiness_Web:b_site]
        AF.request(API.AUTH_CONSTANT_METHODS.BusinessAccount_API, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(BusinessAccountModal.BusinessAccount_SuccessModal.self, from: data!)
                    completionBlock(result,nil,nil)
                }
                else{
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(BusinessAccountModal.SessionAndServerError.self, from: data!)
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
    static let sharedInstance = BusinessAccountManager()
    private init() {}
}
