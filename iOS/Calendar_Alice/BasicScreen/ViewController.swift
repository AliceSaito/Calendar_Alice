//  ViewController.swift
//ViewController.swiftは、画面に処理をさせる役。DataController.swiftは、コアデータのための処理をするクラス。
//  CoreDataTest
//
//  Created by ALICE SAITO on 2020/01/30.
//  Copyright © 2020 ALICE SAITO. All rights reserved.
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
        note.scheduleDate = Date()
//        saveContextというfuncで保存する。
        appDelegate.dataController.saveContext()
    }
    
//    保存されたデータがコンソルに出力される。
    @IBAction func FetchNote(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let fetched = appDelegate.dataController.fetchNotes()
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

