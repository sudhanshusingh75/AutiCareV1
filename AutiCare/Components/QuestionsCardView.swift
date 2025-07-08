//
//  QuestionsCardView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 30/06/25.
//

import SwiftUI

struct QuestionsCardView: View {
    @Binding var selectedOption:QuestionOption?
    let question:String
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            HStack(spacing:20){
                ForEach(QuestionOption.allCases,id: \.self){option in
                    Button {
                        selectedOption = option
                    } label: {
                        Text(option.buttonLabel)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(selectedOption == option ? option.color: Color.gray.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
            }
            if let selectedOption = selectedOption {
                Text(selectedOption.rawValue)
                    .font(.headline)
                    .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))
            } else {
                Text("Please select an option")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background((Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1)))
        .cornerRadius(16)
        .padding()
        
    }
}

#Preview {
    QuestionsCardView(selectedOption: .constant(.always), question: "Is Your Child Overly Sensitive to sound, touch, light, or other senses?")
}
