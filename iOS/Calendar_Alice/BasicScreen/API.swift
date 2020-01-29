//
//  API.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/01/28.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import Foundation
class ApiClass {
    
    
    func holiday()    {
        let url = "https://holidays-jp.github.io/api/v1/date.json"
        
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            //今回の処理には関係ないが一応。
            if let httResponse = response as? HTTPURLResponse {
                print(httResponse.statusCode)
            }
            //レスポンスのバイナリデータがJSONとして解釈できる場合、JSONSerializationクラスのメソッドを使って Data型 -> Any型　に変換できる。
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                //今回のレスポンスはJSONの配列なので Any -> [Any] -> [String: Any] とキャストし、Articleのインスタンスを生成した。
//                guard let jsonArray = jsonObject as? [Any] else {
//                    return
//                }
                
                print(jsonObject)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        //戻り値のURLSessionDataTaskクラスのresume()メソッドを実行すると通信が開始される。
        task.resume()
    }

}
