//
//  WithDrawalManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import PixelPhotoSDK
import Alamofire

class WithDrawalManager{
    
    func withDraw(paypalEmail: String,amount: String,completionBlock: @escaping (_ Success:WithDrawalModal.withDrawal_SuccessModal?,_ SessionError:WithDrawalModal.SessionAndServerError?,Error?)->()){
        
        let params = [API.PARAMS.payPalEmail:paypalEmail,API.PARAMS.amount:amount,API.PARAMS.server_key:API.SERVER_KEY.serverKey ?? "",API.PARAMS.access_token:AppInstance.instance.accessToken ?? "",API.PARAMS.user_id:AppInstance.instance.userId] as [String : Any]
        AF.request(API.WithDrawal_METHODS.WithDrawal_API, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(WithDrawalModal.withDrawal_SuccessModal.self, from: data) else{return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(WithDrawalModal.SessionAndServerError.self, from: data) else{return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = WithDrawalManager()
    private init() {}
    
}
