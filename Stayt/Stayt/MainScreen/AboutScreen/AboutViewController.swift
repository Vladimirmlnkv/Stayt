//
//  AboutViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var emailButton: UIButton!
    fileprivate let mailToString = "mailto:techsupport@staytapp.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailButton.layer.cornerRadius = 8
    }
    
    @IBAction func crossButtonActio(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailButtonAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: mailToString)!)
    }
    
    
}
