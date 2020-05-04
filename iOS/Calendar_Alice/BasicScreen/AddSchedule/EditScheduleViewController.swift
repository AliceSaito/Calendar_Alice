//
//  EditScheduleViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/05/04.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit
protocol EditScheduleViewControllerDelegate {
    func didSaveEditSchedule()
}

class EditScheduleViewController: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    var toolBar:UIToolbar!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    var note: Note?
    var selectedDate : Date?
    var delegate: EditScheduleViewControllerDelegate?
    
    
    
    func setUp(){
        //受け取ってきたnoteをそれぞれのlabelに詰める。
        titleTextField.text = note?.title
        placeTextField.text = note?.address
        memoTextField.text = note?.memo
        urlTextField.text = note?.url
        
        selectedDate = note?.date
        updateDateTextFieldWithSelectedDate()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        //DatePickerを表示するためにToolbarが必要
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(self.doneBtn))
        toolBar.items = [toolBarBtn]
        dateTextField.inputAccessoryView = toolBar
        
    }
    
    
    //テキストフィールドが選択されたらdatepickerを表示
    @IBAction func textFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
//        datePickerView.addTarget(self, action: Selector(("datePickerValueChanged:")), for: UIControl.Event.valueChanged)
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        selectedDate = sender.date
        updateDateTextFieldWithSelectedDate()
    }
    
    /// selectedDateを元にtextFieldに反映する
    func updateDateTextFieldWithSelectedDate() {
        guard let selectedDate = selectedDate else {
            // selectedDateがnilだった
            return
        }
        //date型をstring型に変更
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd"
        dateTextField.text = dateFormatter.string(from: selectedDate)
    }
    
    //toolbarのdoneボタン
    @objc func doneBtn(){
        dateTextField.resignFirstResponder()
    }
    
      
      
    
    

    @IBAction func scheduleSaveButton(_ sender: Any) {
        //アンラップ。appDelegateの中にあるdataControllerを下のコードで使いたいから、appDelegateをアンラップするためのguard文。if文でもOK。
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //updateNoteというfancを呼び出す。noteというentityを変数noteに入れて、titleなどに値を入れる。
        note?.title = titleTextField.text
        note?.date = selectedDate
        note?.address = placeTextField.text
        note?.memo = memoTextField.text
        note?.url = urlTextField.text
        appDelegate.dataController.updateNote(note: note!)
        
       
        //delegateを使って、SheduleListViewControllerに通知する。
        delegate?.didSaveEditSchedule()
        //保存したら編集画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }

}
