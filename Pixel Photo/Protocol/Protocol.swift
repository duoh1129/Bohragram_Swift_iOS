//
//  Protocol.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 15/11/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import Foundation
import PixelPhotoSDK
protocol didSelectType {
    func didselecttype(type:String)
}
protocol didSelectEmbbedVideoDelegate {
    func didSelectEmbbedVideo(videoURL:String)
}
protocol didSelectGIFDelegate {
    func didSelectGIF(GIFUrl:String)
}
protocol uploadImageDelegate {
   func uploadImage(imageType : String, image : UIImage)
}
protocol storeCategoryDelegate {
    func checkCategoryID(id: Int,name: String)
}
protocol storeLicenseDelegate{
    func checkLicenseName(name: String)
}
protocol storeFilterDelegate{
    func filter(title: String,tag: String,category:Int,license: String,price_Min: String,price_Max: String)
}

protocol DeletePostDelegate{
    func postDelete(index:Int)
}
protocol EditPostDelegate{
    func editPost(text:String)
}
