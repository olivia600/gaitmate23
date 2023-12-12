import SwiftUI
import Firebase
import FirebaseAuth

struct AccountView: View {
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    @State var selectedMeasure: Int = 0
    @State var measurementArray: [String] = ["Metric", "Imperial"]
    @State private var logoutTriggered = false // Added state variable
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        GeometryReader { g in
            VStack {
                Image("felix")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .background(Color.yellow)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                Text("Felix Huang")
                    .font(.system(size: 20))
                    
                Form {
                    Section(header: Text("System Preferences")) {
                        Picker(selection: self.$selectedMeasure, label: Text("Measurements")) {
                            ForEach(0 ..< self.measurementArray.count) {
                                Text(self.measurementArray[$0])
                            }
                        }
                        Toggle(isOn: self.$locationUsage) {
                            Text("Location Usage")
                        }
                        Toggle(isOn: self.$notificationToggle) {
                            Text("Notifications")
                        }
                    }
                    
                    Section(header: Text("Personal Information")) {
                        NavigationLink(destination: Text("Profile Info")) {
                            Text("Profile Information")
                        }
                        NavigationLink(destination: EmergencyContactsView()) {
                            Text("Emergency Contacts")
                        }
                        NavigationLink(destination: BluetoothContentView()) {
                            Text("bluetooth devices")
                        }
                        NavigationLink(destination: Text("Billing Info")) {
                            Text("Billing Information")
                        }
                    }
                    
                    Section() {
                        NavigationLink(destination: Text("Profile Info")) {
                            Text("About GaitMate")
                        }
                    }
                    
                    Section {
                        Button(action: {
                            logout()
                            self.logoutTriggered.toggle() // Toggle after logout
                        }) {
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    }
                }
                .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                .navigationBarTitle("Account")
            }
        }
        .onAppear {
            // This block will be triggered when the view appears or reappears
            if logoutTriggered {
                // Additional actions after logout (if needed)
                print("View refreshed after logout")
                self.logoutTriggered = false // Reset the trigger
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            authViewModel.isLoggedIn = false
            print("Logged out")
        } catch {
            print("Error during logout: \(error.localizedDescription)")
        }
    }
}
