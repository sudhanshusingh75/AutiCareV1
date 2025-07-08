//
//  ChildDetailsView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 29/06/25.
//

import SwiftUI
import PhotosUI

struct ChildDetailsView: View {
    @EnvironmentObject var navManager:NavigationManager
    @State private var fullName: String = ""
    @State private var fullNameErrorMessage = ""
    @State private var dateOfBirth:Date = Date()
    @State private var dateOfBirthSet = false
    @State private var genderErrorMessage = ""
    @State private var dobErrorMessage = ""
    @State private var selectedGender: String = "Select Gender"
    let genders = ["Select Gender","Male", "Female", "Prefer Not To Say"]
    @State private var selectedUIImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    var formattedDOB: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateOfBirth)
    }
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("Enter Your Child Details")
                    .font(.title.bold())
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
            }
            ScrollView(showsIndicators:false){
                VStack{
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
                }
                .padding()
                .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                .cornerRadius(16)
                .padding()
                NavigationLink {
                    AssessmentView(child: ChildDetails(fullName: fullName, dateOfBirth: dateOfBirth, gender: selectedGender))
                        .environmentObject(navManager)
                } label: {
                    Text("Start Assessment")
                        .font(.headline.bold())
                        .padding()
                        .foregroundStyle(Color(.white))
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0, green: 0.387, blue: 0.5))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
            }
//            .toolbar(.hidden,for:.navigationBar)
        }
    }
    private func validateGender() {
        if selectedGender == "" {
            genderErrorMessage = "Please select a gender."
        } else {
            genderErrorMessage = ""
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
    
    private func isValidFullName(_ fullName: String) -> Bool {
        let nameComponents = fullName.split(separator: " ")
        return nameComponents.count >= 1
    }
    
    private func validateDOB() {
        let calendar = Calendar.current
        let today = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: today)
        
        if let age = ageComponents.year, age < 2 {
            dobErrorMessage = "Child must be at least 2 years old."
        } else {
            dobErrorMessage = ""
        }
    }
}

#Preview {
    ChildDetailsView()
}
