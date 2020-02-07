//
//  AddSheduleViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/03.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

protocol AddScheduleViewControllerDelegate {
    func didSaveNewSchedule()
}

class AddScheduleViewController: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var datePickerTextField: UITextField!
    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var memoTextField: UITextField!
    
    var delegate: AddScheduleViewControllerDelegate?
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddScheduleViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        datePickerTextField.inputView = datePicker
        
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        datePickerTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    
    @IBAction func scheduleSaveButton(_ sender: Any) {
        //アンラップ。appDelegateの中にあるdataControllerを下のコードで使いたいから、appDelegateをアンラップするためのguard文。if文でもOK。
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //creatNoteというfancを呼び出す。noteというentityを変数noteに入れて、titleなどに値を入れる。
        let note = appDelegate.dataController.createNote()
        note.title = titleTextField.text
        note.date = datePicker?.date
        note.address = placeTextField.text
        note.memo = memoTextField.text
        note.url = urlTextField.text
        
        
        //saveContextというfuncで、書いた内容を保存する。
        appDelegate.dataController.saveContext()
        delegate?.didSaveNewSchedule()
        //保存したら編集画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
}


