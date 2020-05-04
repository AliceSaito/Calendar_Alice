//
//  ScheduleDetailViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/04/30.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var memoLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    var note: Note?
    
    //@IBOutlet と @IBAction は両方繋げてok
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    func setUp(){
        //受け取ってきたnoteをそれぞれのlabelに詰める。
        titleLabel.text = note?.title
        placeLabel.text = note?.address
        memoLabel.text = note?.memo
        urlLabel.text = note?.url
        //時間：date型をstring型に変える。
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = note?.date {
            dayLabel.text = dateFormatter.string(from: date)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    //segueでEditScheduleViewControllerと繋いでいる
    @IBAction func editButton(_ sender: Any) {
    }
    
    
    
    @IBAction func deleteButton(_ sender: Any) -> Void {
        ///アンラップ。appDelegateの中にあるdataControllerを下のコードで使いたいから、appDelegateをアンラップするためのguard文。if文でもOK.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.dataController.deleteNote(note: note!)
        //遷移元画面へ戻る
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "editScheduleViewController" {
             let vc = segue.destination as! EditScheduleViewController
             vc.note = self.note
             vc.delegate = self
         }
     }
    
  
}
//スケジュールの編集
extension ScheduleDetailViewController :  EditScheduleViewControllerDelegate {
    func didSaveEditSchedule() {
        setUp()
    }
    
    
}
