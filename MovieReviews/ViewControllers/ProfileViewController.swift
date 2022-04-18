//
//  ProfileViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var persistentContainer: NSPersistentContainer!
    var profile: Profile?
    
    @IBAction func saveProfileAction(_ sender: UIButton) {
        let moc = self.persistentContainer.viewContext
        if let profile = profile {
            //update context
            profile.name = nameTextField.text
            profile.email_address = emailTextField.text
            profile.contact_number = contactTextField.text
            profile.image = profile.image
        } else {
            //add to watchlist
            self.profile = Profile(context: moc)
            self.profile!.name = nameTextField.text
            self.profile!.email_address = emailTextField.text
            self.profile!.contact_number = contactTextField.text
            self.profile!.image = profileImage.image?.jpegData(compressionQuality: 1.0)
        }
        
        moc.perform {
            do {
                try moc.save()
            } catch {
                moc.rollback()
            }
        }
    }
    
    @IBAction func addPhotoAction(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        if let profile = profile {
            profileImage.image = UIImage(data: profile.image!)
            nameTextField.text = profile.name
            emailTextField.text = profile.email_address
            contactTextField.text = profile.contact_number
        }
    }
    
    private func fetchData() {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        let moc = persistentContainer.viewContext
        guard
            let results = try? moc.fetch(request)
        else {return}
        if !results.isEmpty {
            profile = results[0]
        }
    }

}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.profileImage.image = image
        
    }
    
}
