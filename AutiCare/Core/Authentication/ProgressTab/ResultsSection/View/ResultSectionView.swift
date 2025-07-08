import SwiftUI

struct ResultSectionView: View {
    @StateObject private var viewModel = ResultViewModel()
    @EnvironmentObject var navManager: NavigationManager
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.results.isEmpty {
                    Text("No results to show. Try completing assessment to view progress.")
                        .padding()
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.results) { result in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(result.name)
                                    .font(.headline)
                                Text("Score: \(result.score)")
                                    .font(.subheadline)
                                Text("Taken on \(formattedDate(result.dateTaken))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            NavigationLink {
                                AssessmentResultView(childId: result.childId,showSaveButton:false)
                                    .environmentObject(navManager)
                            } label: {
                                Text("View Details")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .foregroundStyle(.white)
                                    .background(Color(red: 0, green: 0.387, blue: 0.5))
                                    .cornerRadius(20)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Assessment Results")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetchResults()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ResultSectionView()
}
