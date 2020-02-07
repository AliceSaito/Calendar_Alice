//
//  ScheduleListViewCotroller.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/04.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class ScheduleListViewCotroller: UIViewController, AddScheduleViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    
    //一覧ボタンと繋げた
    @IBAction func addDummyData(_ sender: UIBarButtonItem) {
        //appDelegateを参照できるインスタンスを取得
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //
        let note = appDelegate.dataController.createNote()
        note.title = "test"
        note.date = Date()
        note.address = "渋谷区恵比寿西"
        note.memo = "memo"
        note.url = "https://tokosie.jp/"
        //    saveContextというfuncで保存する。
        appDelegate.dataController.saveContext()
    }
    
    //
    private func fetchNotes() -> [Note]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return appDelegate.dataController.fetchNotes()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //count：何個のデータが入っているかをコンソルでチェック。ビルドした回数が表示される。
        let notes = fetchNotes()
        print("notes >> \(notes.count)")
        print("notes >> \(notes)")
        
    }
    
    //segueの繋ぎ先がAddScheduleViewController。それをself(ScheduleListViewCotroller)に伝えて処理するよ(delegate)。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddScheduleViewController
        vc.delegate = self

        
    }
    //保存したものを一覧に表示。
    func didSaveNewSchedule() {
        tableView.reloadData()
        
    }
    
}

//tableViewの一つのセクションの中に、何個の項目を表示させるか。numberOfRowsInSectionはfunc。
extension ScheduleListViewCotroller : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchNotes().count
    }
    //indexPathごとに表示させる UITableViewCellを返す。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddScheduleItem", for: indexPath) as! ScheduleItemCell
        let item = fetchNotes()[indexPath.item]
        cell.ItemLabel.text = item.title
        return cell
    }
}


