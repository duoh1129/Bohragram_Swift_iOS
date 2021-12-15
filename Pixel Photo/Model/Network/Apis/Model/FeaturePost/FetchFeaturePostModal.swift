//
//  FetchFeaturePostModal.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/25/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class FetchFeaturePostModal:BaseModel{
    
    struct fetchFeaturePost_SuccessModal{
        let code: String
        let status: String
        let data: [[String:Any]]
    }
    
}

extension FetchFeaturePostModal.fetchFeaturePost_SuccessModal{
    init(json:[String:Any]) {
        let code = json["code"] as? String
        let status = json["status"] as? String
        let data = json["data"] as? [[String:Any]]
        self.code = code ?? ""
        self.status = status ?? ""
        self.data = data ??  [["PostType" : "Profile_Pic"]]
        
    }
}
