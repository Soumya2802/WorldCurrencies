//
//  APICalls.swift
//  Currencies
//
//  Created by Soumya Ammu on 12/1/21.
//

import Foundation


class APICall{
    let semphare = DispatchSemaphore(value: 0)
    var currenciesIDs:APICallResult?
    
    
    func  HTTP_Request(url:String) -> APICallResult{
        
        // Network call and return data
        let url = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else { return }
            let JSON = String(data: data, encoding: .utf8)!
            
            let jsonData = JSON.data(using: .utf8)!
            self.currenciesIDs = try! JSONDecoder().decode(APICallResult.self, from: jsonData)
            
            
            self.semphare.signal()
        }
        task.resume()
        self.semphare.wait()
        return currenciesIDs ?? APICallResult.init(data: [])
    }
    

    
}

struct APICallData: Codable{
    var id : String = "id"
    var name : String = "name"
}

struct APICallResult: Codable{
    
    var data : [APICallData]
    
}
