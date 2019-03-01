//
//  SearchRequestAgePickerViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 13/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SearchRequestAgePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var toolBarLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var pickerDatasource = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) { 
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func okButtonTapped(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.view.backgroundColor = UIColor.clear
        }) { (finished) in
            if finished {
                let ageFrom = self.pickerDatasource[self.picker.selectedRow(inComponent: 0)]
                let ageTo = self.pickerDatasource[self.picker.selectedRow(inComponent: 1)]
                
                NotificationCenter.default.post(name:Notification.Name(rawValue:"PARAMS_AGE_CALLBACK"),
                                                object: nil,
                                                userInfo: ["ageInterval":[ageFrom,ageTo]])
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - Picker delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDatasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDatasource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.selectedRow(inComponent: 0) > pickerView.selectedRow(inComponent: 1) {
            pickerView.selectRow(pickerView.selectedRow(inComponent: 0), inComponent: 1, animated: true)
        }
    }
    
}
