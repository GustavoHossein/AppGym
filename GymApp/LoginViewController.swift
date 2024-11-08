//
//  LoginViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 10/28/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let emailTextField = createTextField(withPlaceholder: "Email", isSecure: false, icon: "envelope")
    private let passwordTextField = createTextField(withPlaceholder: "Senha", isSecure: true, icon: "lock")
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastre-se", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addBackgroundGradient()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
    }
    
    // MARK: - Constraints Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Por favor, preencha todos os campos.")
            return
        }
        
        // Verificando as credenciais no UserDefaults
        if let users = UserDefaults.standard.array(forKey: "users") as? [[String: String]] {
            if let user = users.first(where: { $0["email"] == email && $0["password"] == password }) {
                // showAlert(message: "Login realizado com sucesso! Bem-vindo, \(user["name"]!).")
                let workoutVC = WorkoutViewController()
                navigationController?.setViewControllers([workoutVC], animated: true)
            } else {
                showAlert(message: "Email ou senha incorretos.")
            }
        } else {
            showAlert(message: "Nenhum usuário encontrado. Cadastre-se primeiro.")
        }
    }
    
    @objc private func signupButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func addBackgroundGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private static func createTextField(withPlaceholder placeholder: String, isSecure: Bool, icon: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Ícone à esquerda
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .gray
        iconImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingView.addSubview(iconImageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }
}
