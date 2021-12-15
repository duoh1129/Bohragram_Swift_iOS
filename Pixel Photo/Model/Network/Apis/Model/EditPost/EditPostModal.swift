//
//  EditPostModal.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/18/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import Foundation

class EditPostModal:BaseModel{
    
    struct editPost_successModal:Codable{
       var code: String
       var status: String
       var message: String
    }
    
}
