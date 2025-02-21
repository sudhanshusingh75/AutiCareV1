//
//  UserStatView.swift
//  Instagram
//
//  Created by Sudhanshu Singh Rajput on 10/10/24.
//

import SwiftUI

struct UserStatView: View {
    let value:Int
    let title:String
    var body: some View {
        VStack{
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.footnote)
                
        }.frame(width:76)
            .foregroundStyle(Color.black)
    }
}

#Preview {
    UserStatView(value: 12, title: "Posts")
}
