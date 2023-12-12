import SwiftUI
import FirebaseAuth

struct TabbarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
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
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            authViewModel.checkUserLoggedIn()
        }
    }
}
