//
//  LineGraphView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI
import Charts

struct LineGraphView: View {
    var results: [AssessmentResult]

    var body: some View {
        VStack {
            Text("Autism Score Progress")
                .font(.headline)
                .padding(.top)

            Chart {
                ForEach(results) { result in
                    if let date = result.date?.dateValue() {
                        LineMark(
                            x: .value("Date", date),
                            y: .value("Score", result.totalScore)
                        )
                        .foregroundStyle(.blue)
                        .symbol(Circle())
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.day().month().year())
                }
            }
            .frame(height: 250)
            .padding()
        }
    }
}

