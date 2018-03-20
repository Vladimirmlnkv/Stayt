
//
//  NewFeelingView.swift
//  Stayt
//
//  Created by Владимир Мельников on 20/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol NewFeelingViewDelegate {
    func didEnter(feeling: String)
}

class NewFeelingView: UIView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var characterLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!
    
    var delegate: NewFeelingViewDelegate!
    
    fileprivate let maxCharactersCount = 15
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("NewFeelingView")
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("NewFeelingView")
        setup()
    }
    
    fileprivate func setButton(isEnabled: Bool) {
        addButton.isEnabled = isEnabled
        addButton.setTitleColor(isEnabled ? Colors.mainActiveColor : UIColor.lightGray, for: .normal)
    }
    
    fileprivate func setup() {
        textField.keyboardAppearance = .dark
        backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        setButton(isEnabled: textField.text!.count > 0)
        characterLabel.text = "0/\(maxCharactersCount)"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
    }
    
    @objc func textFieldDidChange() {
        characterLabel.text = "\(textField.text!.count)/\(maxCharactersCount)"
        setButton(isEnabled: textField.text!.count > 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.centerYConstraint.constant -= keyboardSize.height / 2
                self.layoutIfNeeded()
            })
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        centerYConstraint.constant = 0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mainView.layer.cornerRadius = 8
        addButton.layer.cornerRadius = 8
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        delegate.didEnter(feeling: textField.text!)
        removeFromSuperview()
    }
}

extension NewFeelingView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count + string.count > maxCharactersCount {
            return false
        }
        
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            return false
        }
        
        return true
    }
}
