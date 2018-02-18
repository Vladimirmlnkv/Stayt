//
//  MultipleExerciseViewController.swift
//  Stayt
//
//  Created by Владимир Мельников on 17/02/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MultipleExerciseViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playButton: UIButton!
    
    var viewModel: MultipleExerciseViewModel!
    fileprivate var holderHandler: HolderViewHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        configureTableView()
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.setEditing(true, animated: false)
    }

    @IBAction func crossButtonAction(_ sender: Any) {
        viewModel.dismiss()
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        viewModel.playButtonAction()
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        viewModel.showInfo()
    }
}

extension MultipleExerciseViewController: MultipleExerciseViewModelDelegate {
    
    func setEditing(_ isEditing: Bool) {
        tableView.setEditing(isEditing, animated: true)
    }
    
    func updatePlayButton(image newImage: UIImage) {
        playButton.setImage(newImage, for: .normal)
    }
    
    func disableUI() {
        playButton.isEnabled = false
    }
    
    func reloadTableView() {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.beginUpdates()
            tableView.reloadRows(at: indexPaths, with: .automatic)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    func realodRows(at indexes: [Int]) {
        let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths, with: .none)
        tableView.endUpdates()
    }
    
    func showHolder(with delegate: HolderViewHandlerDelegate, activity: Feeling) {
        holderHandler = HolderViewHandler(superView: view, delegate: delegate, feeling: activity)
        holderHandler.start()
    }
    
}

extension MultipleExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activitiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleActivityCell") as! SingleActivityCell
        cell.configure(with: viewModel.activityCellViewModel(for: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveActivity(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension MultipleExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
}
