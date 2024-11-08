//
//  UserDatabase.swift
//  GymApp
//
//  Created by Gustavo Hossein on 10/29/24.
//

import Foundation

class UserDatabase {
    // Simulando um banco de dados com array de usuários
    private var users: [User] = []
    
    // Verificar se um email já está cadastrado
    func isEmailRegistered(_ email: String) -> Bool {
        return users.contains(where: {$0.email == email})
    }
    
    // Cadastra um novo usuário se o email não estiver registrado
    func registerUser(name: String, email: String, password: String) -> Bool {
        if isEmailRegistered(email) {
            return false // Email ja Cadastrado
        }
        let newUser = User(name: name, email: email, password: password)
        users.append(newUser)
        return true // Cadastro realizado com sucesso
    }
    
    // Simulando a verificação de login
    func loginUser(email: String, password: String) -> Bool {
        return users.contains(where: { $0.email == email && $0.password == password})
    }
    
}
