//
//  IntroVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 18/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit
import PixelPhotoSDK

class  IntroVC: UIViewController {
    
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var signUpLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginView: GradientView!
    @IBOutlet weak var registerView: GradientView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    let titleArr = [NSLocalizedString("Title1", comment: ""),
                    NSLocalizedString("Title2", comment: ""),
                    NSLocalizedString("Title3", comment: "")]
    
    let descArr = [NSLocalizedString("Desc1", comment: ""),
                   NSLocalizedString("Desc2", comment: ""),
                   NSLocalizedString("Desc3", comment: "")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private func setupUI(){
        
        self.welcomeLbl.text = NSLocalizedString("WelcomeText", comment: "")
        self.loginLbl.text = NSLocalizedString("Login", comment: "")
        self.signUpLbl.text = NSLocalizedString("Sign Up", comment: "")
        
        let l1 = CAGradientLayer()
        l1.colors = [UIColor.hexStringToUIColor(hex: "#73348D").cgColor, UIColor.hexStringToUIColor(hex: "#D83880").cgColor]
              l1.startPoint = CGPoint(x: 0, y: 0.5)
            l1.endPoint = CGPoint(x: 1, y: 0.5)
        l1.frame = self.loginView.bounds
        self.loginView.layer.insertSublayer(l1, at: 0)
      
        let l2 = CAGradientLayer()
        l2.colors = [UIColor.hexStringToUIColor(hex: "#73348D").cgColor, UIColor.hexStringToUIColor(hex: "#D83880").cgColor]
        l2.startPoint = CGPoint(x: 0, y: 0.5)
        l2.endPoint = CGPoint(x: 1, y: 0.5)
        l2.frame = self.loginView.bounds
        self.registerView.layer.insertSublayer(l2, at: 0)
        self.contentCollectionView.delegate = self
        self.contentCollectionView.dataSource = self
        
        self.loginView.isRoundedRect(cornerRadius: 20)
        self.registerView.isRoundedRect(cornerRadius: 20)
        self.contentCollectionView.register(R.nib.introItem(), forCellWithReuseIdentifier: R.reuseIdentifier.introItem.identifier)
        
        
        let signUptap = UITapGestureRecognizer(target: self, action: #selector(self.signUpTapped(_:)))
        self.registerView.isUserInteractionEnabled = true
        self.registerView.addGestureRecognizer(signUptap)
        
        let Logintap = UITapGestureRecognizer(target: self, action: #selector(self.loginTapped(_:)))
        self.loginView.isUserInteractionEnabled = true
        self.loginView.addGestureRecognizer(Logintap)
    }
    @objc func loginTapped(_ sender: UITapGestureRecognizer) {
        let vc = R.storyboard.main.signUpVC()
        log.verbose("Tapped")
        self.navigationController?.pushViewController(vc!, animated: true)
//       self.setupLoginFlow()
    }
    @objc func signUpTapped(_ sender: UITapGestureRecognizer) {
        let vc = R.storyboard.main.loginVC()
        log.verbose("Tapped")
        self.navigationController?.pushViewController(vc!, animated: true)
    }

//
}

extension IntroVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.introItem.identifier, for: indexPath) as! IntroItem
        cell.titleLbl.text = self.titleArr[indexPath.row]
        cell.descLbl.text = self.descArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
