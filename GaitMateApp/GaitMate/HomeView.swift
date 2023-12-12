import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var isLoggedIn: Bool = true

    var body: some View {
        Group {
        
                TabView {
                    NavigationView {
                        ExoView()
                    }
                    .tag(0)
                    .tabItem {
                        Image("bionicLeg")
                            .resizable()
                        Text("My Exoskeleton")
                    }

                    NavigationView {
                        AccountView()
                    }
                    .tag(2)
                    .tabItem {
                        Image("account")
                        Text("Account")
                    }
                }
          
        }
//        .onAppear {
//            checkUserLoggedIn()
//        }
    }

//    func checkUserLoggedIn() {
//        if Auth.auth().currentUser != nil {
//            isLoggedIn = true
//        } else {
//            isLoggedIn = false
//        }
//    }
}
