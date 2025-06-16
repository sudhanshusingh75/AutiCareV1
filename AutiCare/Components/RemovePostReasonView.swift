//
//  RemovePostResonView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/06/25.
//

import SwiftUI

struct RemovePostReasonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var reason: String = ""
    let onSubmit: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Why do you want to remove this post?")
                    .font(.headline)
                    .padding()

                TextEditor(text: $reason)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))

                Spacer()

                Button(action: {
                    if !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        onSubmit(reason)
                        dismiss()
                    }
                }) {
                    Text("Remove Post")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding()
            }
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

