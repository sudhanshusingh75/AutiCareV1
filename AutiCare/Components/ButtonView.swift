//
//  ButtonView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI

struct ButtonView: View {
    let title:String
    let action:() -> Void
    var backgroundColor : Color = Color.init(red: 0, green: 0.387, blue: 0.5)
    var foregroundColor : Color = Color.white
    var cornerRadius : CGFloat = 10
    var frameWidth : CGFloat = UIScreen.main.bounds.width - 32
    var frameheight : CGFloat = 48
    var fontWeight : Font.Weight = .semibold
    
    var body: some View {
        VStack{
            Button {
                action()
            } label: {
                HStack {
                    Text(title)
                        .fontWeight(fontWeight)
                    Image(systemName: "arrow.right")
                }
                .frame(width: frameWidth,height: frameheight)
                        .background(backgroundColor)
                        .foregroundStyle(foregroundColor)
                        .cornerRadius(cornerRadius)
            }
        }
    }
}

#Preview {
    ButtonView(title: "SIGN IN", action:{print("Button Pressed")})
}
