//
//  HistoryViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 07/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var items: [HistoryItem] {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems
        } else {
            return historyItems
        }
    }
    fileprivate var filteredItems = [HistoryItem]()
    fileprivate var historyItems: [HistoryItem]! {
        didSet {
            if historyItems.isEmpty {
                let emptyView = EmptyView()
                emptyView.messageLabel.text = "You haven't done any exercises yet. You'll see something here once you complete at least 1 exercise. Good luck!"
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
    fileprivate let dataSource = HistoryDataSource()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = Colors.mainActiveColor
        historyItems = dataSource.getItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 65.0
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.title = "History"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !historyItems.isEmpty {
            if #available(iOS 11, *) {
                if navigationItem.searchController == nil {
                    navigationItem.searchController = searchController
                    navigationItem.hidesSearchBarWhenScrolling = false
                    searchController.delegate = self
                    searchController.searchResultsUpdater = self
                    searchController.dimsBackgroundDuringPresentation = false
                    searchController.searchBar.keyboardAppearance = .dark
                    searchController.searchBar.tintColor = UIColor.white
                    definesPresentationContext = true
                    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
                }
            } else if tableView.tableHeaderView == nil {
                tableView.tableHeaderView = searchController.searchBar
            }
        }
        historyItems = dataSource.getItems()
        tableView.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if #available(iOS 11, *) {
//            navigationItem.hidesSearchBarWhenScrolling = true
//        }
//    }
    
    fileprivate func filterContentForSearchText(_ text: String) {
        var newItems = [HistoryItem]()
        for item in historyItems {
            if stringTitle(from: item.date).contains(text) {
                newItems.append(item)
            } else {
                let experiences: [Experience] = item.experiences.filter({ (experience) -> Bool in
                    if experience.afterFeeling == nil { return false }
                    if experience.exerciseName.lowercased().contains(text.lowercased()) {
                        return true
                    }
                    if let afterFeelingText = experience.afterFeeling?.text {
                        return afterFeelingText.lowercased().contains(text.lowercased())
                    } else if experience.afterFeeling!.type != .notSelected {
                        return experience.afterFeeling!.type.title.lowercased().contains(text.lowercased())
                    }
                    return false
                })
                if !experiences.isEmpty {
                    let newItem = HistoryItem(date: item.date, experiences: experiences)
                    newItems.append(newItem)
                }
            }
        }
        filteredItems = newItems
        tableView.reloadData()
    }
    
    fileprivate func stringTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: date)
    }
}

extension HistoryViewController: CustomFeelingViewControllerDelegate {
    
    func didEnter(feeling: String, for experience: Experience) {
        dataSource.add(afterFeeling: feeling, for: experience)
        navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "CustomFeelingViewController") as! CustomFeelingViewController
        vc.experience = items[indexPath.section].experiences[indexPath.row]
        vc.shouldAddCancelButton = false
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = Colors.highlightedCellColor
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        if let v = view as? UITableViewHeaderFooterView {
            v.textLabel?.textColor = UIColor.white
        }
    }
}

extension HistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryItemCell") as! HistoryItemCell
        let experience = items[indexPath.section].experiences[indexPath.row]
        cell.exerciseLabel.text = experience.exerciseName
        cell.durationLabel.text = "\(experience.duration / 60) min"
        cell.selectionStyle = .none
        if let afterFeeling = experience.afterFeeling {
            if afterFeeling.type == .notSelected {
                cell.feelingLabel.isHidden = true
            } else if afterFeeling.type == .custom {
                cell.feelingLabel.isHidden = false
                cell.feelingLabel.text = afterFeeling.text
            } else {
                cell.feelingLabel.isHidden = false
                cell.feelingLabel.text = "You felt: \(afterFeeling.type.title)"
            }
        } else {
            cell.feelingLabel.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stringTitle(from: items[section].date)
    }
}

extension HistoryViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
