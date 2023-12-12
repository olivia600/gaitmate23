//import FirebaseFirestore
//import FirebaseAuth
//import Combine
//
//class FirebaseService {
//    static let shared = FirebaseService()
//    private let db = Firestore.firestore()
//
//    func saveEmergencyContact(contact: Contact, completion: @escaping (Error?) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(nil) // User not logged in
//            return
//        }
//
//        let contactData: [String: Any] = [
//            "fullName": contact.fullName,
//            "phoneNumber": contact.phoneNumber
//        ]
//
//        db.collection("users").document(userId).collection("emergencyContacts").addDocument(data: contactData) { error in
//            completion(error)
//        }
//    }
//
//    func getEmergencyContacts(completion: @escaping ([Contact]?, Error?) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(nil, nil) // User not logged in
//            return
//        }
//
//        db.collection("users").document(userId).collection("emergencyContacts").getDocuments { snapshot, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            let contacts = snapshot?.documents.compactMap { document -> Contact? in
//                guard
//                    let fullName = document["fullName"] as? String,
//                    let phoneNumber = document["phoneNumber"] as? String
//                else {
//                    return nil
//                }
//
//                return Contact(fullName: fullName, phoneNumber: phoneNumber)
//            }
//
//            completion(contacts, nil)
//        }
//    }
//}
