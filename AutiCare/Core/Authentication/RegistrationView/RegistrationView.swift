//
//  RegistrationView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//
import SwiftUI
import PhotosUI
struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    @State private var confirmPassword: String = ""
    @State private var userName:String = ""
    @State private var dateOfBirth:Date = Date()
    @State private var dateOfBirthSet = false
    
    var formattedDOB: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateOfBirth)
    }
    
    @State private var selectedGender: String = "Select Gender"
    let genders = ["Select Gender","Male", "Female", "Prefer Not To Say"]
    
    @State private var selectedUIImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var confirmPasswordErrorMessage = ""
    @State private var fullNameErrorMessage = ""
    @State private var userNameErrorMessage = ""
    @State private var dobErrorMessage = ""
    @State private var genderErrorMessage = ""
    
    @State private var alertMessage:String? = nil
    @State private var showAlert:Bool = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            ScrollView{
            VStack {
                VStack {
                    PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                        if let selectedUIImage = selectedUIImage {
                            Image(uiImage: selectedUIImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 2)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .padding(.all,40)
                                .frame(width: 200, height: 200,alignment: .center)
                                .foregroundStyle(Color.white)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                        }
                    }
                    .onChange(of: photosPickerItem) { _, newValue in
                        Task {
                            guard let selectedItem = newValue else { return }
                            if let data = try? await selectedItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                self.selectedUIImage = uiImage
                            }
                        }
                    }
                }
                .padding(.top, 32)
                .padding(.bottom)
                
                VStack(spacing: 12) {
                    InputView(text: $fullName, title: "Full Name :", placeholder: "Enter Your Name", errorMessage: fullNameErrorMessage)
                        .onChange(of: fullName) { validateFullName() }
                    VStack(alignment:.leading,spacing:12) {
                        HStack{
                            VStack(alignment:.leading){
                                Text("Date Of Birth :")
                                    .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(dateOfBirthSet ? formattedDOB : "DD/MM/YYYY")
                                    .font(.system(size: 14))
                                    .foregroundStyle(dateOfBirthSet ? .black : Color(.placeholderText))
                            }
                            DatePicker("", selection: $dateOfBirth,displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .frame(height:44)
                                .onChange(of: dateOfBirth){
                                    dateOfBirthSet = true
                                    validateDOB()
                                }
                        }
                        
                        Divider()
                        if !dobErrorMessage.isEmpty {
                            Text(dobErrorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    VStack (spacing:12){
                        HStack {
                            VStack(alignment:.leading){
                                Text("Gender :")
                                    .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                Spacer()
                                if selectedGender == "Select Gender"{
                                    Text("Select Gender")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(.placeholderText))
                                }
                                else{
                                    Text(selectedGender)
                                        .font(.system(size:14))
                                        .foregroundStyle(Color(.black))
                                }
                            }
                            Spacer()
                            Picker("Select Gender", selection: $selectedGender) {
                                ForEach(genders , id:\.self){ gender in
                                    Text(gender).tag(gender)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                            }.pickerStyle(MenuPickerStyle())
                                .frame(height:44)
                                .onChange(of: selectedGender){
                                    validateGender()
                                }
                            if !genderErrorMessage.isEmpty {
                                Text(genderErrorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        Divider()
                    }
                    InputView(text: $email, title: "Email Address :", placeholder: "name@example.com", errorMessage: emailErrorMessage)
                        .textInputAutocapitalization(.never)
                        .onChange(of: email) { validateEmail() }
                    
                    InputView(text: $userName, title: "Username :", placeholder:"Choose a unique Username",errorMessage: userNameErrorMessage)
                        .textInputAutocapitalization(.never)
                        .onChange(of: userName) { _,_ in
                            Task {
                                await validateUsername()
                            }
                        }
                    
                    InputView(text: $password, title: "Password :", placeholder: "Enter Your Password", isSecureField: true, errorMessage: passwordErrorMessage)
                        .onChange(of: password) { validatePassword() }
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password :", placeholder: "Confirm Your Password", isSecureField: true, errorMessage: confirmPasswordErrorMessage)
                            .onChange(of: confirmPassword) { validateConfirmPassword() }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                ButtonView(title: "SIGN UP") {
                    Task {
                        do {
                            try await viewModel.createUser(withEmail: email, password: password, fullName: fullName, profileImage: selectedUIImage, userName: userName,dateOfBirth:dateOfBirth,gender:selectedGender)
                        } catch {
                            alertMessage = "\(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.top, 24)
            }
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an Account?")
                    Text("Sign In")
                }
                .font(.system(size: 14))
                .foregroundStyle(Color(.systemGray))
                .padding(.top, 8)
            }
            Spacer()
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onTapGesture {
            hideKeyboard()
        }
        .alert("❗ Error Creating Account", isPresented: $showAlert) {  // Use custom alert title and show when triggered
                    Button("OK", role: .cancel) {}
                } message: {
                    if let alertMessage = alertMessage{
                        Text(alertMessage)  // Show the error message in the alert
                            .foregroundStyle(Color.red)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension RegistrationView: AuthenticationProtocol {
    var formIsValid: Bool {
        return isValidEmail(email) &&
               isValidPassword(password) &&
               password == confirmPassword &&
               !fullName.isEmpty &&
               isValidFullName(fullName)
    }
    
    private func validateDOB() {
        let calendar = Calendar.current
        let today = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: today)
        
        if let age = ageComponents.year, age < 16 {
            dobErrorMessage = "You must be at least 16 years old."
        } else {
            dobErrorMessage = ""
        }
    }

    private func validateGender() {
        if selectedGender == "" {
            genderErrorMessage = "Please select a gender."
        } else {
            genderErrorMessage = ""
        }
    }

    
    private func validateEmail() {
        if !isValidEmail(email) {
            emailErrorMessage = "Please enter a valid email address."
        } else {
            emailErrorMessage = ""
        }
    }
    
    private func validatePassword() {
        if !isValidPassword(password) {
            passwordErrorMessage = "Password must be at least 6 characters long and include 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character."
        } else {
            passwordErrorMessage = ""
        }
    }
    
    private func validateConfirmPassword() {
        if password != confirmPassword {
            confirmPasswordErrorMessage = "Password and Confirm Password do not match."
        } else {
            confirmPasswordErrorMessage = ""
        }
    }
    
    private func validateFullName() {
        if fullName.isEmpty {
            fullNameErrorMessage = "Full name cannot be empty."
        } else if !isValidFullName(fullName) {
            fullNameErrorMessage = "Full name must contain at least two words (first and last name)."
        } else {
            fullNameErrorMessage = ""
        }
    }
    
    private func validateUsername() async {
            if !isValidUsername(userName) {
                userNameErrorMessage = "Username must be 4-20 characters, using letters, numbers, and underscores."
                return
            }

            let isUnique = await viewModel.checkUsernameUniqueness(userName)
        userNameErrorMessage = isUnique ? "" : "Username is already taken. Try another."
        }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }

    private func isValidFullName(_ fullName: String) -> Bool {
        let nameComponents = fullName.split(separator: " ")
        return nameComponents.count >= 1
    }
    
    private func isValidUsername(_ username: String) -> Bool {
            let usernameRegex = "^(?!.*__)[a-zA-Z0-9_]{4,20}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
            return predicate.evaluate(with: username)
        }
}

#Preview {
    RegistrationView()
}
