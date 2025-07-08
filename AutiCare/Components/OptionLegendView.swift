//
//  OptionLegendView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 30/06/25.
//

import SwiftUI

struct OptionLegendView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Answer Key:")
                .font(.headline)
                .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))

            HStack(spacing: 12) {
                ForEach(QuestionOption.allCases, id: \.self) { option in
                    VStack {
                        Text(option.buttonLabel)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(option.color)
                            .clipShape(Circle())

                        Text(option.rawValue)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .frame(width: 65)
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
        .cornerRadius(16)
    }
}
#Preview {
    OptionLegendView()
}
