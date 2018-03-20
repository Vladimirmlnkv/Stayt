//
//  CustomFeelingViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 10/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol CustomFeelingViewControllerDelegate {
    func didEnter(feeling: String)
    func didPickFeeling(_ feeling: Feeling, note: String?)
}

class CustomFeelingViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var feelingLabel: UILabel!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var charactersLabel: UILabel!
    @IBOutlet var placeholderLabel: UILabel!
    
    fileprivate let maxNumberOfCharacters = 2500
    fileprivate var doneBarButtonItem: UIBarButtonItem!
    var delegate: CustomFeelingViewControllerDelegate!
    var experience: Experience!
    
    var tmpNote: String?
    var tmpFeeling: Feeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = Colors.mainActiveColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        textView.textColor = UIColor.white
        textView.keyboardAppearance = .dark
        
        navigationItem.title = experience.dateString
        titleLabel.text = experience.exerciseName
        if experience.roundsCount > 1 {
            titleLabel.text = titleLabel.text! + " (\(experience.roundsCount) rounds)"
        }
        
        if experience.afterFeeling == nil {
            feelingLabel.text = ""
        } else {
            feelingLabel.text = "You felt: \(experience.afterFeeling!.feeling.title!)"
            if let text = experience.afterFeeling?.text {
                textView.text = text
            }
        }
        
        if let note = tmpNote {
            textView.text = note
        }
        
        if let feeling = tmpFeeling {
            feelingLabel.text = "You felt: \(feeling.title!)"
        }
        
        if textView.text.isEmpty {
            textView.becomeFirstResponder()
        }
        
        charactersLabel.text = "\(textView.text.count)/\(maxNumberOfCharacters)"
        placeholderLabel.isHidden = textView.text.count > 0

        doneBarButtonItem = UIBarButtonItem(title: "Complete", style: .done, target: self, action: #selector(doneAction))
        doneBarButtonItem.isEnabled = textView.text.count > 0
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        let tapGestureReconginzer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureReconginzer)
        textView.delegate = self
    }
    
    @objc func handleTapGesture() {
        textView.resignFirstResponder()
    }
    
    @objc func doneAction() {
        var feeling: Feeling
        if let tmpFeeling = tmpFeeling {
            feeling = tmpFeeling
        } else if let f = experience.afterFeeling?.feeling {
            feeling = f
        } else {
            feeling = Feeling(title: "")
        }
        delegate.didPickFeeling(feeling, note: textView.text)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let c = keyboardSize.height
                let tabBarSize = tabBarController?.tabBar.frame.height ?? 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomConstraint.constant = c + self.charactersLabel.frame.height + 16 - tabBarSize
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        })
    }

}

extension CustomFeelingViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.count <= maxNumberOfCharacters
    }
    
    func textViewDidChange(_ textView: UITextView) {
        charactersLabel.text = "\(textView.text.count)/\(maxNumberOfCharacters)"
        doneBarButtonItem.isEnabled = textView.text.count > 0
        placeholderLabel.isHidden = textView.text.count > 0
        delegate.didEnter(feeling: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
