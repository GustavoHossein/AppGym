//
//  HomeViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 10/28/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bem-vindo(a) à Academia!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ver Treinos", for: .normal)
        button.addTarget(self, action: #selector(workoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(workoutButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            workoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutButton.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
        ])
    }
    
    // MARK: - Actions
    @objc private func workoutButtonTapped() {
        let workoutVC = WorkoutViewController()
        navigationController?.pushViewController(workoutVC, animated: true)
    }
    
}
