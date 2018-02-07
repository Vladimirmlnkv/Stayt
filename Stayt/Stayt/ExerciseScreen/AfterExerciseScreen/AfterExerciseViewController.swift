//
//  AfterExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol AfterExerciseViewControllerDelegate {
    func didPickFeeling(_ feeling: String?)
}

class AfterExerciseViewController: UIViewController {

    @IBOutlet var firstMessageLabel: UILabel!
    @IBOutlet var secondMessageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var delegate: AfterExerciseViewControllerDelegate!
    
    fileprivate var options = ["Much better", "A bit better", "No different", "Worse", "Prefer not to say"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44.0
    }

}

extension AfterExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterExerciseCell") as! AfterExerciseCell
        cell.label.text = options[indexPath.row]
        return cell
    }
}

extension AfterExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let feeling = indexPath.row < options.count - 1 ? options[indexPath.row] : nil
        delegate.didPickFeeling(feeling)
    }
    
}
