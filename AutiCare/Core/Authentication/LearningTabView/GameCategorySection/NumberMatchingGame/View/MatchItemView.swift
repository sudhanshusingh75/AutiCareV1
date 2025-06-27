//
//  MatchItemView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 27/06/25.
//

import SwiftUI

struct MatchItemView: View {
    let item: NumberMatchItem
    var body: some View {
        VStack {
            ForEach(0..<item.number, id: \.self) { _ in
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
        .padding()
        .frame(width: 100, height: 100)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(16)
        .shadow(radius: 3)
    }
}

