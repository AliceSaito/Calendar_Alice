//
//  WeekViewController.swift
//  Calender_Alice
//
//  Created by 斉藤 アリス on 2019/12/18.
//  Copyright © 2019 斉藤 アリス. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
// 月表示のカレンダーを２回繰り返し表示する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        ↓　items.countにしたら、itemsで書いたstringが表示される。文字でも数字でもOK。
    //        return items.count
    //        ↓ 0〜30までの数字を、順番に31個表示する。
            return 31
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCollectionViewCell", for: indexPath) as! WeekCollectionViewCell
            
    //        cell.myLabel.text = items[indexPath.item]
            print(indexPath)
    //indexPathは、itemとsectionと一緒に使う。itemは月表示のカレンダー、sectionはその繰り返しの回数。
            cell.myLabel.text = "\(indexPath.section+1)-\(indexPath.item+1)"
            return cell
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print(indexPath.item)
       }
}

