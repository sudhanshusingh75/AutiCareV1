//
//  GameCategoryListView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI

struct GameCategoryListView: View {
    @StateObject private var viewModel = GameCategoryViewModel()
    @State private var showAlert = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading,spacing:10){
                HStack{
                    Text("Games")
                        .font(.largeTitle.bold())
                        
                    //                    .frame(maxWidth: .infinity,alignment: .leading)
                    //                    .foregroundStyle(.white)
                    //                    .background(Color(red: 0, green: 0.387, blue: 0.5))
                    //                    .cornerRadius(20)
                    //                    .padding(.horizontal)
                    Spacer(minLength: 8)
                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color(red:0,green:0.387,blue:0.5))
                    }
                    .alert(isPresented: $showAlert){
                        Alert(title: Text("About Games"),message: Text("These games are designed as general skill-building activities tailored for autistic children. They are not intended as a clinical or therapeutic intervention, nor do they claim to provide medical benefits."),dismissButton: .default(Text("Got it!")))
                    }

                }.padding()
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack{
                        ForEach(viewModel.categories) { category in
                            NavigationLink(destination: GameListView(category: category)) {
                                HStack(spacing:16){
                                        Image(systemName:category.imageUrl)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                        Text(category.name)
                                            .font(.headline)
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                    }
                                .frame(width: 150,height: 100)
                                .padding()
                                .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                                .cornerRadius(16)
                            }
                        }
                    }.padding(.horizontal)
                    
                }
            }
        }
    }
}

#Preview {
    GameCategoryListView()
}
