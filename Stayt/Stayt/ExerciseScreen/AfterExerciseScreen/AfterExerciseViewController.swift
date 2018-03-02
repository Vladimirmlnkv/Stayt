//
//  AfterExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol AfterExerciseViewControllerDelegate {
    func didPickFeeling(_ feeling: AfterFeelingType)
}

class AfterExerciseViewController: UIViewController {

    @IBOutlet var firstMessageLabel: UILabel!
    @IBOutlet var secondMessageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var delegate: AfterExerciseViewControllerDelegate!
    
    fileprivate var options: [AfterFeelingType] = [.muchBetter, .aBitBetter, .noDifferent, .worse, .custom, .notSelected]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

}

extension AfterExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterExerciseCell") as! AfterExerciseCell
        cell.label.text = options[indexPath.row].title
        return cell
    }
}

extension AfterExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let feeling = options[indexPath.row]
        delegate.didPickFeeling(feeling)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = Colors.highlightedCellColor
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = UIColor.clear
    }
    
}
