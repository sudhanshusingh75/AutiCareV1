//
//  SearchBar.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/02/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var inputText:String
    var body: some View {
        TextField("", text:$inputText,prompt: Text("Search Users").foregroundStyle(Color.gray))
            .padding()
            .frame(width:340,height: 35)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .textInputAutocapitalization(.never)
        
    }
}

#Preview {
    SearchBar(inputText: .constant(""))
}
