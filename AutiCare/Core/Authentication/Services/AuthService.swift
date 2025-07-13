//
//  AuthService.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/07/25.
//

import Foundation
import FirebaseAuth

class AuthService{
    private let shared = AuthService()
    private init(){
        
    }
    //createAccount
    func createAccount(email:String,password:String)async throws{
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    //login
    func login(email:String,password:String)async throws{
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    //logout
    func logout() async {
      try? Auth.auth().signOut()
    }
    func sendEmailVerification() async throws{
        guard let user = Auth.auth().currentUser else { return }
        try await user.sendEmailVerification()
    }
}
