//
//  FireBaseAuthTutorailApp.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Supabase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // Check if it's the first launch after installation
        if UserDefaults.standard.bool(forKey: "isFirstLaunch") == false {
            // Sign out the user if it is the first launch after installation
            do {
                try Auth.auth().signOut()
            }
            catch{
                print("Error : \(error.localizedDescription)")
            }
        }
        // Set first launch flag
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")

        return true
    }
}
@main
struct AutiCare: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
                .task {
                    await viewModel.refreshAuthState()
            }
        }
    }
}


