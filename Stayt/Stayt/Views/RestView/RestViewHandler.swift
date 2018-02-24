//
//  RestViewHandler.swift
//  Stayt
//
//  Created by Владимир Мельников on 24/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import AVKit

protocol RestViewHandlerDelegate: class {
    func didResume()
    func didStop()
}

class RestViewHandler {
    
    fileprivate let superView: UIView
    fileprivate weak var delegate: RestViewHandlerDelegate?
    fileprivate let restTime: Int
    fileprivate var restView: RestView!
    fileprivate var player: AVPlayer!
    fileprivate var timeObserver: Any?
    
    init(superView: UIView, delegate: RestViewHandlerDelegate, restTime: Int) {
        self.superView = superView
        self.delegate = delegate
        self.restTime = restTime
    }
    
    func dismiss() {
        restView.removeFromSuperview()
        delegate?.didResume()
    }
    
    @objc func stop() {
        delegate?.didStop()
    }
    
    @objc func resume() {
        delegate?.didResume()
    }
    
    func start() {
        restView = RestView(frame: superView.frame)
        restView.titleLabel.text = "Rest time"
        restView.updateTime(restTime)
        restView.resumeButton.addTarget(self, action: #selector(resume), for: .touchUpInside)
        restView.stopButton.addTarget(self, action: #selector(stop), for: .touchUpInside)
        superView.addSubview(restView)
        superView.bringSubview(toFront: restView)
        
        let soundPath = Bundle.main.path(forResource: "empty", ofType: "mp3")
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        player = AVPlayer(url: URL(fileURLWithPath: soundPath!))
        timeObserver = player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time -> Void in
            guard let strongSelf = self else { return }
            let passedTime = Int64(time.value) / Int64(time.timescale)
            let remainingTime = strongSelf.restTime - Int(passedTime)
            if remainingTime == 0 {
                strongSelf.dismiss()
                if let observer = strongSelf.timeObserver {
                    strongSelf.player?.removeTimeObserver(observer)
                }
            } else {
                strongSelf.restView.updateTime(remainingTime)
            }
        })
        player!.play()
    }
}
