//
//  FetchSessionModal.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class FetchSessionModal:BaseModel{
   
    struct fetchSession_SuccessModal{
        
        let code: String
        let status: String
        let data: [String:AnyObject]
        
    }
    
}
extension FetchSessionModal.fetchSession_SuccessModal{
    init(json:[String:Any]) {
        let code = json["code"] as? String
        let status = json["status"] as? String
        let data = json["data"] as? [String:AnyObject]
        self.code = code ?? ""
        self.status = status ?? ""
        self.data = data ?? ["foo": "1" as AnyObject,
        "bar": 2 as AnyObject,
        "baz": "3" as AnyObject]
    }
}
