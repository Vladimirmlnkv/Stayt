//
//  DurationPickerViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 05/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class DurationPickerViewController: UIViewController, TimerDisplay {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var durations = [Int]()
    
    var labelTitle: String!
    var completion: ((Int) -> Void)!
    var currentDuration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = labelTitle
        if durations.isEmpty {
            for i in 1...10 {
                durations.append(i * 60)
            }
        }
        durations.append(1)
        tableView.register(UINib(nibName: "CenteredCell", bundle: nil), forCellReuseIdentifier: "CenteredCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DurationPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        completion(durations[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = Colors.highlightedCellColor
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = UIColor.clear
    }
}

extension DurationPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return durations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredCell") as! CenteredCell
        let duration = durations[indexPath.row]
        cell.label.text = passiveStringDuration(from: duration)
        if duration == currentDuration {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
}
