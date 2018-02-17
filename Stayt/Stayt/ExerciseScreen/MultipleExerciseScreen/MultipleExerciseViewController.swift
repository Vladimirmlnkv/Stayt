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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        tableView.dataSource = self
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

extension MultipleExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activitiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleActivityCell") as! SingleActivityCell
        cell.configure(with: viewModel.activities[indexPath.row], delegate: viewModel, isCompleted: viewModel.isAcitivityCompleted(at: indexPath.row), allowsEditing: viewModel.allowsEditingDuration)
        return cell
    }
}
