//
//  ViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/03.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//
import UIKit
import CoreData


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func AddData(_ sender: Any) {
        print("テスト")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
//        creatNoteというfancを呼び出し、noteというentityを変数noteに入れて、titleとscheduleに値を入れる。
        let note = appDelegate.dataController.createNote()
        note.title = "test"
        note.date = Date()
        note.address = "渋谷区恵比寿西"
        note.memo = "memo"
        note.url = "https://tokosie.jp/"
        
            
//        saveContextというfuncで保存する。
        appDelegate.dataController.saveContext()
    }
    
//    保存されたデータがコンソルに出力される。
    @IBAction func FetchNote(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let fetched = appDelegate.dataController.fetchNotesAllDate()
        fetched.forEach {
            let note = $0
            print(note.title!)
        }
        
        let notes = appDelegate.dataController.fetchNote(value:"test")
        notes.forEach {
            let note = $0
            print(note.title!)
        }
        
    }
    
}

