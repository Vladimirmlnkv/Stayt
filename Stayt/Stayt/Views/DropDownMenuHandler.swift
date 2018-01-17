//
//  DropDownMenuHandler.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class DropDownMenuHandler: NSObject, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    fileprivate let durations: [Int] = [2, 5, 10]
    
    weak var delegate: MenuDelegate!
    
    fileprivate var menuView: UITableView!
    fileprivate var mainMenuView: UIView!
    fileprivate var menuAlpha: CGFloat = 0.4
    
    fileprivate let superView: UIView
    fileprivate let triggerButton: UIButton
    fileprivate let cellHeight: CGFloat = 44.0
    
    init(superView: UIView, triggerButton: UIButton) {
        self.superView = superView
        self.triggerButton = triggerButton
        super.init()
        self.setupMenuView()
    }
    
    //MARK: Menu Presentig
    
    fileprivate func setupMenuView() {
        let menuHeight: CGFloat = cellHeight * CGFloat(durations.count)
        menuView = UITableView(frame: CGRect(x: 0, y: superView.frame.size.height + menuHeight, width: superView.frame.width, height: menuHeight))
        menuView.cellLayoutMarginsFollowReadableWidth = false
        menuView.alwaysBounceVertical = false
        menuView.dataSource = self
        menuView.delegate = self
        menuView.isHidden = true
        menuView.rowHeight = cellHeight
        
        mainMenuView = UIView(frame: CGRect(x: superView.frame.origin.x, y: superView.frame.origin.y, width: superView.frame.size.width, height: superView.frame.size.height))
        mainMenuView.backgroundColor = UIColor.black.withAlphaComponent(0)
        mainMenuView.addSubview(menuView)
        
        triggerButton.addTarget(self, action: #selector(titleButtonAction), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuHandleTapGesture))
        tapGesture.delegate = self
        mainMenuView.addGestureRecognizer(tapGesture)
    }
    
    @objc func menuHandleTapGesture() {
        hideMenu()
    }
    
    @objc func titleButtonAction() {
        if menuView.isHidden {
            addMenuToSuperView()
            menuView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.mainMenuView.backgroundColor = UIColor.black.withAlphaComponent(self.menuAlpha)
                self.menuView.frame.origin.y = self.superView.frame.height - self.menuView.frame.height
            })
        } else {
            hideMenu()
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainMenuView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.menuView.frame.origin.y = self.superView.frame.size.height + self.menuView.frame.height
        }, completion: { _ in
            self.menuView.isHidden = true
            self.mainMenuView.removeFromSuperview()
        })
    }
    
    fileprivate func addMenuToSuperView() {
        superView.addSubview(mainMenuView)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == mainMenuView
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return durations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let duration = durations[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(duration) minutes"
        cell.tintColor = UIColor.black
        cell.textLabel?.textAlignment = .center
        
        if delegate.currentDuration == duration {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        let duration = durations[indexPath.row]
        delegate.didChange(duration: duration)
    }
}

protocol MenuDelegate: class {
    
    var currentDuration: Int { get }
    
    func didChange(duration: Int)
}
