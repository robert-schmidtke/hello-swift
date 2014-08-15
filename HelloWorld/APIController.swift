//
//  APIController.swift
//  HelloWorld
//
//  Created by Bob on 14/08/14.
//  Copyright (c) 2014 InuLabs. All rights reserved.
//

import Foundation

class APIController {
    
    var delegate : APIControllerProtocol?
        
    init() {
    }
    
    func searchItunesFor(term : String) {
        let iTunesTerm = term.stringByReplacingOccurrencesOfString(" ", withString: "+", options: .CaseInsensitiveSearch, range: nil)
        let escapedTerm = iTunesTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlPath = "https://itunes.apple.com/search?term=\(escapedTerm)&media=music&entity=album"
        get(urlPath)
    }
    
    func lookupAlbum(collectionId : Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
    func get(path : String) {
        let url = NSURL(string : path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            println("Task completed")
            if(error) {
                println(error.localizedDescription)
            }
            var err : NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options : .MutableContainers, error : &err) as NSDictionary
            if let d = err?.localizedDescription {
                println("JSON Error \(d)")
            }
            self.delegate?.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }
    
}

protocol APIControllerProtocol {
    func didReceiveAPIResults(results : NSDictionary)
}