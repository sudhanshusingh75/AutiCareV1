//
//  ProgressTabView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI
import Charts

struct ProgressTabView: View {
    @StateObject var progressViewModel = ProgressViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) { // ⬅ Increased spacing
                
                // 📌 HEADER
                Text("Progress Overview")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // ✅ LINE GRAPH: Total Autism Score Over Time
                if !progressViewModel.allResults.isEmpty {
                    VStack {
                        Text("Total Autism Score Over Time")
                            .font(.headline)
                            .padding(.bottom, 5)

                        Chart {
                            ForEach(progressViewModel.allResults, id: \.id) { result in
                                LineMark(
                                    x: .value("Date", result.date),
                                    y: .value("Score", result.totalScore)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(.blue)
                                .symbol {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 8, height: 8)
                                        .shadow(radius: 3)
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom) { value in
                                AxisValueLabel {
                                    if let date = value.as(Date.self) {
                                        Text(formattedDate(date))
                                    }
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) {
                                AxisValueLabel()
                                AxisGridLine()
                            }
                        }
                        .padding()
                        .frame(maxWidth: 350, minHeight: 300, alignment: .center) // ⬅ Limited width
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 3))
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // ⬅ Centering the graph
                    .padding(.horizontal)
                }

                // ✅ STACKED BAR CHART FOR EACH ASSESSMENT
                if !progressViewModel.allResults.isEmpty {
                    VStack(alignment: .leading, spacing: 25) { // ⬅ More spacing

                        ForEach(progressViewModel.allResults, id: \.id) { result in
                            VStack(alignment: .leading, spacing: 15) { // ⬅ Prevent overlap
                                // 🕒 Date & Time
                                Text(formattedDateTime(result.date))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)

                                // 📊 Stacked Bar Chart
                                StackedBarChartView(
                                    categoryDistributions: result.severityLevels,
                                    categories: progressViewModel.categories
                                )
                                .frame(maxWidth: .infinity, minHeight: 250) // ⬅ More height to avoid compression
                                .padding(.horizontal)

                                Divider().padding(.horizontal)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 3))
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("No assessment results found. Complete an assessment to track your progress.")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            progressViewModel.fetchAssessmentResults()
        }
    }

    // ✅ Format Date (Show "Mar 4")
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    // ✅ Format Full Date & Time (Show "Mar 4, 2025 at 2:42 PM")
    func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    ProgressTabView()
}
