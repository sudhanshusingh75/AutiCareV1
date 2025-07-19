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

    let themeColor = Color(red: 0, green: 0.387, blue: 0.5)

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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Why do you want to remove this post?")
                        .font(.title2.bold())
                        .padding(.bottom, 10)

                    VStack(spacing: 12) {
                        ForEach(predefinedReasons + ["Other"], id: \.self) { reason in
                            HStack(alignment: .top) {
                                Image(systemName: selectedReason == reason ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(themeColor)
                                    .font(.system(size: 20))
                                    .padding(.top, 2)

                                Text(reason)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedReason = reason
                            }
                        }
                    }

                    if selectedReason == "Other" {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your reason")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextEditor(text: $customReason)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }

                    Button(action: {
                        onSubmit(finalReason)
                        dismiss()
                    }) {
                        Text("Remove Post")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(finalReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : .red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(finalReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Remove Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                  }
                }
            }
        }
    }

