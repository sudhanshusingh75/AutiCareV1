//
//  SearchView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/02/25.
//

import SwiftUI
import FirebaseAuth

struct SearchView: View {
    @State private var inputText:String = ""
    @StateObject var viewModel = SearchViewModel()
        @Environment(\.dismiss) var dismiss
        let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
        var filteredUsers : [User]{
        return viewModel.user.filter { user in
            user.id != currentUserId && (user.fullName.localizedCaseInsensitiveContains(inputText)||user.userName.localizedCaseInsensitiveContains(inputText))
        }
    }
    var body: some View {
        NavigationStack{
            List(filteredUsers){user in
                NavigationLink(destination: OtherUserProfileView(userId: user.id)){
                    HStack{
                        if let url = URL(string: user.profileImageURL ?? ""){
                            AsyncImage(url: url) { image in
                                image.resizable()
                            }placeholder: {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundStyle(Color.gray)
                            }
                            .frame(width: 45,height: 45)
                            .clipShape(Circle())
                        }
                        else{
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundStyle(Color.gray)
                                .frame(width: 45,height: 45)
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(user.fullName).font(.headline)
                            Text(user.userName).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
            }
            .task{
                await viewModel.fetchAllUsers()
            }
            .searchable(text: $inputText, placement: .toolbar, prompt: "Search")
        }
    }
}
#Preview {
    SearchView()
}
