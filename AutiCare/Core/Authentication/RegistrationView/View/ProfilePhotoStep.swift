//
//  ProfilePhotoStep.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI
import PhotosUI

struct ProfilePhotoStep: View {
    @ObservedObject var viewModel: RegistrationFlowViewModel
    @Binding var nextStep: ProfileCompletionStep
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        
        NavigationStack {
            VStack(spacing: 22) {
                Text("Choose a Profile Photo")
                    .font(.title.bold())
                    .multilineTextAlignment(.leading)
                
                PhotosPicker(selection: $selectedItem,matching: .images,photoLibrary: .shared()) {
                    if let selectedUIImage = viewModel.selectedImage {
                        Image(uiImage: selectedUIImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 4)
                            }
                            .shadow(radius: 2)
                    }else{
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .padding(.all,40)
                            .frame(width: 200, height: 200,alignment: .center)
                            .foregroundStyle(Color.white)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                    }
                    
                }
                .onChange(of: selectedItem) { _, newValue in
                    Task {
                        guard let selectedItem = newValue else { return }
                        if let data = try? await selectedItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            viewModel.selectedImage = uiImage
                        }
                    }
                }
                Button {
                    nextStep = .review
                } label: {
                    Text("Next")
                        .padding()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .background(Color(red:0,green: 0.387,blue: 0.5))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ProfilePhotoStep(viewModel: RegistrationFlowViewModel(), nextStep: .constant(.review))
}
