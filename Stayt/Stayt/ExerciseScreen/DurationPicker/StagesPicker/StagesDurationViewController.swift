//
//  StagesDurationViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol StagesDurationViewControllerDelegate: class {
    func didSelect(stage: ActivityStage)
    func didPressDoneButton()
}

class StagesDurationViewController: UIViewController, TimerDisplay {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var stages: [ActivityStage]!
    var exerciseName: String!
    var titleText: String?
    weak var delegate: StagesDurationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        
        if let text = titleText {
            titleLabel.text = titleText
        } else {
            titleLabel.text = "\(exerciseName!) contains different stages"
        }
        
        
        navigationController?.navigationBar.tintColor = Colors.mainActiveColor
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        navigationItem.title = "Stages"
    }
    
    @objc func doneButtonAction() {
        delegate?.didPressDoneButton()
    }

}

extension StagesDurationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StageCell") as! StageCell
        let stage = stages[indexPath.row]
        cell.nameLabel.text = stage.name
        cell.durationLabel.text = passiveStringDuration(from: stage.duration)
        if stage.allowsEditDuration {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
}

extension StagesDurationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(stage: stages[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = Colors.highlightedCellColor
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return stages[indexPath.row].allowsEditDuration
    }
    
}
