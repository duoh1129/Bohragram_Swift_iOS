//
//  ReportUserModal.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/24/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class ReportUserModal:BaseModel{
    
    struct reportUser_SuccessModal:Codable{
        let code, status: String
        let data: DataClass
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let message: String
        let type: Int
    }
}
