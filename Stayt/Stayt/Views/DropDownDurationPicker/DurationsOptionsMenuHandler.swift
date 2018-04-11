//
//  DurationsOptionsMenuHandler.swift
//  Stayt
//
//  Created by Владимир Мельников on 04/03/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class DurationsOptionsMenuHandler<T: Equatable>: NSObject, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, TimerDisplay {
    
    fileprivate var menuView: DropDownDurationPicker!
    fileprivate var mainMenuView: UIView!
    fileprivate var menuAlpha: CGFloat = 0.4
    
    fileprivate let superView: UIView
    fileprivate let cellHeight: CGFloat = 55.0
    
    var currentOption: T?
    var completion: ((T) -> Void)!
    var titleText: String!
    var options: [T] = [T]()
    
    init(superView: UIView, title: String, options: [T]?=nil) {
        self.superView = superView
        self.titleText = title
        if let options = options {
            self.options = options
        }
        super.init()
        self.setupMenuView()
    }
    
    //MARK: Menu Presentig
    
    fileprivate func setupMenuView() {
        let textHeight = height(for: titleText, for: superView.frame.width - 20, font: UIFont.systemFont(ofSize: 20, weight: .semibold))
        let menuHeight: CGFloat = cellHeight * CGFloat(options.count) + textHeight + 20
        
        menuView = DropDownDurationPicker(frame: CGRect(x: 0, y: superView.frame.size.height + menuHeight, width: superView.frame.width, height: menuHeight))
        menuView.tableView.cellLayoutMarginsFollowReadableWidth = false
        menuView.tableView.alwaysBounceVertical = false
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
        menuView.tableView.rowHeight = cellHeight
        menuView.titleLabel.text = titleText
        menuView.tableView.register(UINib(nibName: "CenteredCell", bundle: nil), forCellReuseIdentifier: "CenteredCell")
        mainMenuView = UIView(frame: CGRect(x: superView.frame.origin.x, y: superView.frame.origin.y, width: superView.frame.size.width, height: superView.frame.size.height))
        mainMenuView.backgroundColor = UIColor.black.withAlphaComponent(0)
        mainMenuView.addSubview(menuView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuHandleTapGesture))
        tapGesture.delegate = self
        mainMenuView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func height(for string: String, for width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = string.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
        return actualSize.height
    }
    
    @objc func menuHandleTapGesture() {
        hideMenu()
    }
    
    func showMenu() {
        addMenuToSuperView()
        UIView.animate(withDuration: 0.3, animations: {
            self.mainMenuView.backgroundColor = UIColor.black.withAlphaComponent(self.menuAlpha)
            self.menuView.frame.origin.y = self.superView.frame.height - self.menuView.frame.height
        })
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainMenuView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.menuView.frame.origin.y = self.superView.frame.size.height + self.menuView.frame.height
        }, completion: { _ in
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
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredCell") as! CenteredCell
        cell.backgroundColor = UIColor.black
        if option is Int {
            cell.label.text = passiveStringDuration(from: option as! Int)
        } else if option is String {
            cell.label.text = option as! String
        }
        cell.label.textColor = UIColor.white
        cell.tintColor = Colors.mainActiveColor
        cell.label.textAlignment = .center
        cell.label.font = UIFont.boldSystemFont(ofSize: 18)
        
        if let currentOption = currentOption, currentOption == option {
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
        let option = options[indexPath.row]
        hideMenu()
        completion(option)
    }
}
