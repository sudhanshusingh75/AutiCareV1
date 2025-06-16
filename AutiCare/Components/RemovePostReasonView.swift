//
//  RemovePostResonView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/06/25.
//

import SwiftUI

struct RemovePostReasonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedReason: String? = nil
    @State private var customReason: String = ""
    
    let onSubmit: (String) -> Void

    let predefinedReasons = [
        "Not relevant to me",
        "I’ve seen this post before",
        "I don’t like this content",
        "Offensive or inappropriate content",
        "Too many posts from this user",
        "This is spam",
        "I want to see fewer posts like this"
    ]

    var finalReason: String {
        selectedReason == "Other" ? customReason : (selectedReason ?? "")
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Why do you want to remove this post?")
                    .font(.headline)
                    .padding(.bottom, 5)

                // Predefined options
                ForEach(predefinedReasons + ["Other"], id: \.self) { reason in
                    HStack {
                        Image(systemName: selectedReason == reason ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(.blue)
                        Text(reason)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        selectedReason = reason
                    }
                }

                // Custom reason field
                if selectedReason == "Other" {
                    TextEditor(text: $customReason)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .padding(.top, 8)
                }

                Spacer()

                // Submit Button
                Button(action: {
                    onSubmit(finalReason)
                    dismiss()
                }) {
                    Text("Remove Post")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(finalReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(finalReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.top)
            }
            .padding()
            .navigationTitle("Remove Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
