import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to GaitMate")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundColor(.blue)
                
                Image("olivia") // Add your app logo image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
                
                NavigationLink(destination: LogInContentView()) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                
                NavigationLink(destination: RegisterContentView()) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green) // Choose an appropriate color
                        .cornerRadius(10)
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
