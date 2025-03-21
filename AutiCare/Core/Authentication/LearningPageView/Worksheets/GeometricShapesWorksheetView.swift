//
//  GeometricShapesWorksheetView.swift
//  Auticare
//
//  Created by sourav_singh on 21/02/25.
//

import SwiftUI

struct geometricalShapeView: View {
    struct Vegetable {
            let imageName: String
            let correctAnswer: String
            let options: [String]
        }
        
        let vegetables: [Vegetable] = [
            Vegetable(imageName: "circle", correctAnswer: "Circle", options: ["Circle", "Rectangle", "Pentagon", "Triangle"]),
            Vegetable(imageName: "rectangle", correctAnswer: "Rectangle", options: ["Circle", "Rectangle", "Pentagon", "Triangle"]),
            Vegetable(imageName: "pentagon", correctAnswer: "Pentagon", options: ["Circle", "Rectangle", "Pentagon", "Triangle"]),
            Vegetable(imageName: "triangle", correctAnswer: "Triangle", options: ["Circle", "Rectangle", "Pentagon", "Triangle"]),
            Vegetable(imageName: "square", correctAnswer: "Square", options: ["Circle", "Rectangle", "Square", "Triangle"])
        ]
        
    @State private var currentQuestionIndex = 0
        @State private var correctAnswers = 0
        @State private var showAlert = false
        @State private var alertMessage = ""
        @State private var quizCompleted = false
        @Environment(\.presentationMode) var presentationMode
        
        var progress: Double {
            return Double(currentQuestionIndex) / Double(vegetables.count)
        }
        
        var body: some View {
            VStack(spacing: 20) {
                if quizCompleted {
                    VStack(spacing: 20) {
                        Text("Quiz Completed!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.green)
                            .padding()
                        
                        Text("Your Score: \(correctAnswers) / \(vegetables.count)")
                            .font(.title)
                            .padding()
                        
                        Button("Return to Learning") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1).edgesIgnoringSafeArea(.all))
                } else {
                    Text("Identify the Shape!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                        .padding()
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                    
                    Image(vegetables[currentQuestionIndex].imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding()
                    
                    VStack(spacing: 10) {
                        ForEach(vegetables[currentQuestionIndex].options, id: \..self) { option in
                            Button(action: {
                                checkAnswer(option)
                            }) {
                                Text(option)
                                    .font(.title2)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.yellow.opacity(0.8))
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("Next")) {
                    nextQuestion()
                })
            }.toolbar(.hidden, for: .tabBar)
            .padding()
            
        }
        
        func checkAnswer(_ selected: String) {
            if selected == vegetables[currentQuestionIndex].correctAnswer {
                alertMessage = "Correct! Well done."
                correctAnswers += 1
            } else {
                alertMessage = "Oops! Try again."
            }
            showAlert = true
        }
        
        func nextQuestion() {
            if currentQuestionIndex < vegetables.count - 1 {
                currentQuestionIndex += 1
            } else {
                quizCompleted = true
            }
        }
    }

    struct geometricalShapeView_preview: PreviewProvider {
        static var previews: some View {
            geometricalShapeView()
        }
    }

