//
//  ProfileView1.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 18/02/25.
//

import SwiftUI

struct ProfileView1: View {
    var body: some View {
        VStack{
            HStack(spacing: 25){
                Image("profilePic")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100,height: 100)
                    .clipShape(Circle())
                    .padding(.all,5)
                    .overlay {
                        Circle().stroke(Color.black,lineWidth: 1)
                    }
                VStack(alignment: .leading,spacing: 15){
                    Text("Sudhanshu Singh")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack(spacing:25){
                        VStack(alignment:.leading){
                            Text("20")
                            Text("Posts")
                                .foregroundStyle(Color(.placeholderText))
                        }
                        VStack(alignment:.leading){
                            Text("20")
                            Text("Followers")
                        }
                        VStack(alignment:.leading){
                            Text("20")
                            Text("Followings")
                        }
                    }
                }
                
            }
        }
        VStack(alignment: .leading) {
            HStack{
//                Text("LNdlkadlkamdlkamsdlkmadkadmlkamdlkamdlkamdlkam")
                Spacer()
            }
            HStack{
                Button {
                    
                } label: {
                    Text("Follow")
                        .padding()
                        .frame(width: 100,height: 40)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button {
                    
                } label: {
                    Text("Message")
                        .padding()
                        .frame(width: 120,height: 40)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    ProfileView1()
}
