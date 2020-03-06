//
//  DayViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2020/01/10.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var checkcollectionview: UICollectionView!
    
    var selectedItem: MonthInfo!
    
    let list = ["Milk", "Water", "Soda", "Coffee"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "todayScheduleCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
  
}


extension DayViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let days = getMonthDays(monthInfo: self.selectedItem).compactMap({$0})
        return days.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = checkcollectionview.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as! ScrollDayCollectionViewCell
        let days = getMonthDays(monthInfo: self.selectedItem)
       
        if let monthInfo = days[indexPath.item] {
            cell.setData(dayOfWeek: monthInfo)
    }
    return cell
        
    }
}
