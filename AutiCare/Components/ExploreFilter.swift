//
//  ExploreFilter.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 15/02/25.
//

import SwiftUI

struct ExploreFilter: View {
    let filters: [String] = ["Milestones", "Health", "Sports", "Education", "Creativity", "Motivation"]
    @Binding var selectedFilters: Set<String> // ✅ Allow multiple selections

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters, id: \.self) { filter in
                    Text(filter)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedFilters.contains(filter) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedFilters.contains(filter) ? .white : .black)
                        .cornerRadius(20)
                        .onTapGesture {
                            if selectedFilters.contains(filter) {
                                selectedFilters.remove(filter) // ✅ Deselect if already selected
                            } else {
                                selectedFilters.insert(filter) // ✅ Select if not selected
                            }
                        }
                        .animation(.easeInOut, value: selectedFilters)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ExploreFilter(selectedFilters: .constant(["Sports"]))
}

