//
//  ResultView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Charts

struct ResultView: View {
    let answers: [[Int]]
    let categories = ["Social Interaction", "Emotional Responsiveness", "Speech & Communication", "Behavior Patterns", "Sensory Aspects", "Cognitive Components"]
    let questionCounts = [9, 5, 9, 7, 6, 4]

    var categoryDistributions: [[Double]] {
        answers.map { categoryAnswers in
            let totalQuestions = Double(categoryAnswers.count)
            var distribution = [0.0, 0.0, 0.0, 0.0, 0.0]
            for answer in categoryAnswers {
                distribution[answer - 1] += 1
            }
            return distribution.map { ($0 / totalQuestions) * 100 }
        }
    }

    var totalAutismScore: Int {
        answers.flatMap { $0 }.reduce(0, +)
    }

    var autismLevel: String {
        switch totalAutismScore {
        case ..<70: return "No Autism"
        case 70..<107: return "Mild Autism"
        case 107..<154: return "Moderate Autism"
        default: return "Severe Autism"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("Assessment Result")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("Total Score: \(totalAutismScore)")
                    .font(.title2)
                    .foregroundColor(.green)
                    .bold()
                    .padding()

                Text("Autism Level: \(autismLevel)")
                    .font(.title3)
                    .foregroundColor(.mint)
                    .bold()
                    .padding(.bottom)

                StackedBarChartView(categoryDistributions: categoryDistributions, categories: categories)
                    .frame(height: 400)
                    .padding()

                ColorIndicatorView()
                    .padding()

                ForEach(0..<categories.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text("\(categories[index])")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top, 5)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text(conclusion(for: categoryDistributions[index]))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                }

                Button("Save Your Result") {
                    saveResultToFirestore()
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: 200, height: 50)
                .background(Color.green)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }.navigationBarBackButtonHidden(true)
    }

    func saveResultToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        
        
        let formattedCategoryDistributions: [[String: Any]] = categoryDistributions.enumerated().map { index, distribution in
            return [
                "category": categories[index],
                "distribution": distribution
            ]
        }
        
        let resultData: [String: Any] = [
            "categoryDistributions": formattedCategoryDistributions,
            "totalAutismScore": totalAutismScore,
            "autismLevel": autismLevel,
            "date": Timestamp()
        ]

        db.collection("Users").document(userId).collection("assessmentResults").addDocument(data: resultData) { error in
            if let error = error {
                print("❌ Error saving result: \(error.localizedDescription)")
            } else {
                print("✅ Assessment result saved successfully!")
            }
        }
    }

    func conclusion(for distribution: [Double]) -> String {
        let highestSeverity = distribution.last ?? 0
        if highestSeverity >= 50 {
            return "Severe Autism detected in this category."
        } else if highestSeverity >= 30 {
            return "Moderate Autism detected in this category."
        } else {
            return "No significant autism traits detected in this category."
        }
    }
}

struct StackedBarChartView: View {
    let categoryDistributions: [[Double]]
    let categories: [String]
    let severityColors: [Color] = [.green, .blue, .yellow, .orange, .red]

    var body: some View {
        VStack {
            // Chart Title
            Text("Severity Levels by Category")
                .font(.headline)
                .padding(.bottom, 10)

            
            Chart {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    let distribution = categoryDistributions[index]
                    
                    ForEach(Array(distribution.enumerated()), id: \.offset) { severityIndex, value in
                        BarMark(
                            x: .value("Category", index), // Use index for positioning
                            y: .value("Severity", value),
                            width: .fixed(30) // ✅ Increased width of bars
                        )
                        .foregroundStyle(severityColors[severityIndex])
                        .cornerRadius(5)
                        .opacity(0.9)
                        .annotation(position: .top) {
                            if severityIndex == severityColors.count - 1, value > 0 { // ✅ Show only red color (Severe) percentage
                                Text("\(Int(value))%")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(severityColors[severityIndex].opacity(0.7))
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .leading) // Add Y-axis marks for better readability
            }
            .chartLegend(position: .bottom, alignment: .center) // Add a legend for severity levels
            .frame(height: 300) // Adjust height for better visibility

            // Custom X-Axis Labels
            HStack(alignment: .center, spacing: 6) { // ✅ Reduced space between bars
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    Text(category)
                        .font(.caption)
                        .frame(width: 50, alignment: .center)
                        .multilineTextAlignment(.center)
                        .lineLimit(2) // Allow text to wrap if needed
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct ColorIndicatorView: View {
    let severityLevels = ["No Autism", "Mild", "Moderate", "High", "Severe"]
    let colors: [Color] = [.green, .blue, .yellow, .orange, .red]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<severityLevels.count, id: \.self) { index in
                HStack {
                    Circle()
                        .fill(colors[index])
                        .frame(width: 15, height: 15)
                    Text(severityLevels[index])
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ResultViewPreview: View {
    var sampleAnswers: [[Int]] = [
        [1, 2, 3, 4, 5, 3, 2, 1, 4], // Social
        [3, 4, 5, 3, 2],             // Emotional
        [1, 1, 2, 3, 5, 4, 4, 2, 3], // Speech
        [4, 5, 3, 3, 2, 2, 1],       // Behavior
        [2, 3, 3, 4, 5, 1],          // Sensory
        [1, 2, 4, 5]                 // Cognitive
    ]

    var body: some View {
        ResultView(answers: sampleAnswers)
    }
}

struct ResultViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        ResultViewPreview()
    }
}
