//
//  ShowFundingVC.swift
//  Pixel Photo
//
//  Created by Muhammad Haris Butt on 1/28/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import Async
import PixelPhotoSDK
class ShowFundingVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var fundingArray = [FetchFundingModel.Datum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    private  func setupUI(){
        self.tableView.separatorStyle = .none
        self.tableView.register(R.nib.showFundingTableItem(), forCellReuseIdentifier: R.reuseIdentifier.showFundingTableItem.identifier)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchFunding()
        addButton.backgroundColor = UIColor.mainColor
    }
    
    
    @IBAction func addFundingPressed(_ sender: Any) {
        let vc  = R.storyboard.funding.addFundingVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    private func fetchFunding(){
           if Connectivity.isConnectedToNetwork(){
               let accessToken = AppInstance.instance.accessToken ?? ""
               Async.background({
                   FundingManager.instance.fetchFunding(accessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                       if success != nil{
                           Async.main({
                               self.dismissProgressDialog {
                                   log.debug("userList = \(success?.data ?? [])")
                                   self.fundingArray = success?.data ?? []
                                   self.tableView.reloadData()
                                   
                               }
                           })
                       }else if sessionError != nil{
                           Async.main({
                               self.dismissProgressDialog { self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                   log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                               }
                           })
                       }else {
                           Async.main({
                               self.dismissProgressDialog {
                                   
                                   log.error("error = \(error?.localizedDescription ?? "")")
                               }
                           })
                       }
                   }
               })
               
           }else{
               log.error("internetError = \(InterNetError)")
               self.view.makeToast(InterNetError)
           }
       }
}
extension ShowFundingVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fundingArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showFundingTableItem.identifier) as? ShowFundingTableItem
        let object = self.fundingArray[indexPath.row]
        cell?.bind(object)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let vc = R.storyboard.funding.showFundingDetailsVC()
           vc!.dataObject = self.fundingArray[indexPath.row]
           self.navigationController?.pushViewController(vc!, animated: true)
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
