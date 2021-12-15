//
//  TabbarController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 8/25/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Device

class TabbarController: UITabBarController {

        let button = UIButton.init(type: .custom)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
//            button.setTitle("Cam", for: .normal)
//            button.setTitleColor(.black, for: .normal)
//            button.setTitleColor(.yellow, for: .highlighted)
            
            button.backgroundColor = .orange
            button.setImage(#imageLiteral(resourceName: "ic_tab_add"), for: .normal)
            button.setBackgroundImage(#imageLiteral(resourceName: "backGr1"), for: .normal)
            button.layer.borderWidth = 0
            button.layer.cornerRadius = 22.5
            button.clipsToBounds = true
            self.view.insertSubview(button, aboveSubview: self.tabBar)
            button.addTarget(self, action: #selector(self.TapButton(sender:)), for: .touchUpInside)
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            switch Device.version() {
            case.iPhone5:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone5S:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case.iPhone5C:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone6:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone6S:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone6Plus:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone6SPlus:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone7:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone7Plus:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone8:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone8Plus:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhoneX:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhoneXR:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhoneXS:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case .iPhone11:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            case.iPhone11Pro:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 75, width: 45, height: 45)
            case .iPhone11Pro_Max:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 75, width: 45, height: 45)
            case.simulator:
                button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 75, width: 45, height: 45)
            default:
                 button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47, width: 45, height: 45)
            }
            // safe place to set the frame of button manually           
        }
    
    @IBAction func TapButton(sender:UIButton){
        print("touch]")
        self.selectedIndex = 2
    }
    

 

}
