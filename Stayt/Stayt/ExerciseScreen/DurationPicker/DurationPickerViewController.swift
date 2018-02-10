//
//  DurationPickerViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 05/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol DurationPickerViewControllerDelegate {
    func didSelect(duration: Int, for feeling: Feeling)
}

class DurationPickerViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var durations = [Int]()
    var delegate: DurationPickerViewControllerDelegate!
    var feeling: Feeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Select duration of \(feeling.descriptionName.lowercased())"
        
        for i in 1...10 {
            durations.append(i * 60)
        }
//        durations.append(1)
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
        delegate.didSelect(duration: durations[indexPath.row], for: feeling)
        dismiss(animated: true, completion: nil)
    }
    
}

extension DurationPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return durations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredCell") as! CenteredCell
        let duration = durations[indexPath.row] / 60
        let text = duration == 1 ? "minute" : "minutes"
        cell.label.text = "\(duration) \(text)"
        if duration * 60 == feeling.duration {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
}
