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
    
    var totalScore: Int {
        answers.flatMap { $0 }.reduce(0, +)
    }
    
    var level: String {
        switch totalScore {
        case ..<70: return "No Autism"
        case 70..<107: return "Mild Autism"
        case 107..<154: return "Moderate Autism"
        default: return "Severe Autism"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Assessment Result")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("Total Score: \(totalScore)")
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding()
                
                Text("Autism Level: \(level)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.mint)
                    .padding()
                
                PieChartView(data: answers.flatMap { $0 })
                    .frame(height: 300)
                    .padding()
                
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

                Button("Save Your Result") {
                    saveResultToFirestore()
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: 200, height: 50)
                .background(Color.green)
                .cornerRadius(10)
            }
        }
        .onAppear {
            saveResultToFirestore()
        }
    }
    
    func saveResultToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let resultData: [String: Any] = [
            "totalScore": totalScore,
            "autismLevel": level,
            "scoreBreakdown": answers.flatMap { $0 },
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
}

struct PieChartView: View {
    let data: [Int]
    
    var body: some View {
        Chart {
            ForEach(1...5, id: \.self) { value in
                if let count = data.filter({ $0 == value }).count as Int? {
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

struct ColorIndicator: View {
    let color: Color
    let text: String

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(answers: [
            [1, 2, 3, 4, 5],
            [1, 1, 2, 2, 3],
            [4, 4, 5, 5, 5]
        ])
    }
}
