//
//  AfterExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 27/01/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol AfterExerciseViewControllerDelegate {
    func didPickFeeling(_ feeling: Feeling, note: String?)
    func addNoteAction()
    func skip()
}

class AfterExerciseViewController: UIViewController {

    @IBOutlet var firstMessageLabel: UILabel!
    @IBOutlet var secondMessageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNoteButton: UIButton!
    
    fileprivate var doneBarButtonItem: UIBarButtonItem!
    
    var exerciseName: String!
    
    var delegate: AfterExerciseViewControllerDelegate!
    var selectedFeeling: Feeling?
    var note: String? {
        didSet {
            if let n = note, !n.isEmpty {
                addNoteButton.setTitle("Edit note", for: .normal)
                doneBarButtonItem.isEnabled = true
            } else {
                addNoteButton.setTitle("Add note", for: .normal)
                if selectedFeeling == nil {
                    doneBarButtonItem.isEnabled = false
                }
            }
        }
    }

    fileprivate var options = [Feeling]()
    fileprivate let dataSource = FeelingsDataSrouce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = Colors.mainActiveColor
        
        options = dataSource.getFeelings()

        firstMessageLabel.text = "\(exerciseName!) completed!"
        
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @objc func doneButtonAction() {
        let feeling = selectedFeeling ?? Feeling(title: "")
        delegate.didPickFeeling(feeling, note: note)
    }
    
    @IBAction func addNoteAction(_ sender: Any) {
        delegate.addNoteAction()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        delegate.skip()
    }
    
}

extension AfterExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == options.count {
            return tableView.dequeueReusableCell(withIdentifier: "CustomFeelingCell") as! CustomFeelingCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterExerciseCell") as! AfterExerciseCell
            cell.tintColor = Colors.mainActiveColor
            if let f = selectedFeeling, options[indexPath.row] == f {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.label.text = options[indexPath.row].title
            return cell
        }
    }
}

extension AfterExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == options.count {
            
            let newFeelingView = NewFeelingView(frame: navigationController!.view.frame)
            newFeelingView.delegate = self
            navigationController?.view.addSubview(newFeelingView)
            newFeelingView.textField.becomeFirstResponder()
            
        } else {
            var indexPathsToReload = [indexPath]
            if let selected = selectedFeeling, let index = options.index(of: selected) {
                indexPathsToReload.append(IndexPath(row: index, section: 0))
            }
            if selectedFeeling == options[indexPath.row] {
                selectedFeeling = nil
                if note == nil {
                    doneBarButtonItem.isEnabled = false
                }
            } else {
                selectedFeeling = options[indexPath.row]
                doneBarButtonItem.isEnabled = true
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            tableView.endUpdates()
        }
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

extension AfterExerciseViewController: NewFeelingViewDelegate {
    func didEnter(feeling: String) {
        dataSource.add(new: feeling)
        options = dataSource.getFeelings()
        selectedFeeling = options.last
        doneBarButtonItem.isEnabled = true
        tableView.reloadData()
    }
}
