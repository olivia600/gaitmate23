import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?

    init() {
        checkUserLoggedIn()
    }

    func checkUserLoggedIn() {
        isLoggedIn = Auth.auth().currentUser != nil
        currentUser = Auth.auth().currentUser
    }
}
