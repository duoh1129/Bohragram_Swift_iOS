//
//  ReportUserManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/24/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK
class ReportUserManager{
    
    func reportUser(user_id:Int,completionBlock: @escaping (_ Success:ReportUserModal.reportUser_SuccessModal?,_ SessionError:ReportUserModal.SessionAndServerError?,Error?)->()){
        let params = [API.PARAMS.server_key:API.SERVER_KEY.serverKey,API.PARAMS.access_token:AppInstance.instance.accessToken ?? "","type":1,API.PARAMS.user_id:user_id] as [String : Any]
        AF.request(API.USERS_CONSTANT_METHODS.ReportUserApi, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ReportUserModal.reportUser_SuccessModal.self, from: data!)
                    completionBlock(result,nil,nil)
                }
                else{
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ReportUserModal.SessionAndServerError.self, from: data!)
                    completionBlock(nil,result,nil)
                }
            }
            else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    static let sharedInstance = ReportUserManager()
    private init() {}
    
}
