//
//  ContactsView.swift
//  GaitMate
//
//  Created by Abe Nidhiry on 11/29/23.
//

import SwiftUI
import ContactsUI

struct EmergencyContactsView: View {
    @State private var emergencyContacts: [Contact] = []
    @State private var showContactPicker: Bool = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Emergency Contacts")) {
                    ForEach(emergencyContacts, id: \.id) { contact in
                        Text("\(contact.fullName): \(contact.phoneNumber)")
                    }
                }
            }

            Section() {
                Button(action: {
                    showContactPicker.toggle()
                }) {
                    Label("Add New Contact", systemImage: "person.crop.circle.badge.plus")
                        .foregroundColor(.blue)
                }
                

            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Emergency Contacts")
        .sheet(isPresented: $showContactPicker) {
            ContactPickerView(selectedContact: $emergencyContacts)
        }
    }
}

struct EmergencyContactsView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactsView()
    }
}

struct Contact: Identifiable {
    let id = UUID()
    let fullName: String
    let phoneNumber: String
}

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var selectedContact: [Contact]

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = context.coordinator
        viewController.present(contactPicker, animated: true, completion: nil)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView

        init(_ parent: ContactPickerView) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                let newContact = Contact(fullName: "\(contact.givenName) \(contact.familyName)", phoneNumber: phoneNumber)
                parent.selectedContact.append(newContact)
            }
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {}
    }
}
