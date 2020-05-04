//
//  ScheduleListViewCotroller.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/04.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class ScheduleListViewCotroller: UIViewController, AddScheduleViewControllerDelegate {
    
    @IBOutlet weak var searchToolBarHaightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchIcon: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = []

    private func fetchNotes() -> [Note]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return appDelegate.dataController.fetchNotesAllDate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //notesにdataBaseからとってきたNote一覧を詰める。
        notes = fetchNotes()
        tableView.reloadData()
        
      }
    
 
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //count：何個のデータが入っているかをコンソルでチェック。ビルドした回数が表示される。
        //notesにdataBaseからとってきたNote一覧を詰める。
        notes = fetchNotes()
        print("notes >> \(notes.count)")
        print("notes >> \(notes)")
        //最初は検索バーを隠す処理
        searchToolBarHaightConstraint.constant = 0

        searchIcon.target = self
        searchIcon.action = #selector(barButtonTapped(_:))

    }
    
    //検索バーの文字が変わったら、コンソルに出る。
    @IBAction func editingChanged(_ sender: UITextField) {
        //?? ""：もしnilなら””を返す。
        print(sender.text ?? "")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        notes = appDelegate.dataController.fetchNote(value: sender.text ?? "")
        tableView.reloadData()
    }
    
    //検索アイコンをタップすると検索バーが出てくる。
    @objc func barButtonTapped(_ sender: UIBarButtonItem){
         searchToolBarHaightConstraint.constant = 44
    }
    
    
    
    //segueの繋ぎ先がAddScheduleViewControllerの場合。それをself(ScheduleListViewCotroller)に伝えて処理する(delegate)。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addScheduleViewController" {
            let vc = segue.destination as! AddScheduleViewController
            //selfはScheduleListViewCotrollerのこと。vcはインスタンス。delegateはvcがもっているプロパティ。そこにself:自分自身を代入。
            vc.delegate = self
        }
        
        //segueの繋ぎ先がScheduleDetailViewControllerの場合。noteを次の画面に渡す。
        if segue.identifier == "scheduleDetailViewController" {
            let vc = segue.destination as! ScheduleDetailViewController
            vc.note = sender as? Note
        }
    }
    //AddScheduleViewControlllerに新しいスケジュールが書かれた時、一覧を最新版にリロードする。
    func didSaveNewSchedule() {
        tableView.reloadData()
    }
    
    
    
}




//tableViewの一つのセクションの中に、何個の項目を表示させるか。numberOfRowsInSectionはfunc。
extension ScheduleListViewCotroller : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    //indexPathごとに表示させる UITableViewCellを返す。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddScheduleItem", for: indexPath) as! ScheduleItemCell
        let note = notes[indexPath.row]
        cell.ItemLabel.text = note.title
        return cell
    }
    
    //一覧のtitleをタップルすると詳細画面(scheduleDetailViewController)に遷移する。
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note: Note = notes[indexPath.row]
        //sender：タップしたviewの型
        performSegue(withIdentifier: "scheduleDetailViewController", sender: note)
    }
}

//「検索」を押すと、検索キーボードをしまう処理。
extension ScheduleListViewCotroller: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


