//
//  AddSheduleViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/03.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class AddSheduleViewController: UITableViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddScheduleItem", for: indexPath)
        
        if let label = cell.viewWithTag(30) as? UILabel {
            if indexPath.row == 0 {
                label.text = "Go to Party"
            } else {
                label.text = "ERROR"
            }
        }
        
        return cell
    }
}
