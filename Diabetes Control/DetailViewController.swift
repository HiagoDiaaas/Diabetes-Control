//
//  DetailViewController.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 18/10/22.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func saveData(dateValue: String, value: String, type: String, sfSimbolString: String)
    func updateData(item: EventItem, newSfSymbolIdentifier: String, newTitle: String, newDateAndTime: String, newType: String)
}

class DetailViewController: UIViewController {
    var arrayData = [EventItem]()
    // MARK: Properties
    weak var delegate: DetailViewControllerDelegate?
    var image: UIImage!
    var pickerViewOptions = [String]()
    var eventValue: String!
    var eventType: String!
    var pickerOptionChoosed: String!
    var isPickerViewHidden = false
    var pickerIdentifier: String?
    var sfSymbolIdentifier: String!
    var dateString: String!
    var textFieldValue: String!
    var isFromTableView: Bool!
    var indexPath: IndexPath!

    // MARK: IBOutlets
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var typePickerView: UIPickerView?
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueTextField.delegate = self
        typeTextField.delegate = self
        typeTextField.isHidden = isPickerViewHidden
        
        saveButton.isEnabled = false
        iconImage.image = image
        navigationController?.navigationBar.barStyle = .black
        myDatePicker.overrideUserInterfaceStyle = .dark
        
        valueLabel.text = eventValue
        typeLabel.text = eventType
        
        typePickerView?.dataSource = self
        typePickerView?.delegate = self
        typePickerView?.isHidden = true
        
        if let value = self.textFieldValue,
            let dateValue = self.dateString,
            let type = self.pickerOptionChoosed,
            let img = self.image {
            valueTextField.text = value
            typeTextField.text = type
            self.iconImage.image = img
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let date = dateFormatter.date(from: dateValue)
            if let dt = date {
                myDatePicker.date = dt
            }
            
            
            
            
        }
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
        if let textValue = valueTextField.text {
            save(value: textValue)
        }
    }
    
    private func save(value: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
//        for (item, index) in arrayData {
//            if item
//        }
//
        
        
        if isFromTableView {
//            delegate?.updateData(item: selectedItem,
//                                 newSfSymbolIdentifier: sfSymbolIdentifier,
//                                 newTitle: value,
//                                 newDateAndTime: dateFormatter.string(from: myDatePicker.date),
//                                 newType: pickerIdentifier ?? pickerViewOptions[0])
        } else {
            delegate?.saveData(dateValue: dateFormatter.string(from: myDatePicker.date),
                               value: value,
                               type: pickerIdentifier ?? pickerViewOptions[0],
                               sfSimbolString: sfSymbolIdentifier)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}

// MARK: - UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueTextField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if typeTextField == textField {
            typePickerView?.isHidden = false
            
            /// show exactly previous selected row in picker
            if let pickerString = self.pickerOptionChoosed {
                if let index = pickerViewOptions.firstIndex(of: pickerString) {
                    self.typePickerView?.selectRow(index, inComponent: 0, animated: true)
                }
            }
           
            
        }
        
        if textField == valueTextField {
            return true
        }
        
        return false
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
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
        typeTextField.text = pickerIdentifier
        typePickerView?.isHidden = true
    }
}
