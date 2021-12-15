//
//  EditPostManager.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/18/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation
import Alamofire
import PixelPhotoSDK
class EditPostManager{
    func editPost(text:String,post_id:Int,completionBlock: @escaping (_ Success:EditPostModal.editPost_successModal?,_ SessionError:EditPostModal.SessionAndServerError?,Error?)->()){
        let params = [API.PARAMS.server_key:API.SERVER_KEY.serverKey,API.PARAMS.access_token:AppInstance.instance.accessToken ?? "",API.PARAMS.text:text,API.PARAMS.post_id:post_id] as [String : Any]
        AF.request(API.POST_CONSTANT_METHODS.EditPostApi, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["code"] as? Any else {return}
                if apiStatusCode as? String == API.ERROR_CODES.E_200 {
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditPostModal.editPost_successModal.self, from: data!)
                    completionBlock(result,nil,nil)
                }
                else{
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditPostModal.SessionAndServerError.self, from: data!)
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
    
    static let sharedInsatnce = EditPostManager()
    private init() {}
    
}
