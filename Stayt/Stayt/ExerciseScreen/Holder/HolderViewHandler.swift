//
//  HolderViewHandler.swift
//  Stayt
//
//  Created by Владимир Мельников on 06/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import AVKit

protocol HolderViewHandlerDelegate: class {
    func holderDidFinish()
}

class HolderViewHandler {
    
    fileprivate let superView: UIView
    fileprivate var holderView: HolderView?
    fileprivate var player: AVPlayer?
    fileprivate weak var delegate: HolderViewHandlerDelegate?
    fileprivate let feeling: Feeling
    
    fileprivate var holdSeconds = 5
    fileprivate var timeObserver: Any?
    
    init(superView: UIView, delegate: HolderViewHandlerDelegate, feeling: Feeling) {
        self.superView = superView
        self.delegate = delegate
        self.feeling = feeling
    }
    
    func start() {
        holderView = HolderView(frame: superView.frame)
        holderView!.messageLabel.text = "Get comfortable and prepapare for \(feeling.descriptionName!)"
        holderView!.updateTime(holdSeconds)
        holderView!.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        holderView!.spinner.startAnimating()
        superView.addSubview(holderView!)
        superView.bringSubview(toFront: holderView!)
        
        let soundPath = Bundle.main.path(forResource: "empty", ofType: "mp3")
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        player = AVPlayer(url: URL(fileURLWithPath: soundPath!))
        timeObserver = player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time -> Void in
            guard let strongSelf = self else { return }
            let passedTime = Int64(time.value) / Int64(time.timescale)
            let remainingTime = strongSelf.holdSeconds - Int(passedTime)
            if remainingTime == 0 {
                strongSelf.dismiss()
                if let observer = strongSelf.timeObserver {
                    strongSelf.player?.removeTimeObserver(observer)
                }
            } else {
                strongSelf.holderView?.updateTime(remainingTime)
            }
        })
        player!.play()
    }
    
    fileprivate func dismiss() {
        player?.pause()
        holderView!.removeFromSuperview()
        delegate?.holderDidFinish()
    }

    @objc func cancelButtonAction() {
        dismiss()
    }
}
