//
//  ManageSessions.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/3/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit
import PixelPhotoSDK

class ManageSessions: BaseVC {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var sessionArray = [[String:Any]]()
    var active_sessions = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ManageSessionCell", bundle: nil), forCellReuseIdentifier: "SessionCell")
        self.tableView.tableFooterView = UIView()
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        self.getSessions()
        self.title = NSLocalizedString("Manage Sessions", comment: "Manage Sessions")
        let yourBackImage = UIImage(named: "left-arrows")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    private func getSessions(){
        if Connectivity.isConnectedToNetwork(){
            FetchSessionManager.sharedInstance.fetchSession { (success, authError, error) in
                if success != nil {
                    self.dismissProgressDialog {
                        for (key, value) in success!.data{
                            if let values = value as? [String:Any] {
                                self.active_sessions.append(values)
                            }
                        }
                        self.tableView.reloadData()
                        print(self.active_sessions)
                    }
                }
                else if authError != nil{
                    self.dismissProgressDialog {
                        self.view.makeToast(authError?.errors?.errorText)
                    }
                }
                else if error != nil{
                    self.dismissProgressDialog {
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
        else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    func deleteSession(id: Int,index: Int){
        if Connectivity.isConnectedToNetwork(){
        DeleteSessionManager.sharedInstance.deleteSession(sessionId: id) { (success, authError, error) in
            if success != nil {
                self.active_sessions.remove(at: index)
                self.tableView.reloadData()
            }
            else if (authError != nil){
                self.view.makeToast(authError?.errors?.errorText)
            }
            else if (error != nil){
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
        else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }

}

extension ManageSessions : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.active_sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell") as! ManageSessionCell
        let index = self.active_sessions[indexPath.row]
        cell.vc = self
        cell.index = indexPath.row
        cell.bind(index: index)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    
    
    
}
