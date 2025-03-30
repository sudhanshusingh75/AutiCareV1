//
//  LearningPageView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//
import SwiftUI
import AVKit
import Firebase
import FirebaseAuth

struct LearningPageView: View {
    @State private var hasTakenAssessment = false
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ISAA Assessment")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Take the ISAA assessment to get a certified evaluation for autism. This will help in understanding and improving developmental needs.")
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        if isLoading {
                            ProgressView() // Show loading indicator
                                .padding()
                        } else {
                            NavigationLink(destination: QuestionView()) {
                                Text(hasTakenAssessment ? "Retake Assessment" : "Take Assessment")
                                    .font(.headline)
                                    .foregroundColor(.mint)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color.mint)
                    .cornerRadius(20)
                    .padding(.horizontal)

                    GameSectionView(title: "Cognitive Games",
                                    description: "These games help enhance problem-solving skills, attention span, and logical thinking in an interactive way.",
                                    games: cognitiveGames)

                    VideosSection(title: "Sessions", description: "Engaging Video content to aid learning and development, Covering various essential skills")

                    WorksheetSectionView(title: "Worksheets",
                                         description: "Fun and interactive worksheets to help kids learn through activities.",
                                         worksheets: worksheets)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Learning")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                checkAssessmentStatus()
            }
        }
    }
    
    /// Fetch assessment status from Firestore
    private func checkAssessmentStatus() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("Users").document(userId)
            .collection("assessmentResults")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching assessment results: \(error.localizedDescription)")
                } else {
                    // If there is any document in assessmentResult, user has taken the test
                    hasTakenAssessment = !(snapshot?.documents.isEmpty ?? true)
                }
                isLoading = false
            }
    }
}

let cognitiveGames = [
    Game(title: "Memory Card", imageName: "memorycard", destination: AnyView(MemoryCardGameView())),
    Game(title: "who's Flying", imageName: "who'sFlying", destination: AnyView(PictureRepresentingActionGameView())),
    Game(title: "Maze", imageName: "MazeGame", destination: AnyView(MazeGameView())),
    Game(title: "Match the Shape", imageName: "matchTheColor", destination: AnyView(ColorMatchingGame())),
    Game(title: "ISpy Game", imageName: "Ispy", destination: AnyView(ISpyGameView())),
    
]

//let learningVideos = [
//    Videos(name: "In School", url: "GoingToSchool"),
//    Videos(name: "While Playing", url: "whilePlaying"),
//    Videos(name: "When I Feel sad", url: "feelingSad"),
//    Videos(name: "Class Manners", url: "behavingInClass"),
//    Videos(name: "Playing With Friends", url: "playingWithFriends"),
//    Videos(name: "While Playing", url: "whilePlaying"),
//    Videos(name: "House Ettiquetes", url: "howToBehaveWithGuests")
//]


let worksheets = [
    Worksheet(title: "Learn Vegetables", imageName: "vegetableQuiz", destination: AnyView(VegetableQuizView())),
    Worksheet(title: "Learn calculations", imageName: "FruitsQuiz", destination: AnyView(MathQuizView())),
    Worksheet(title: "Learn Alphabets", imageName: "alphabetQuiz", destination: AnyView(EnglishWordWorksheetView())),
    Worksheet(title: "Learn Fruits", imageName: "fruitMatchingQuiz", destination: AnyView(FruitsQuizView())),
    Worksheet(title: "Learn Geometrical Shape", imageName: "shapeQuiz", destination: AnyView(geometricalShapeView()))
]

struct Game: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let destination: AnyView
}

//struct LearningVideo: Identifiable {
//    let id = UUID()
//    let title: String
//    let fileName: String
//}

struct Worksheet: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let destination: AnyView
}



struct GameSectionView: View {
    let title: String
    let description: String
    let games: [Game]
    
    @State private var showDescription = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button(action: {
                    showDescription.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                }
                .alert(title, isPresented: $showDescription) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(description)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.mint)
            .cornerRadius(15)
            .padding(.horizontal)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(games) { game in
                        NavigationLink(destination: game.destination) {
                            GameCardView(game: game)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct WorksheetSectionView: View {
    let title: String
    let description: String
    let worksheets: [Worksheet]
    
    @State private var showDescription = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button(action: {
                    showDescription.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                }
                .alert(title, isPresented: $showDescription) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(description)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.mint)
            .cornerRadius(15)
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(worksheets) { worksheet in
                        NavigationLink(destination: worksheet.destination) {
                            VStack {
                                Image(worksheet.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                
                                Text(worksheet.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.top, 5)
                            }
                            .frame(width: 160, height: 180)
                            .background(Color.white)
                            .cornerRadius(15)
                           
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}


struct GameCardView: View {
    let game: Game
    
    var body: some View {
        NavigationLink(destination: game.destination) {
                    VStack {
                        Image(game.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                        
                        Text(game.title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.top, 5)
                    }
                    .frame(width: 160, height: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                }
            }
}



// Wrapper to force landscape mode
struct VideoPlayerController: UIViewControllerRepresentable {
    let fileName: String
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        // Load the video from the bundle
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") {
            let player = AVPlayer(url: url)
            controller.player = player
            controller.showsPlaybackControls = true
            
            // Start playing the video automatically
            player.play()
        } else {
            print("Video not found: \(fileName)")
        }
        
        // Force landscape orientation
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No updates needed
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        // Reset orientation to portrait when the view is dismissed
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
}
#Preview {
    LearningPageView()
}

