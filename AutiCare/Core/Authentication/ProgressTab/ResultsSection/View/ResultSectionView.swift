//
//  ResultSectionView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResultSectionView: View {
    @State private var results: [AssessmentResult] = [
        AssessmentResult(
            id: UUID(),
            name: "Riya Sharma",
            score: 82,
            dateTaken: Date(),
            imageURL: nil,
            categoryScores: [
                CategoryPerformance(name: "Social Relationship & Responsiveness", score: 85, trend: 0.04, weeklyData: [60, 70, 75, 80]),
                CategoryPerformance(name: "Emotional Responsiveness", score: 78, trend: -0.03, weeklyData: [70, 72, 68, 65]),
                CategoryPerformance(name: "Speech & Communication", score: 82, trend: 0.02, weeklyData: [60, 70, 80, 85]),
                CategoryPerformance(name: "Behavior Patterns", score: 76, trend: 0.01, weeklyData: [50, 60, 70, 75]),
                CategoryPerformance(name: "Sensory Aspects", score: 79, trend: -0.02, weeklyData: [60, 62, 61, 58]),
                CategoryPerformance(name: "Cognitive Components", score: 83, trend: 0.03, weeklyData: [70, 75, 80, 85])
            ]
        )
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(results){ result in
                    HStack{
                        VStack(alignment: .leading){
                            Text(result.name)
                                .font(.headline)
                            Text("Score: \(result.score)")
                                .font(.subheadline)
                            Text("Taken on \(formattedDate(result.dateTaken))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        NavigationLink {
                            
                        } label: {
                            Text("View Details")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundStyle(.white)
                                .background(Color(red: 0, green: 0.387, blue: 0.5))
                                .cornerRadius(20)
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 60)
                    .padding()
                    .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                    .cornerRadius(20)
                    
                }
                
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ResultSectionView()
}
