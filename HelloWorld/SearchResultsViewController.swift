//
//  ViewController.swift
//  HelloWorld
//
//  Created by Bob on 13/08/14.
//  Copyright (c) 2014 InuLabs. All rights reserved.
//

import QuartzCore
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var albums = [Album]()
    
    let kCellIdentifier = "SearchResultCell"
    
    var api = APIController()
    
    var imageCache = [String : UIImage]()
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.delegate = self
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Michael Jackson")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = self.albums[indexPath.row]
        cell.textLabel.text = album.title
        cell.imageView.image = UIImage(named : "Blank52")
        cell.detailTextLabel.text = album.price
        
        var image = imageCache[album.thumbnailImageUrl]
        if image == nil {
            let imgUrl = NSURL(string: album.thumbnailImageUrl)
            let request = NSURLRequest(URL: imgUrl)
            NSURLConnection.sendAsynchronousRequest(request, queue: .mainQueue(), completionHandler: {(response : NSURLResponse!, data : NSData!, error : NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    self.imageCache[album.thumbnailImageUrl] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView.image = image
                }
            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var detailViewController : DetailViewController = segue.destinationViewController as DetailViewController
        var albumIndex = albumTableView!.indexPathForSelectedRow().row
        var selectedAlbum = self.albums[albumIndex]
        detailViewController.album = selectedAlbum
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJson(resultsArray)
            self.albumTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

}

