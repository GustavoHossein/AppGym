//
//  ProgressHistoryViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 11/4/24.
//

import UIKit

class ProgressHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let filterLabel = UILabel() // Indicador de filtros ativos
    private var workoutProgress = [[String: String]]()
    private var allWorkoutProgress = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Histórico de Progresso"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filtro", style: .plain, target: self, action: #selector(showFilterOptions))
        
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.textColor = .gray
        filterLabel.font = UIFont.systemFont(ofSize: 14)
        filterLabel.text = "Nenhum filtro ativo"
        
        view.addSubview(filterLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "progressCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 10),
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
        
        let removeFiltersAction = UIAlertAction(title: "Remover Filtros", style: .destructive) { [weak self] _ in
            self?.removeFilters()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(filterByWorkoutAction)
        alert.addAction(filterByDateAction)
        alert.addAction(removeFiltersAction)
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
                self?.applyFilters(workoutName: workoutName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(filterAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func filterByDate() {
        let dateFilterVC = DateFilterViewController()
        dateFilterVC.onDateSelected = { [weak self] selectedDate in
            self?.applyFilters(dateString: selectedDate)
        }
        navigationController?.pushViewController(dateFilterVC, animated: true)
    }
    
    private func removeFilters() {
        workoutProgress = allWorkoutProgress
        filterLabel.text = "Nenhum filtro ativo"
        tableView.reloadData()
    }
    
    private func loadProgressData() {
        if let savedProgress = UserDefaults.standard.array(forKey: "workoutProgress") as? [[String: String]] {
            allWorkoutProgress = savedProgress
            workoutProgress = savedProgress
        }
        tableView.reloadData()
    }
    
    private func applyFilters(workoutName: String? = nil, dateString: String? = nil) {
        workoutProgress = allWorkoutProgress
        
        if let workoutName = workoutName, !workoutName.isEmpty {
            let formattedWorkoutName = workoutName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            workoutProgress = workoutProgress.filter {
                $0["workout"]?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(formattedWorkoutName) == true
            }
        }
        
        if let dateString = dateString, !dateString.isEmpty {
            workoutProgress = workoutProgress.filter {
                $0["date"]?.contains(dateString) == true
            }
        }
        
        updateFilterIndicator(workoutName: workoutName, dateString: dateString)
        tableView.reloadData()
    }
    
    private func updateFilterIndicator(workoutName: String?, dateString: String?) {
        var filterText = "Filtros aplicados: "
        
        if let workoutName = workoutName, !workoutName.isEmpty {
            filterText += "Exercício: \(workoutName) "
        }
        
        if let dateString = dateString, !dateString.isEmpty {
            filterText += "Data: \(dateString)"
        }
        
        filterLabel.text = filterText.isEmpty ? "Nenhum filtro ativo" : filterText
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
