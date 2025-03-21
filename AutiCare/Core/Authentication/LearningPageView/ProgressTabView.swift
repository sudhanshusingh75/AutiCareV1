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
    @State private var selectedAssessment: AssessmentResult? = nil // For showing ISAA Assessment Manual

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // ✅ LINE GRAPH: Total Autism Score Over Time
                    if !progressViewModel.allResults.isEmpty {
                        TotalScoreChartView(results: progressViewModel.allResults)
                            .padding(50)
                    }

                    // ✅ CHART VIEW FOR EACH ASSESSMENT
                    if !progressViewModel.allResults.isEmpty {
                        AssessmentResultsView(
                            results: progressViewModel.allResults,
                            categories: progressViewModel.categories,
                            selectedAssessment: $selectedAssessment
                        )
                        .padding(30)
                    } else {
                        NoResultsView()
                    }
                }
            }
            .navigationTitle("Progress")
            .onAppear {
                progressViewModel.fetchAssessmentResults()
            }
            .sheet(item: $selectedAssessment) { assessment in
                ISAAInfoView()
            }
        }
    }
}
// ✅ Total Score Chart View
struct TotalScoreChartView: View {
    let results: [AssessmentResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Total Autism Score Over Time")
                .font(.headline)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .center)

            Chart {
                ForEach(results, id: \.id) { result in
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
            .frame(height: 250)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 3)
            )
            .padding(.horizontal, 20)
        }
    }

    // Helper function to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// ✅ Assessment Results View
struct AssessmentResultsView: View {
    let results: [AssessmentResult]
    let categories: [String]
    @Binding var selectedAssessment: AssessmentResult?

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ForEach(results, id: \.id) { result in
                AssessmentResultCard(
                    result: result,
                    categories: categories,
                    selectedAssessment: $selectedAssessment
                )
            }
        }
    }
}

// ✅ Assessment Result Card
struct AssessmentResultCard: View {
    let result: AssessmentResult
    let categories: [String]
    @Binding var selectedAssessment: AssessmentResult?

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 🕒 Date & Time with More Info Icon
            HStack {
                Text(formattedDateTime(result.date))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                // ℹ️ More Info Icon (ISAA Assessment Manual)
                Button(action: {
                    selectedAssessment = result
                }) {
                    Text("More info")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 40)

            // 📊 Total Autism Score & Autism Level
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Score: \(result.totalScore)")
                    .font(.headline)
                Text("Autism Level: \(result.autismLevel)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)

            // 📊 Stacked Bar Chart
            StackedBarChartView(
                categoryDistributions: result.severityLevels,
                categories: categories
            )
            .frame(height: 250)
            .padding(.horizontal, 20)
            .padding(.bottom, 70)

            // 🎨 Color Indicator
            ColorIndicatorView()
                .padding(.horizontal, 20)

            // ➕ "See More..." Button (Category Conclusion)
            NavigationLink {
                CategoryConclusionPage(
                    assessment: result, // Pass the assessment result
                    result: result, // Pass the result again (if needed)
                    categories: categories, // Pass the categories
                    selectedAssessment: $selectedAssessment // Pass the binding for selectedAssessment
                )
            } label: {
                Text("See More...")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom, 20)

            Divider()
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 3)
        )
        .padding(.horizontal, 20)
    }

    // Helper function to format date and time
    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

// ✅ No Results View
struct NoResultsView: View {
    var body: some View {
        Text("No assessment results found. Complete an assessment to track your progress.")
            .foregroundColor(.gray)
            .italic()
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// ✅ Category Conclusion Page
struct CategoryConclusionPage: View {
    let assessment: AssessmentResult
    let result: AssessmentResult
    let categories: [String]
    @Binding var selectedAssessment: AssessmentResult?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                HStack {
                    Text(formattedDateTime(result.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    // ℹ️ More Info Icon (ISAA Assessment Manual)
                    Button(action: {
                        selectedAssessment = result
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal, 40)

                // 📊 Total Autism Score & Autism Level
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Score: \(result.totalScore)")
                        .font(.headline)
                    Text("Autism Level: \(result.autismLevel)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

                // 📊 Stacked Bar Chart
                StackedBarChartView(
                    categoryDistributions: result.severityLevels,
                    categories: categories
                )
                .frame(height: 250)
                .padding(.horizontal, 20)
                .padding(.bottom, 70)

                // 🎨 Color Indicator
                ColorIndicatorView()
                    .padding(.horizontal, 20)
                
                
                Text("Autism Level in Each Category")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                ForEach(assessment.categoryConclusions, id: \.self) { conclusion in
                    if let category = conclusion["category"],
                       let conclusionText = conclusion["conclusion"] {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(category)
                                .font(.headline)
                            Text(conclusionText)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .padding(.horizontal, 20)
                        
                    }
                }
                
                
            }
            .padding(.bottom, 20)
        }
        
    }
    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

struct ISAAInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("ISAA Assessment")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                // Introduction
                VStack(alignment: .leading, spacing: 10) {
                    Text("Introduction")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)

                    Text("The Indian Scale for Identification of Autism (ISAA) is a standardized tool with good psychometric properties. It is a reliable and valid tool for diagnosing Autism.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)

                Divider()
                    .padding(.vertical, 10)

                // Norms and Scores
                VStack(alignment: .leading, spacing: 10) {
                    Text("Norms and Scores")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)

                    Text("To arrive at the taxonomy of ISAA, the scores of 376 children who scored 70 and above from the autism group were analyzed. The mean score was found to be 106.09, with a range of 70.0 to 181.0.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)

                    // Table for Norms
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Norms of ISAA for Diagnosis of Autism")
                            .font(.headline)
                            .padding(.bottom, 5)

                        HStack {
                            Text("ISAA Scores")
                                .font(.subheadline)
                                .bold()
                                .frame(width: 120, alignment: .leading)
                            Text("Degree of Autism")
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 5)

                        Divider()

                        ForEach(normsData, id: \.scoreRange) { norm in
                            HStack {
                                Text(norm.scoreRange)
                                    .font(.subheadline)
                                    .frame(width: 120, alignment: .leading)
                                Text(norm.degreeOfAutism)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
                .padding(.horizontal, 20)

                Divider()
                    .padding(.vertical, 10)

                // Statistical Data
                VStack(alignment: .leading, spacing: 10) {
                    Text("Statistical Data")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)

                    Text("The following table summarizes the statistical data for ISAA scores:")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)

                    // Table for Statistical Data
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Metric")
                                .font(.subheadline)
                                .bold()
                                .frame(width: 100, alignment: .leading)
                            Text("Value")
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 5)

                        Divider()

                        ForEach(statisticalData, id: \.metric) { data in
                            HStack {
                                Text(data.metric)
                                    .font(.subheadline)
                                    .frame(width: 100, alignment: .leading)
                                Text(data.value)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
                .padding(.horizontal, 20)

                Divider()
                    .padding(.vertical, 10)

                // Conclusion
                VStack(alignment: .leading, spacing: 10) {
                    Text("Conclusion")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)

                    Text("Indian Scale for Identification of Autism (ISAA) is a standardized tool with good psychometric properties. It is a reliable and valid tool for making a diagnosis of persons with Autism.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)

                // Download Button
                Button(action: {
                    sharePDF()
                }) {
                    Text("Download ISAA Manual")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("ISAA Manual")
    }

    // Share PDF Function
    private func sharePDF() {
        guard let url = Bundle.main.url(forResource: "ISAA_Assessment_Test_Manual", withExtension: "pdf") else {
            print("PDF file not found in the app bundle.")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // Find the topmost view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            var topViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }

            // Present the share sheet
            topViewController.present(activityViewController, animated: true, completion: nil)
        }
    }

    // Data for Norms Table
    private let normsData = [
        Norm(scoreRange: "< 70", degreeOfAutism: "Normal"),
        Norm(scoreRange: "70 to 106", degreeOfAutism: "Mild Autism"),
        Norm(scoreRange: "107 to 153", degreeOfAutism: "Moderate Autism"),
        Norm(scoreRange: "> 153", degreeOfAutism: "Severe Autism")
    ]

    // Data for Statistical Table
    private let statisticalData = [
        Statistic(metric: "N", value: "376"),
        Statistic(metric: "Minimum", value: "70.0"),
        Statistic(metric: "Maximum", value: "181.0"),
        Statistic(metric: "Mean", value: "106.09"),
        Statistic(metric: "S.D", value: "23.5")
    ]
}

// Data Models
struct Norm: Identifiable {
    let id = UUID()
    let scoreRange: String
    let degreeOfAutism: String
}

struct Statistic: Identifiable {
    let id = UUID()
    let metric: String
    let value: String
}
