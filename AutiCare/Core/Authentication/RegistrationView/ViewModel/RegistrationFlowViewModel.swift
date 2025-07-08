//
//  RegistrationFlowViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 06/07/25.
//

import Foundation
import SwiftUI

class RegistrationFlowViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var fullName = ""
    @Published var username = ""
    @Published var dateOfBirth = Date()
    @Published var selectedGender = "Select Gender"
    @Published var selectedImage: UIImage?
    @Published var dateOfBirthSet: Bool = false
    @Published var dobErrorMessage: String = ""
    @Published var genderErrorMessage:String = ""
    let genders = ["Select Gender","Male", "Female", "Prefer Not To Say"]
    
    var formatedDateOfBirth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: dateOfBirth)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func emailValidationMessage(_ email: String) -> String? {
        return isValidEmail(email) ? nil : "Please enter a valid email address."
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let regex = "(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{6,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    func passwordValidationMessage(_ password: String) -> String? {
        return isValidPassword(password) ? nil : "Password must be at least 6 characters, include uppercase, lowercase, a number and a special character."
    }
    func vaildateDateOfBirth(){
        let calendar = Calendar.current
        let today = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: today)
        
        if let age = ageComponents.year, age < 18 {
            dobErrorMessage = "You must be at least 18 years old."
        } else {
            dobErrorMessage = ""
        }
    }
    func validateGender() {
        if selectedGender == "" {
            genderErrorMessage = "Please select a gender."
        } else {
            genderErrorMessage = ""
        }
    }
    
    @MainActor
    func finalizeRegistration(authViewModel: AuthViewModel) async {
        var baseUsername = fullName.split(separator: " ").first?.lowercased() ?? "user"
        baseUsername = baseUsername.replacingOccurrences(of: "\\W+", with: "", options: .regularExpression)

        var uniqueUsername = baseUsername
        var attempt = 0
        while true {
            let isUnique = await authViewModel.checkUsernameUniqueness(uniqueUsername)
            if isUnique { break }
            attempt += 1
            uniqueUsername = "\(baseUsername)_\(Int.random(in: 1000..<9999))"
            if attempt > 10 { break } // prevent infinite loop
        }

        do {
            try await authViewModel.completeUserProfile(
                fullName: fullName,
                profileImage: selectedImage,
                userName: uniqueUsername,
                dateOfBirth: dateOfBirth,
                gender: selectedGender
            )

        } catch {
            print("❌ Registration failed: \(error.localizedDescription)")
        }
    }


}
