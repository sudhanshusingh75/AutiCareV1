import SwiftUI
import SDWebImageSwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedFilters: Set<String> = []

    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]

    var body: some View {
        VStack {
            ExploreFilter(selectedFilters: $selectedFilters) // ✅ Multi-selection support
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 2) {
                    ForEach(viewModel.explorePosts, id: \.id) { post in
                        if let firstImageUrl = post.imageURL.first,
                           let url = URL(string: firstImageUrl) {
                            NavigationLink(destination: FeedView(selectedPostId: post.id)) {
                                WebImage(url: url)
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFill()
                                    .frame(width: 132, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if selectedFilters.isEmpty {
                viewModel.fetchAllPosts() // ✅ Fetch all posts when no filter is selected
            } else {
                viewModel.fetchExplorePosts(tags: Array(selectedFilters))
            }
        }
        .onChange(of: selectedFilters) { _, newTags in
            if newTags.isEmpty {
                viewModel.fetchAllPosts() // ✅ Fetch all posts when no filter is selected
            } else {
                viewModel.fetchExplorePosts(tags: Array(newTags))
            }
        }
    }
}

