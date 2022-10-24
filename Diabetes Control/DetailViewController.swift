//
//  DetailViewController.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 18/10/22.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func saveData(dateValue: String, value: String, type: String, sfSimbolString: String)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    var image: UIImage!
    var pickerViewOptions = [String]()
    var eventValue: String!
    var eventType: String!
    var isPickerViewHidden = false
    var pickerIdentifier: String?
    var sfSymbolIdentifier: String!

    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView?
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueTextField.delegate = self
        
        saveButton.isEnabled = false
        iconImage.image = image
        navigationController?.navigationBar.barStyle = .black
        myDatePicker.overrideUserInterfaceStyle = .dark
        
        
        valueLabel.text = eventValue
        typeLabel.text = eventType
        
        pickerView?.dataSource = self
        pickerView?.delegate = self
        pickerView?.isHidden = isPickerViewHidden
  
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        if let text = valueTextField.text {
            delegate?.saveData(dateValue: dateFormatter.string(from: myDatePicker.date), value: text, type: pickerIdentifier ?? pickerViewOptions[0], sfSimbolString: sfSymbolIdentifier)
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

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewOptions[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIdentifier = pickerViewOptions[row] as String
    }
    
}
