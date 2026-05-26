import Foundation

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUserEmail: String?
    
    var isAuthenticated: Bool {
        return currentUserEmail != nil
    }
    
    private init() {
        if let savedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            self.currentUserEmail = savedEmail
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        UserDefaults.standard.set(password, forKey: "pass_\(email)")
        signIn(email: email, password: password, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let savedPass = UserDefaults.standard.string(forKey: "pass_\(email)")
        if savedPass == password {
            UserDefaults.standard.set(email, forKey: "userEmail")
            self.currentUserEmail = email
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials."])))
        }
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        self.currentUserEmail = nil
    }
}
