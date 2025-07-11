//
//  AssessmentView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 30/06/25.
//

import SwiftUI

import SwiftUI

struct AssessmentView: View {
    @EnvironmentObject var navManager: NavigationManager
    @StateObject var viewModel = AssessmentViewModel()
    @State private var currentCategoryIndex = 0
    @State private var showIncompleteAlert = false
    @State private var navigateToResults = false
    let child:ChildDetails
    var body: some View {
        VStack(spacing: 24) {
            // Show current category name
            Text(viewModel.question[currentCategoryIndex].questionCategory.rawValue)
                .font(.title)
                .bold()
                .padding(.top)
            ProgressView(value: Double(currentCategoryIndex + 1), total: Double(viewModel.question.count))
                .padding(.horizontal)
                .accentColor(Color(red: 0, green: 0.387, blue: 0.5))
                .animation(.easeInOut, value: currentCategoryIndex)
            // Show questions for current category
            ScrollView(showsIndicators: false){
                OptionLegendView()
                VStack {
                    ForEach(viewModel.question[currentCategoryIndex].questions.indices, id: \.self) { qIndex in
                        QuestionsCardView(
                            selectedOption: $viewModel.question[currentCategoryIndex].questions[qIndex].selectedOption,
                            question: viewModel.question[currentCategoryIndex].questions[qIndex].text
                        )
                    }
                }
            }
            
            // Show Next or Submit Button
            Button(action: {
                if !isCurrentCategoryComplete() {
                    showIncompleteAlert = true
                    return
                }
                
                if currentCategoryIndex < viewModel.question.count - 1 {
                    currentCategoryIndex += 1
                } else {
                    viewModel.submitAssessment(for: child)
                    navigateToResults = true
                }
            }) {
                Text(currentCategoryIndex == viewModel.question.count - 1 ? "Submit" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0, green: 0.387, blue: 0.5))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .alert("Please answer all questions in this section.", isPresented: $showIncompleteAlert) {
                Button("OK", role: .cancel) { }
            }
            
            // Navigation to result view (placeholder)
            NavigationLink(
                destination: AssessmentResultView(childId: child.id,showSaveButton: true)
                    .environmentObject(navManager),
                isActive: $navigateToResults
            ) {
                EmptyView()
            }
            .hidden()
            
        }
        .toolbar(.hidden,for: .navigationBar)
    }
    
    // MARK: - Helper
    func isCurrentCategoryComplete() -> Bool {
        let currentGroup = viewModel.question[currentCategoryIndex]
        for question in currentGroup.questions {
            if question.selectedOption == nil {
                return false
            }
        }
        return true
    }
}


#Preview {
    AssessmentView(child: ChildDetails(fullName: "Sudhanshu", dateOfBirth: Date.now, gender: "male"))
}
