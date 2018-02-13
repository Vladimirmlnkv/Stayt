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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        historyItems = dataSource.getItems()
        tableView.reloadData()
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
        vc.experience = historyItems[indexPath.section].experiences[indexPath.row]
        vc.shouldAddCancelButton = false
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return historyItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems[section].experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryItemCell") as! HistoryItemCell
        let experience = historyItems[indexPath.section].experiences[indexPath.row]
        cell.exerciseLabel.text = experience.exerciseName
        cell.durationLabel.text = "\(experience.duration / 60) min"
        if let feeling = experience.feelingAfter {
            cell.feelingLabel.isHidden = false
            cell.feelingLabel.text = "You felt: \(feeling)"
        } else {
            cell.feelingLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: historyItems[section].date)
    }
}
