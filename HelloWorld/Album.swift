//
//  Album.swift
//  HelloWorld
//
//  Created by Bob on 14/08/14.
//  Copyright (c) 2014 InuLabs. All rights reserved.
//

import Foundation

class Album {
    var collectionId : Int
    var title : String
    var price : String
    var thumbnailImageUrl : String
    var largeImageUrl : String
    var itemUrl : String
    var artistUrl : String
    
    init(collectionId : Int, title : String, price : String, thumbnailImageUrl : String, largeImageUrl : String, itemUrl : String, artistUrl : String) {
        self.collectionId = collectionId
        self.title = title
        self.price = price
        self.thumbnailImageUrl = thumbnailImageUrl
        self.largeImageUrl = largeImageUrl
        self.itemUrl = itemUrl
        self.artistUrl = artistUrl
    }
    
    class func albumsWithJson(albumsJson : NSArray) -> [Album] {
        var albums = [Album]()
        for albumJson in albumsJson {
            var title = albumJson["trackName"] as? String
            if title == nil {
                title = albumJson["collectionName"] as? String
            }
            
            var price = albumJson["formattedPrice"] as? String
            if price == nil {
                var priceFloat : Float? = albumJson["collectionPrice"] as? Float
                var nf = NSNumberFormatter()
                nf.maximumFractionDigits = 2
                if priceFloat != nil {
                    price = "$" + nf.stringFromNumber(priceFloat)
                }
            }
            
            let thumbnailUrl = albumJson["artworkUrl60"] as? String
            let imageUrl = albumJson["artworkUrl100"] as? String
            
            var artistUrl = albumJson["artistViewUrl"] as? String
            if artistUrl == nil {
                artistUrl = "http://google.com"
            }
            
            var itemUrl = albumJson["collectionViewUrl"] as? String
            if itemUrl == nil {
                itemUrl = albumJson["trackViewUrl"] as? String
            }
            
            var collectionId = albumJson["collectionId"] as? Int
            
            var album = Album(collectionId : collectionId!, title : title!, price : price!, thumbnailImageUrl : thumbnailUrl!, largeImageUrl : imageUrl!, itemUrl : itemUrl!, artistUrl : artistUrl!)
            albums.append(album)
        }
        return albums
    }
}
