//
//  AddSheduleViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/03.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class AddSheduleViewController: UITableViewController {
    
    
    
    @IBOutlet weak var datePickerTextField: UITextField!
    
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddSheduleViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        datePickerTextField.inputView = datePicker
        
        
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        datePickerTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}
