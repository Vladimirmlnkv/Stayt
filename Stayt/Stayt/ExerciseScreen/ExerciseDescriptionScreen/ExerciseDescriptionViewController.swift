//
//  ExerciseDescriptionViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 12/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class ExerciseDescriptionViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    var exerciseTitle: String!
    var exerciseDescription: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = exerciseTitle
        textView.text = exerciseDescription
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
