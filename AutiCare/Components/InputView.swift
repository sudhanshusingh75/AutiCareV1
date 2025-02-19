//
//  InputView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct InputView: View {
    @Binding var text : String
    let title:String
    let placeholder:String
    var isSecureField:Bool = false
    var errorMessage:String?
    var body: some View {
        VStack(alignment:.leading){
            VStack(alignment:.leading,spacing:12){
                Text(title)
                    .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                    .font(.footnote)
                    .fontWeight(.semibold)
                if isSecureField{
                    SecureField(placeholder,text: $text)
                        .font(.system(size:14))
                }
                else{
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                }
                Divider()
            }
            if let errorMessage = errorMessage,!errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email address", placeholder:"name@gmail.com")
}
