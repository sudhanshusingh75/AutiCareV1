//
//  AssessmentSectionView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import SwiftUI

struct AssessmentSectionView: View {
    @EnvironmentObject var navManager: NavigationManager
    @State private var showPDF:Bool = false
    var body: some View {
        VStack(spacing: 18){
            HStack{
                Text("ISAA Assessment")
                    .font(.title.bold())
                    .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                Spacer()
                Button {
                    if let url = URL(string: "http://www.arppassociation.org/Downloads/ISAA_Tool.pdf"){
                        UIApplication.shared.open(url)
                    }
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
            
            NavigationLink(destination: ChildDetailsView()
                .environmentObject(navManager),
                           isActive:$navManager.assessmentInProgress) {
                
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
    AssessmentSectionView().environmentObject(NavigationManager())
}
