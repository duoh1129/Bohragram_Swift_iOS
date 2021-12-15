//
//  StoreCategoryController.swift
//  Pixel Photo
//
//  Created by Ubaid Javaid on 7/29/20.
//  Copyright © 2020 Olivin Esguerra. All rights reserved.
//

import UIKit

class StoreCategoryController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var delegate : storeCategoryDelegate!
    
    var categories = ["Abstract","Animals/Wildlife","Arts","Backgrounds/Textures","Beauty/Fashion","Business/Finance","Celebrities","Education","Food and drink","Healthcare/Medical","Holidays","Industrial","Interiors","Miscellaneous","Nature","Objects","Parks/Outdoor","People","Religion","Science","Signs/Symbols","Sports/Recreation","Technology","Transportation","Vintage"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension StoreCategoryController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat_name = self.categories[indexPath.row]
        switch indexPath.row {
        case 0:
            self.dismiss(animated: true, completion: {
                self.delegate.checkCategoryID(id: 491, name: cat_name)
            })
        case 1:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 492, name: cat_name)
            }
        case 2:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 493, name: cat_name)
            }
        case 3:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 494, name: cat_name)
            }
        case 4:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 495, name: cat_name)
            }
        case 5:
            self.dismiss(animated: true) {
            self.delegate.checkCategoryID(id: 496, name: cat_name)
            }
        case 6:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 497, name: cat_name)
            }
        case 7:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 498, name: cat_name)
            }
        case 8:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 499, name: cat_name)
            }
        case 9:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 500, name: cat_name)
            }
        case 10:
            self.dismiss(animated: true) {
               self.delegate.checkCategoryID(id: 501, name: cat_name)
            }
        case 11:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 502, name: cat_name)
            }
        case 12:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 503, name: cat_name)
            }
        case 13:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 504, name: cat_name)
            }
        case 14:
            self.dismiss(animated: true) {
               self.delegate.checkCategoryID(id: 505, name: cat_name)
            }
        case 15:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 506, name: cat_name)
            }
        case 16:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 507, name: cat_name)
            }
        case 17:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 508, name: cat_name)
            }
        case 18:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 509, name: cat_name)
            }
        case 19:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 510, name: cat_name)
            }
        case 20:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 511, name: cat_name)
            }
        case 21:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 512, name: cat_name)
            }
        case 22:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 513, name: cat_name)
            }
        case 23:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 514, name: cat_name)
            }
        case 24:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 515, name: cat_name)
            }
        case 25:
            self.dismiss(animated: true) {
                self.delegate.checkCategoryID(id: 516, name: cat_name)
            }

        default:
            print("Nothing")
        }
       
    }
    
    
}
