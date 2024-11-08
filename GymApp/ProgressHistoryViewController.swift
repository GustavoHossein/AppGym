//
//  ProgressHistoryViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 11/4/24.
//

import UIKit

class ProgressHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var workoutProgress = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Histórico de Progresso"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "progressCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadProgressData()
    }
    
    private func loadProgressData() {
        workoutProgress = UserDefaults.standard.array(forKey: "workoutProgress") as? [[String: String]] ?? []
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutProgress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath)
        let progress = workoutProgress[indexPath.row]
        let workoutName = progress["workout"] ?? "Treino"
        let series = progress["series"] ?? "0"
        let reps = progress["reps"] ?? "0"
        let weight = progress["weight"] ?? "0"
        
        cell.textLabel?.text = "\(workoutName): \(series) séries, \(reps) reps, \(weight) kg"
        return cell
    }
}
