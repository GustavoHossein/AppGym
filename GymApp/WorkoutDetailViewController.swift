//
//  WorkoutDetailViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 11/1/24.
//

import UIKit

class WorkoutDetailViewController: UIViewController {
    
    private let workoutName: String
    private let seriesTextField = UITextField()
    private let repsTextField = UITextField()
    private let weightTextField = UITextField()
    private let saveProgressButton = UIButton(type: .system)
    
    // Inicializador para passar o nome do treino
    init(workoutName: String) {
        self.workoutName = workoutName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = workoutName // Definir o nome do treino no título da tela
        
        setupUI()
    }
    
    private func setupUI() {
        // Exibir a descrição detalhada do treino
        setupTextField(seriesTextField, placeholder: "Séries")
        setupTextField(repsTextField, placeholder: "Repetições")
        setupTextField(weightTextField, placeholder: "Peso (Kg)")
        
        saveProgressButton.setTitle("Salvar Progresso", for: .normal)
        saveProgressButton.addTarget(self, action: #selector(saveProgress), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [seriesTextField, repsTextField, weightTextField, saveProgressButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Configurar as constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func saveProgress() {
        guard let series = seriesTextField.text, !series.isEmpty,
              let reps = repsTextField.text, !reps.isEmpty,
              let weight = weightTextField.text, !weight.isEmpty else {
            showAlert(message: "Por favor, preencha todos os campos.")
            return
        }
            
        // Armazenar os dados de progresso UserDefaults
        let progressData = ["series": series, "reps": reps, "weight": weight]
        
        var workoutProgress = UserDefaults.standard.array(forKey: "workoutProgress") as? [[String: String]] ?? []
        workoutProgress.append(progressData)
        
        UserDefaults.standard.set(workoutProgress, forKey: "workoutProgress")
        
        showAlert(message: "Progresso salvo com sucesso!")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
