//
//  GameCategoryListView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI

struct GameCategoryListView: View {
    @StateObject private var viewModel = GameCategoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading,spacing:10){
                Text("Games")
                    .font(.largeTitle.bold())
                    .padding()
//                    .frame(maxWidth: .infinity,alignment: .leading)
//                    .foregroundStyle(.white)
//                    .background(Color(red: 0, green: 0.387, blue: 0.5))
//                    .cornerRadius(20)
//                    .padding(.horizontal)
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
