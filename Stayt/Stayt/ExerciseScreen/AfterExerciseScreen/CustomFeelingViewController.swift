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
}

class CustomFeelingViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var charactersLabel: UILabel!
    
    fileprivate let maxNumberOfCharacters = 250
    fileprivate var doneBarButtonItem: UIBarButtonItem!
    var delegate: CustomFeelingViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        doneBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        let tapGestureReconginzer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureReconginzer)
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    @objc func handleTapGesture() {
        textView.resignFirstResponder()
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        delegate.didEnter(feeling: textView.text)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let c = keyboardSize.height
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomConstraint.constant = c + self.charactersLabel.frame.height + 16
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
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
