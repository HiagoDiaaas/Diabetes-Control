//
//  DetailViewController.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 18/10/22.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func saveData(imageIcon: UIImage, value: String)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    var image: UIImage!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueTextField.delegate = self
        
        saveButton.isEnabled = false
        iconImage.image = image
        navigationController?.navigationBar.barStyle = .black
       
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if valueTextField.text!.count > 0 {
            saveButton.isEnabled = true
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if let text = valueTextField.text {
            delegate?.saveData(imageIcon: image, value: text)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueTextField.resignFirstResponder()
        return false
    }
}
