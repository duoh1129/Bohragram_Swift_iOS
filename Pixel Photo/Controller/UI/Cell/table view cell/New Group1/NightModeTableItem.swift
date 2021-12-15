//
//  NightModeTableItem.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 2/6/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class NightModeTableItem: UITableViewCell {

    @IBOutlet weak var iconimage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(){
           let status = UserDefaults.standard.getDarkMode(Key: "darkMode")
           if status{
               self.switchLabel.setOn(true, animated: true)
           }else{
               self.switchLabel.setOn(false, animated: true)
           }
       }
    
    @IBAction func togglePressed(_ sender: Any) {
        if #available(iOS 13.0, *) {
            if self.switchLabel.isOn{
                window?.overrideUserInterfaceStyle = .dark
                UserDefaults.standard.setDarkMode(value: true, ForKey: "darkMode")

            }else{
                window?.overrideUserInterfaceStyle = .light
                UserDefaults.standard.setDarkMode(value: false, ForKey: "darkMode")
            }
        }
    }
}
