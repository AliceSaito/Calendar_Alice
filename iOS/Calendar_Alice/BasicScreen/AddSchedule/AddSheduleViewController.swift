//
//  AddSheduleViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/03.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit
// delegateのもっているオブジェクトのうち、必要なものだけ選べるようにするためのprotocolの定義。
protocol AddScheduleViewControllerDelegate {
    func didSaveNewSchedule()
}

class AddScheduleViewController: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    @IBOutlet weak var scheduleSaveButton: UIButton!
    
    var selectedDate: Date?
//    var selectedItem: MonthInfo?
    
    private var titleText: String?
    
    //スケジュール一覧を保存するための変数delegate。 AddScheduleViewControllerDelegate?というプロトコル型。
    var delegate: AddScheduleViewControllerDelegate?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //選択した日付をスケジュール入力画面で表示する
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let selectedDate = selectedDate {
            dateTextField.text = dateFormatter.string(from: selectedDate)
        }
        dateTextField.isEnabled = false
        //タイトルがないと保存ボタンが押せない処理
        self.validate()
        
    }
    
    
    
    @IBAction func cheduleCancelButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    
    
    }
    
    
    
    
    @IBAction func scheduleSaveButton(_ sender: Any) {
        //アンラップ。appDelegateの中にあるdataControllerを下のコードで使いたいから、appDelegateをアンラップするためのguard文。if文でもOK。
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //creatNoteというfancを呼び出す。noteというentityを変数noteに入れて、titleなどに値を入れる。
        let note = appDelegate.dataController.createNote()
        note.title = titleTextField.text
        note.date = selectedDate
        note.address = placeTextField.text
        note.memo = memoTextField.text
        note.url = urlTextField.text
        
        //saveContextというfuncで、書いた内容を保存する。
        appDelegate.dataController.saveContext()
        //delegateを使って、SheduleListViewControllerに通知する。
        delegate?.didSaveNewSchedule()
        //保存したら編集画面を閉じる
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func titleCount(_ sender: UITextField) {
        titleText = sender.text
        self.validate()
        
    }
    
    
    private func validate() {
        // nilの場合はscheduleSaveButtonを非活性に
        guard let titleTxt = self.titleTextField.text else {
            
            self.scheduleSaveButton.isEnabled = false
            return
        }
        // 文字数が0の場合(""空文字)もscheduleSaveButtonを非活性に
        if titleTxt.count == 0 {
            
            self.scheduleSaveButton.isEnabled = false
            return
        }
        // nilでないかつ0文字以上はscheduleSaveButtonを活性に
        self.scheduleSaveButton.isEnabled = true
    }
    
    
}


