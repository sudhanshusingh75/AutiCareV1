//
//  ProgressTabView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Charts

struct ProgressTabView: View {
    @StateObject var viewModel = ProgressViewModel()

    var body: some View {
        ScrollView {
            VStack {
                Text("Your Progress")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                if let latestResult = viewModel.latestResult {
                    Text("Recent Autism Score: \(latestResult.totalScore)")
                        .font(.title2)
                        .foregroundColor(.green)
                        .padding()

                    Text("Autism Level: \(latestResult.autismLevel)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.mint)
                        .padding()

                    PieChartView(data: latestResult.scoreBreakdown)
                        .frame(height: 300)
                        .padding()
                } else {
                    Text("No assessment results available")
                        .foregroundColor(.gray)
                        .padding()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Score Representation:")
                        .font(.headline)

                    HStack {
                        ColorIndicator(color: .green, text: "1 - Minimal Symptoms")
                        ColorIndicator(color: .blue, text: "2 - Mild Symptoms")
                    }
                    HStack {
                        ColorIndicator(color: .yellow, text: "3 - Moderate Symptoms")
                        ColorIndicator(color: .orange, text: "4 - Significant Symptoms")
                    }
                    HStack {
                        ColorIndicator(color: .red, text: "5 - Severe Symptoms")
                    }
                }
                .padding()

//                Button("Retake Test") {
//                    // Instead of full navigation reset, just navigate back
//                    if let window = UIApplication.shared.windows.first {
//                        window.rootViewController = UIHostingController(rootView: ProgressTabView())
//                        window.makeKeyAndVisible()
//                    }
//                }
//                .foregroundColor(.white)
//                .padding()
//                .frame(width: 200, height: 50)
//                .background(Color.mint)
//                .cornerRadius(10)

                // Show Line Graph only if there are at least 5 assessments
                if viewModel.allResults.count >= 5 {
                    LineGraphView(results: viewModel.allResults)
                        .padding()
                } else {
                    Text("Complete at least 5 assessments to view your progress graph.")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                }

                Text("Your progress over time is reflected here.")
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchAssessmentResults()
        }
    }
}
struct PieChart: View {
    let data: [Int]

    var body: some View {
        Chart {
            ForEach(1...5, id: \.self) { value in
                let count = data.filter { $0 == value }.count
                if count > 0 {
                    SectorMark(angle: .value("Score", count), innerRadius: .ratio(0.5))
                        .foregroundStyle(valueColor(value))
                }
            }
        }
    }

    func valueColor(_ value: Int) -> Color {
        switch value {
        case 1: return .green
        case 2: return .blue
        case 3: return .yellow
        case 4: return .orange
        default: return .red
        }
    }
}

#Preview {
    ProgressTabView()
}
