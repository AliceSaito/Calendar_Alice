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
    
    @IBOutlet weak var memoLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    var note: Note?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //受け取ってきたnoteをそれぞれのlabelに詰める。
        titleLabel.text = note?.title
        memoLabel.text = note?.memo
        urlLabel.text = note?.url
        //時間：date型をstring型に変える。
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = note?.date {
            dayLabel.text = dateFormatter.string(from: date)
        }
    }
    
    
    
}
