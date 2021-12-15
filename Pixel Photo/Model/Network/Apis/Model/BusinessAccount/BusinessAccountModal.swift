//
//  BusinessAccountModal.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/27/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class BusinessAccountModal: BaseModel{
    
    struct BusinessAccount_SuccessModal:Codable{
        var code: String
        var status: String
    }
}
