//
//  LearningPageView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI
import AVKit

struct LearningPageView: View {
    
    var body: some View {
            NavigationView {
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
                            
                            NavigationLink(destination: QuestionView()) {
                                                            Text("Take Assessment")
                                                                .font(.headline)
                                                                .foregroundColor(.mint)
                                                                .padding()
                                                                .frame(maxWidth: .infinity)
                                                                .background(Color.white)
                                                                .cornerRadius(10)
                                                        }
                        }
                        .padding()
                        .background(Color.mint)
                        .cornerRadius(20)
                        .padding(.horizontal)
           

                    
                    GameSectionView(title: "Cognitive Games",
                                    description: "These games help enhance problem-solving skills, attention span, and logical thinking in an interactive way.",
                                    games: cognitiveGames)

                    
                    VideoSectionView(title: "Sessions",
                                     description: "Engaging video content to aid in learning and development, covering various essential skills.",
                                     videos: learningVideos)

                    
                    WorksheetSectionView(title: "Worksheets",
                                         description: "Fun and interactive worksheets to help kids learn through activities.",
                                         worksheets: worksheets)
                    }
                    .padding(.bottom, 20)
                    }
                    .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
                    .navigationTitle("Learning")
                    }
            }
}

let cognitiveGames = [
    Game(title: "Memory Card", imageName: "memorycard", destination: AnyView(MemoryCardGameView())),
    Game(title: "who's Flying", imageName: "who'sFlying", destination: AnyView(PictureRepresentingActionGameView())),
    Game(title: "Maze", imageName: "MazeGame", destination: AnyView(MazeGameView())),
    Game(title: "Match the Shape", imageName: "matchTheColor", destination: AnyView(ColorMatchingGameView())),
    Game(title: "ISpy Game", imageName: "Ispy", destination: AnyView(ISpyGameView())),
    
]

let learningVideos = [
    LearningVideo(title: "In School", fileName: "GoingToSchool"),
    LearningVideo(title: "While Playing", fileName: "whilePlaying"),
    LearningVideo(title: "When I Feel sad", fileName: "feelingSad"),
    LearningVideo(title: "Class Manners", fileName: "behavingInClass"),
    LearningVideo(title: "Playing With Friends", fileName: "playingWithFriends"),
    LearningVideo(title: "While Playing", fileName: "whilePlaying"),
    LearningVideo(title: "House Ettiquetes", fileName: "howToBehaveWithGuests")
]


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

struct LearningVideo: Identifiable {
    let id = UUID()
    let title: String
    let fileName: String
}

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
            .background(Color.purple)
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

struct VideoSectionView: View {
    let title: String
    let description: String
    let videos: [LearningVideo]
    
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
            .background(Color.purple)
            .cornerRadius(15)
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(videos) { video in
                        NavigationLink(destination: VideoPlayerView(fileName: video.fileName)) {
                            VStack {
                                Image(.videoPlayButton)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height:100)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                
                                Text(video.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.top, 5)
                            }
                            .frame(width: 150, height: 180)
                            .background(Color.yellow)
                            .cornerRadius(15)
                            .shadow(radius: 5)
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
            .background(Color.purple)
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
                            .frame(width: 160, height: 200)
                            .background(Color.yellow)
                            .cornerRadius(15)
                            .shadow(radius: 5)
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
                    .frame(width: 150, height: 180)
                    .background(Color.yellow.opacity(0.8))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
}

struct VideoPlayerView: View {
    let fileName: String
    
    var body: some View {
        VStack {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
                    .font(.headline)
            }
        }
        .navigationTitle("Video Player")
    }
}

#Preview {
    LearningPageView()
}

