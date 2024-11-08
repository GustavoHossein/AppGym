import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - UI Elements
    private let nameTextField = createTextField(withPlaceholder: "Nome", isSecure: false, icon: "person")
    private let emailTextField = createTextField(withPlaceholder: "Email", isSecure: false, icon: "envelope")
    private let passwordTextField = createTextField(withPlaceholder: "Senha", isSecure: true, icon: "lock")
    private let confirmPasswordTextField = createTextField(withPlaceholder: "Confirmar Senha", isSecure: true, icon: "lock")
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastrar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Criando uma instância do "banco de dados" local
    private let userDatabase = UserDatabase()

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
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
    }

    // MARK: - Constraints Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),

            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 250),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func registerButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Por favor, preencha todos os campos.")
            return
        }
        
        // Validando Email
        guard isValidEmail(email) else {
            showAlert(message: "Por favor, insira um email válido.")
            return
        }
        
        // Validando Senha
        guard isValidPassword(password) else {
            showAlert(message: "A senha deve ter no mínimo 8 caracteres, com pelo menos uma letra e um número.")
            return
        }
        
        // Verificando se as senhas coincidem
        guard password == confirmPassword else {
            showAlert(message: "As senhas não coincidem.")
            return
        }
        
        // Verificar se já tem email cadastrado
        if isEmailRegistered(email) {
            showAlert(message: "Este email já está cadastrado.")
        } else {
            // Salvando os dados no UserDefaults
            let user = ["name": name, "email": email, "password": password]
            var users = UserDefaults.standard.array(forKey: "users") as? [[String: String]] ?? []
            users.append(user)
            UserDefaults.standard.set(users, forKey: "users")
            
            showAlert(message: "Cadastro realizado com sucesso!")
        }
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
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .gray
        iconImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingView.addSubview(iconImageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }
    
    // MARK: - Validações

    // Função para verificar se o email está cadastrado
    private func isEmailRegistered(_ email: String) -> Bool {
        if let users = UserDefaults.standard.array(forKey: "users") as? [[String: String]] {
            return users.contains { $0["email"] == email}
        }
        return false
    }
    
    // Função para validar formato de email usando regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // Função para validar a senha
    private func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false } // 8 letras no minimo
        
        let letterRange = password.rangeOfCharacter(from: .letters) // pelo menos 1 letra
        let numberRange = password.rangeOfCharacter(from: .decimalDigits) // pelo menos um número
        
        return letterRange != nil && numberRange != nil
    }
}
