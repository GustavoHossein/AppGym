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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filtro", style: .plain, target: self, action: #selector(showFilterOptions))
        
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
    
    @objc private func showFilterOptions() {
        let alert = UIAlertController(title: "Escolha uma opção de filtro", message: nil, preferredStyle: .actionSheet)
        
        let filterByWorkoutAction = UIAlertAction(title: "Filtrar por Exercício", style: .default) { [weak self] _ in
            self?.filterByWorkout()
        }
        
        let filterByDateAction = UIAlertAction(title: "Filtrar por Data", style: .default) { [weak self] _ in
            self?.filterByDate()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(filterByWorkoutAction)
        alert.addAction(filterByDateAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc private func filterByWorkout() {
        let alert = UIAlertController(title: "Filtrar por Exercício", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nome do exercício"
        }
        let filterAction = UIAlertAction(title: "Filtrar", style: .default) { [weak self] _ in
            if let workoutName = alert.textFields?.first?.text, !workoutName.isEmpty {
                self?.applyWorkoutFilter(workoutName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(filterAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func filterByDate() {
        let alert = UIAlertController(title: "Filtrar por Data", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Digite a data (AAAA-MM-DD)"
        }
        
        let filterAction = UIAlertAction(title: "Filtrar", style: .default) { [weak self] _ in
            if let dateString = alert.textFields?.first?.text, !dateString.isEmpty {
                self?.applyDateFilter(dateString)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(filterAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func loadProgressData() {
        workoutProgress = UserDefaults.standard.array(forKey: "workoutProgress") as? [[String: String]] ?? []
        tableView.reloadData()
    }
    
    private func applyWorkoutFilter(_ workoutName: String) {
        workoutProgress = workoutProgress.filter { $0["workout"]?.lowercased() == workoutName.lowercased() }
        tableView.reloadData()
    }

    private func applyDateFilter(_ dateString: String) {
        workoutProgress = workoutProgress.filter { $0["date"]?.contains(dateString) == true }
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
        let date = progress["date"] ?? "Data desconhecida"
        
        cell.textLabel?.text = "\(workoutName): \(series) séries, \(reps) reps, \(weight) kg - \(date)"
        return cell
    }
}
