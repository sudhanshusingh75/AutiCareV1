//
//  AssessmentSectionView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import SwiftUI

struct AssessmentSectionView: View {
    var body: some View {
        VStack(spacing: 18){
            HStack{
                Text("ISAA ASSESSMENT")
                    .font(.title.bold())
                    .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "info.circle")
                        .scaledToFill()
                        .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                }
            }
            Text("The ISAA Assessment helps you understand your child’s social, emotional, and communication behaviors. It’s a simple tool to screen for early signs of autism and guide informed support.")
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            NavigationLink {
                Text("Hello World")
            } label: {
                Text("Take Assessment")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0, green: 0.387, blue: 0.5))
                    .cornerRadius(20)
            }
            
        }
        .frame(maxWidth:UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    AssessmentSectionView()
}
