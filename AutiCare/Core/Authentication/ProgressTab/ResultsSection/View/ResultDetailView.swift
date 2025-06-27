//
//  ResultDetailView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import SwiftUI

struct ResultDetailView: View {
    let result: AssessmentResult
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Overall Performance")
                    .font(.title3.bold())
                
                HStack {
                    Text("Overall Score")
                    Spacer()
                    Text("\(result.score)%")
                }
                ProgressView(value: Double(result.score), total: 100)
                    .tint(Color.blue)
                Text(overallLabel(for: result.score))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Text("Category Performance")
                    .font(.title3.bold())
                
                ForEach(result.categoryScores) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.name)
                            .font(.headline)
                        
                        Text("\(category.score)%")
                            .font(.title)
                        
                        Text("Last 30 Days \(category.trend >= 0 ? "+" : "")\(Int(category.trend * 100))%")
                            .foregroundColor(category.trend >= 0 ? .green : .red)
                        
                        HStack(spacing: 16) {
                            ForEach(0..<category.weeklyData.count, id: \ .self) { index in
                                VStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 20, height: CGFloat(category.weeklyData[index]))
                                        .overlay(
                                            Rectangle()
                                                .frame(width: 20, height: 2)
                                                .foregroundColor(.black)
//                                                .offset(y: -CGFloat(category.weeklyData[index]))
                                        )
                                    Text("Week \(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("ISAA Results")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func overallLabel(for score: Int) -> String {
        switch score {
        case 0..<50: return "Needs Support"
        case 50..<75: return "Average"
        default: return "Good"
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
    let sampleResult = AssessmentResult(
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
    
    return ResultDetailView(result: sampleResult)
}

