//
//  DetailViewCOntroller.swift
//  HelloWorld
//
//  Created by Bob on 14/08/14.
//  Copyright (c) 2014 InuLabs. All rights reserved.
//

import MediaPlayer
import QuartzCore
import UIKit

class DetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var mediaPlayer = MPMoviePlayerController()
    
    var album : Album?
    var tracks = [Track]()
    
    var api = APIController()
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    required init(coder aDecoder : NSCoder!) {
        super.init(coder : aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.delegate = self
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.lookupAlbum(self.album!.collectionId)
        
        albumTitle.text = self.album?.title
        albumCover.image = UIImage(data : NSData(contentsOfURL : NSURL(string : self.album?.largeImageUrl)))
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        cell.titleLabel.text = tracks[indexPath.row].title
        cell.playIcon.text = "▶️"
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var track = tracks[indexPath.row]
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string : track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "#️⃣"
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArray : NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJson(resultsArray)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
}