//
//  DeleteSessionManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/4/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import PixelPhotoSDK
import Alamofire

class DeleteSessionManager{
    
    func deleteSession(sessionId: Int,completionBlock: @escaping (_ Success:DeleteSessionModal.deleteSession_SuccessModal?,_ SessionError:DeleteSessionModal.SessionAndServerError?,Error?)->()){
        let params = [API.PARAMS.server_key:API.SERVER_KEY.serverKey ?? "",API.PARAMS.access_token:AppInstance.instance.accessToken ?? "",API.PARAMS.sessionId:sessionId] as [String : Any]
        
        AF.request(API.ManageSession_METHOD.DELETE_SESSION_API, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else{return}
                    guard let result = try? JSONDecoder().decode(DeleteSessionModal.deleteSession_SuccessModal.self, from: data) else{return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else{return}
                    guard let result = try? JSONDecoder().decode(DeleteSessionModal.SessionAndServerError.self, from: data) else{return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)

            }
        }
    }
    
    static let sharedInstance = DeleteSessionManager()
    private init() {}
}
