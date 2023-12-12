import SwiftUI
import Firebase
import FirebaseAuth

struct LogInContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var wrongEmail: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var showingLoginScreen = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                    
                    Text("Email")
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    TextField("Enter your email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongEmail))
                        .foregroundColor(.black)
                    
                    Text("Password")
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                        .foregroundColor(.black)
                    
                    Button("Login") {
                        loginUser(email: email, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .sheet(isPresented: $showingLoginScreen) {
                        // Use sheet for navigation to the TabbarView
                        TabbarView()
                    }
                }
            }.navigationBarHidden(true)
            .onAppear {
                checkUserLoggedIn()
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                // Handle login failure (e.g., show an error message)
            } else {
                print("Login successful")
                showingLoginScreen = true
                // Navigate to the TabbarView upon successful login
            }
        }
    }

    func checkUserLoggedIn() {
        if Auth.auth().currentUser != nil {
            // User is logged in, navigate to the TabbarView
            showingLoginScreen = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInContentView()
    }
}
