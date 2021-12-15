//
//  PPWebViewController.swift
//  Pixel Photo
//
//  Created by DoughouzLight on 26/12/2018.
//  Copyright © 2018 DoughouzLight. All rights reserved.
//

import UIKit
import WebKit

class PPWebViewController: UIViewController {
    
//    fileprivate var progress = ProgressDialog()
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        progress.show()
        
        self.navigationController?.isNavigationBarHidden = false
//        self.webView.load(URLRequest(url: URL(string: self.viewModel!.url!)!))
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
            if Float(webView.estimatedProgress) > 0.0 {
//                progress.dismiss()
            }
        }
    }
    
    


    
}
