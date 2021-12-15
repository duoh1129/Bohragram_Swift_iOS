//
//  DeleteSessionModal.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/4/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class DeleteSessionModal:BaseModel{
    
    struct deleteSession_SuccessModal:Codable{
        var code: String
        var status: String
    }
}
