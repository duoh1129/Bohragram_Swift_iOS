//
//  ManageSessionCell.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class ManageSessionCell: UITableViewCell {
    
    @IBOutlet weak var platform: UILabel!
    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var ipAddress: UILabel!
    @IBOutlet weak var pcFirstName: UILabel!
    var session_id: Int? = nil
    var index: Int? = nil
    var vc : ManageSessions!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(index: [String:Any]){
        if let id = index["id"] as? Int{
            self.session_id = id
        }
     if let platform = index["platform"] as? String{
            self.platform.text = platform
        let plat_First = platform.prefix(1)
        self.pcFirstName.text = "\(plat_First)"
        }
        if let platform_details = index["platform_details"] as? [String:Any]{
            if let name = platform_details["name"] as? String{
                self.browserLabel.text = "\("Browser : ")\(name)"
            
            }
            if let ipAddress = platform_details["ip_address"] as? String{
                self.ipAddress.text = "\("IP Address : ")\(ipAddress)"
            }
        }
        
        if let lastSeen = index["time"] as? Int{
            self.lastSeenLabel.text = "\("last seen : ")\(lastSeen)"
        }
    }
    
    @IBAction func Close(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to log out from this device",preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.vc.deleteSession(id: self.session_id ?? 0,index: self.index ?? 0 )
                                        
        }))
        self.vc.present(alert, animated: true, completion: nil)
    }
}
