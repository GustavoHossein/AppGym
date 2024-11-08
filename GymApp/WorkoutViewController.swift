//
//  WorkoutViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 10/28/24.
//

import UIKit

class WorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    
    // Dados da lista de treinos (pode ser substituído por uma lista dinâmica)
    let workouts = [
        "Supino",
        "Agachamento",
        "Cadeira Extensora",
        "Remada Curvada",
        "Levantamento Terra"
    ]
    
    // Imagens correspondentes aos treinos
    let workoutImages = [
        "supino_image",
        "agachamento_image",
        "cadeira_extensora_image",
        "remada_curvada_image",
        "levantamento_terra_image"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Treinos"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Histórico", style: .plain, target: self, action: #selector(showProgressHistory))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        // Configurar as constraints para a table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = workouts[indexPath.row]
        
        let imageName = workoutImages[indexPath.row]
        cell.imageView?.image = UIImage(named: imageName)
        
        cell.accessoryType = .disclosureIndicator // Indicador de que há mais informações
        return cell
    }
    
    // MARK: - UITableViewDelegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Desmarcar a seleção imediatamente após tocar
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Navegar para a tela de detalhes do treino
        let selectedWorkout = workouts[indexPath.row]
        let workoutDetailVC = WorkoutDetailViewController(workoutName: selectedWorkout)
        navigationController?.pushViewController(workoutDetailVC, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    @objc private func showProgressHistory() {
        let progressHistoryVC = ProgressHistoryViewController()
        navigationController?.pushViewController(progressHistoryVC, animated: true)
    }
}
