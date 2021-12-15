//
//  GetExploreAllStore.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 6/24/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class GetExploreAllStoreModal:BaseModel{
   
    struct getExploreAllStore_SuccessModal{
        let code: String
        let status: String
        let data: [[String:Any]]
    }
}
extension GetExploreAllStoreModal.getExploreAllStore_SuccessModal{
    init(json : [String:Any]){
        let code = json["code"] as? String
        let status = json["status"] as? String
        let data = json["data"] as? [[String:Any]]
        self.code = code ?? ""
        self.status = status ?? ""
        self.data = data ??  [["PostType" : "Profile_Pic"]]
    }
}
