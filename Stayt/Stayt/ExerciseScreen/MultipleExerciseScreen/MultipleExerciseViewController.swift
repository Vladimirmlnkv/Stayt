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
    
    @IBOutlet var roundsView: UIView!
    @IBOutlet var roundsCountLabel: UILabel!
    @IBOutlet var increaseRoundsButton: UIButton!
    @IBOutlet var decreaseRoundsButton: UIButton!
    @IBOutlet var roundsTitleLabel: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    @IBOutlet var difficultyLevelView: UIView!
    @IBOutlet var difficultyButton: DisclosureButton!
    @IBOutlet var difficultyTitle: UILabel!
    
    @IBOutlet var circleView: AnimatedCircleView!
    
    var viewModel: MultipleExerciseViewModel!
    fileprivate var holderHandler: HolderViewHandler!
    fileprivate var restViewHandler: RestViewHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        roundsCountLabel.text = "\(viewModel.roundsCount)"
        decreaseRoundsButton.isEnabled = false
        if viewModel.shouldShowDifficulty {
            difficultyLevelView.isHidden = false
            difficultyButton.setTitle(viewModel.difficultyName, for: .normal)
        } else {
            difficultyLevelView.isHidden = true
        }
        
        if !viewModel.allowsRounds {
            roundsView.isHidden = true
            roundsCountLabel.isHidden = true
            increaseRoundsButton.isHidden = true
            decreaseRoundsButton.isHidden = true
            roundsTitleLabel.isHidden = true
        }
        configureTableView()
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.setEditing(viewModel.allowsReordering, animated: false)
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
    
    @IBAction func increaseRoundsAction(_ sender: Any) {
        viewModel.increaseRounds()
    }
    
    @IBAction func difficultyButtonAction(_ sender: Any) {
        viewModel.changeDifficulty()
    }
    
    @IBAction func decreaseRoundsAction(_ sender: Any) {
        viewModel.decreaseRounds()
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
        tableView.reloadData()
    }
    
    func realodRows(at indexes: [Int]) {
        let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths, with: .none)
        tableView.endUpdates()
    }
    
    func showHolder(with transitionTime: Int, delegate: HolderViewHandlerDelegate, activity: Activity) {
        holderHandler = HolderViewHandler(superView: view, delegate: delegate, activity: activity, transitionTime: transitionTime)
        holderHandler.start()
    }
    
    func showRestView(with restTime: Int, delegate: RestViewHandlerDelegate) {
        restViewHandler = RestViewHandler(superView: view, delegate: delegate, restTime: restTime)
        restViewHandler.start()
    }
    
    func updateRoundsLabel(_ newValue: Int) {
        roundsCountLabel.text = "\(newValue)"
    }
    
    func hideRoundsView() {
        increaseRoundsButton.isHidden = true
        decreaseRoundsButton.isHidden = true
        roundsCountLabel.isHidden = true
    }
    
    func setIncreaseButton(isHidden: Bool) {
        increaseRoundsButton.isEnabled = !isHidden
    }
    
    func setDecreaseButton(isHidden: Bool) {
        decreaseRoundsButton.isEnabled = !isHidden
    }
    
    func updateRoundsTitleLabel(_ newValue: String) {
        roundsTitleLabel.text = newValue
    }
    
    func removeRestTimeRow() {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        tableView.deleteSections([1], with: .automatic)
        tableView.endUpdates()
    }
    
    func showRestTimeRow() {
        tableView.beginUpdates()
        tableView.insertSections([1], with: .automatic)
        tableView.endUpdates()
    }
    
    func reloadRestTime() {
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        tableView.endUpdates()
    }
    
    func startProgressBar(with duration: Int) {
        circleView.animateCircle(duration: Double(duration))
    }
    
    func pauseProgressBar() {
        circleView.stopAnimation()
    }
    
    func resumeProgressBar() {
        circleView.resumeAnimation()
    }
    
    func hideQuestionIcon() {
        UIView.animate(withDuration: 0.3, animations: {
            self.infoButton.alpha = 0
        }) { _ in
            self.infoButton.isHidden = true
        }
    }
    
    func setDifficulty(_ difficulty: String) {
        difficultyButton.setTitle(difficulty, for: .normal)
    }
}

extension MultipleExerciseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.activitiesCount
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.activities[indexPath.row].stages.count > 0 && viewModel.currentActivityNumber == indexPath.row && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StagesActivityCell") as! StagesActivityCell
            cell.configure(with: viewModel.activityCellViewModel(for: indexPath))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleActivityCell") as! SingleActivityCell
            cell.configure(with: viewModel.activityCellViewModel(for: indexPath))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveActivity(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension MultipleExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
}
