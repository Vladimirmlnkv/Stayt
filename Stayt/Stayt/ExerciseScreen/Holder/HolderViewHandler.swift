//
//  HolderViewHandler.swift
//  Stayt
//
//  Created by Владимир Мельников on 06/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol HolderViewHandlerDelegate: class {
    func holderDidFinish()
}

class HolderViewHandler {
    
    fileprivate let superView: UIView
    fileprivate var holderView: HolderView?
    fileprivate var timer: Timer?
    fileprivate weak var delegate: HolderViewHandlerDelegate?
    fileprivate let feeling: Feeling
    
    fileprivate var holdSeconds = 5 {
        didSet {
            holderView?.updateTime(holdSeconds)
        }
    }
    
    init(superView: UIView, delegate: HolderViewHandlerDelegate, feeling: Feeling) {
        self.superView = superView
        self.delegate = delegate
        self.feeling = feeling
    }
    
    func start() {
        holderView = HolderView(frame: superView.frame)
        holderView!.messageLabel.text = "Get comfortable and preapare for \(feeling.descriptionName!)"
        holderView!.updateTime(holdSeconds)
        holderView!.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        holderView!.spinner.startAnimating()
        superView.addSubview(holderView!)
        superView.bringSubview(toFront: holderView!)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    fileprivate func dismiss() {
        timer?.invalidate()
        holderView!.removeFromSuperview()
        delegate?.holderDidFinish()
    }
    
    @objc func updateTimer() {
        if holdSeconds == 0 {
            dismiss()
        } else {
            holdSeconds -= 1
        }
    }

    @objc func cancelButtonAction() {
        dismiss()
    }
}
