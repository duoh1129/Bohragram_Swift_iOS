
//
//  ShowFundingDetailsVC.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import DropDown
import PixelPhotoSDK

class ShowFundingDetailsVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moreBtn: UIBarButtonItem!
    var dataObject:FetchFundingModel.Datum?
    private let moreDropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.customizeDropdown()
    }
    
    @IBAction func morePressed(_ sender: Any) {
        self.moreDropdown.show()
        
    }
    private  func setupUI(){
        self.tableView.separatorStyle = .none
        self.tableView.register(R.nib.showDetailsSectionOneTableItem(), forCellReuseIdentifier: R.reuseIdentifier.showDetailsSectionOneTableItem.identifier)
        self.tableView.register(R.nib.sectionTwoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.sectionTwoTableItem.identifier)
        self.tableView.register(R.nib.sectionThreeShowFundingDetailsTableItem(), forCellReuseIdentifier: R.reuseIdentifier.sectionThreeShowFundingDetailsTableItem.identifier)
        
    }
    private func customizeDropdown(){
        if self.dataObject?.userID == AppInstance.instance.userId ?? 0 {
            moreDropdown.dataSource = ["Edit","Copy Link"]
        }else {
            moreDropdown.dataSource = ["Copy Link"]
        }
        
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.dataObject?.userID == AppInstance.instance.userId ?? 0 {
                if index == 0{
                    let vc  = R.storyboard.funding.addFundingVC()
                    vc?.dataObject = self.dataObject
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    UIPasteboard.general.string = "\(API.baseURL)/\(self.dataObject?.hashedID ?? "")"
                    let content = UIPasteboard.general.string
                    self.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
                }
            }else{
                UIPasteboard.general.string = "\(API.baseURL)/\(self.dataObject?.hashedID ?? "")"
                let content = UIPasteboard.general.string
                self.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
            }
            print("Index = \(index)")
        }
    }
}
extension ShowFundingDetailsVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showDetailsSectionOneTableItem.identifier) as? ShowDetailsSectionOneTableItem
            cell?.bind(self.dataObject!)
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sectionTwoTableItem.identifier) as? SectionTwoTableItem
            cell?.bind(self.dataObject!)
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sectionThreeShowFundingDetailsTableItem.identifier) as? SectionThreeShowFundingDetailsTableItem
            cell?.bind(self.dataObject!)
            return cell!
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showDetailsSectionOneTableItem.identifier) as? ShowDetailsSectionOneTableItem
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
