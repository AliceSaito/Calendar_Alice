//
//  AddSchedule.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/01/29.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit
import EventKit
class AddScheduleViewCotroller: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }

    
    @IBAction func btnAddEvent(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion:{(granted, error) in
            
            if (granted) && (error == nil)
            {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Add event testing Title"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "This is note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("error : \(error)")
                }
                print("Save Event")
                
            }else{
                print("error : \(error)")
            }
        })
    }
    
}


