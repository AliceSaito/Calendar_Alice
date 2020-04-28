//
//  DataController.swift
//  Calendar_Alice
//  Created by 斉藤アリス on 2020/02/03.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import Foundation
import UIKit
import CoreData
//コアデータを扱うためにfuncを定義するclass
//既存のデータを追加、削除、修正
class DataController: NSObject {
//    Model.xcdatamodeldをロードする
    var persistentContainer: NSPersistentContainer!
//クロージャーで自分自身を参照する時に＠をつける。モデルというコアデータのマップをロードして、persistentContainerに入れる。
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "Model")
//        タプル型のパラメーター
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
//                \(error)にはエラーの理由がコンソルに出力される
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }

    //persistentContainerの中に定義されているNoteというEntityのオブジェクトを作って、それを返す。
//    新しいスケジュールをNoteに作る。
    func createNote() -> Note {
        let context = persistentContainer.viewContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        return note
    }
//書いたNoteを保存する。
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
//    fetch：保存されているデータを取得する。条件がないから全てのスケジュールを取得している。
    func fetchNotesAllDate() -> [Note] {
        let context = persistentContainer.viewContext
        let notesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
   
        do {
            let fetchedNotes = try context.fetch(notesFetch) as! [Note]
            return fetchedNotes
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

        return []
    }
    
    //スケジュールを日付で検索する。0:00:00〜23:59:59
    func fetchNotesWithDate(date:Date) -> [Note] {
         let context = persistentContainer.viewContext
         let notesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let nextDay = date + 24*60*60
        notesFetch.predicate = NSPredicate(format: "(date>=%@) AND (date<%@)",date as NSDate,nextDay as NSDate)
        
         do {
             let fetchedNotes = try context.fetch(notesFetch) as! [Note]
             return fetchedNotes
         } catch {
             fatalError("Failed to fetch employees: \(error)")
         }
         return []
     }
    
//    predicate：条件を入れるためのもの。検索機能で使おう！
    func fetchNote(value:String) -> [Note] {
        let context = persistentContainer.viewContext
        let notesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        notesFetch.predicate = NSPredicate(format: "title CONTAINS %@",value)
//title CONTAINS %@：タイトルに含まれている文字を検索にヒットさせる。
        do {
            let fetchedNotes = try context.fetch(notesFetch) as! [Note]
            return fetchedNotes
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

        return []
    }
}

