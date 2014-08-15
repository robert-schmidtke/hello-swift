//
//  Track.swift
//  HelloWorld
//
//  Created by Bob on 14/08/14.
//  Copyright (c) 2014 InuLabs. All rights reserved.
//

import Foundation

class Track {
    
    var title : String
    var price : String
    var previewUrl : String
    
    init(title : String, price : String, previewUrl : String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    class func tracksWithJson(tracksJson : NSArray) -> [Track] {
        var tracks = [Track]()
        for trackJson in tracksJson {
            if let kind = trackJson["kind"] as? String {
                if kind == "song" {
                    var trackPrice = trackJson["trackPrice"] as? String
                    var trackTitle = trackJson["trackName"] as? String
                    var trackPreviewUrl = trackJson["previewUrl"] as? String
                    
                    if trackTitle == nil {
                        trackTitle = "Unknown"
                    }
                    if trackPrice == nil {
                        trackPrice = "?"
                    }
                    if trackPreviewUrl == nil {
                        trackPreviewUrl = ""
                    }
                    
                    var track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
    
}