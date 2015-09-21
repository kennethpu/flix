//
//  MoviesViewController.swift
//  flix
//
//  Created by Kenneth Pu on 9/19/15.
//  Copyright © 2015 Kenneth Pu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary]?
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.title
        if (self.title == "Movies") {
            self.urlString = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
        } else {
            self.urlString = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
        }
        
        self.errorView.hidden = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        fetchData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as? MovieDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        destinationVC!.movie = self.movies![indexPath!.row] as NSDictionary
    }
    
    func refresh(sender: AnyObject) {
        self.errorView.hidden = true
        fetchData()
        self.refreshControl.endRefreshing()
    }
    
    func fetchData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let url = NSURL(string: self.urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            if let data = data {
                dispatch_async(dispatch_get_main_queue()){
                    do {
                        if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue : 0)) as? NSDictionary {
                            //set the variables
                            self.movies = (jsonData["movies"] as? [NSDictionary])!
                            self.tableView.reloadData()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        }
                    } catch {
                        NSLog("JSON error")
                    }
                }
            } else if let error = error {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                NSLog("\(error.description)")
//                self.tableView.hidden = true
                self.errorView.hidden = false
            }
        }
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.flix.movieCell", forIndexPath: indexPath) as! MoviesTableViewCell
        
        let movie = self.movies![indexPath.row]
        let movieTitle = movie["title"] as? String
        let movieYear = movie["year"] as? Int
        let movieRating = movie["mpaa_rating"] as? String
        let movieRuntime = movie["runtime"] as? Int
        let movieCriticsRating = movie.valueForKeyPath("ratings.critics_rating") as? String
        let movieCriticsScore = movie.valueForKeyPath("ratings.critics_score") as? Int
        let movieAudienceRating = movie.valueForKeyPath("ratings.audience_rating") as? String
        let movieAudienceScore = movie.valueForKeyPath("ratings.audience_score") as? Int
        let movieCast = movie["abridged_cast"] as? NSArray
        
        cell.titleLabel?.text = String(format: "%@ (%d)", movieTitle!, movieYear!)
        
        var urlString = movie.valueForKeyPath("posters.thumbnail") as! String
        if let range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch) {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let url = NSURL(string: urlString)
        cell.posterImageView.setImageWithURL(url!)
        
        if (movieCriticsRating != nil) {
            cell.criticsIcon.image = MoviesUtils.getImageForRating(movieCriticsRating!)
        }
        cell.criticsScoreLabel.text = String(format: "%d%%", movieCriticsScore!)
        
        if (movieAudienceRating != nil) {
            cell.audienceIcon.image = MoviesUtils.getImageForRating(movieAudienceRating!)
        }
        cell.audienceScoreLabel.text = String(format: "%d%%", movieAudienceScore!)
        
        cell.actorsLabel.text = MoviesUtils.getActorsString(movieCast!) as String
        
        cell.ratingLabel.text = String(format: "%@, %@", movieRating!, MoviesUtils.minutesToRuntimeString(movieRuntime!))
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 176
    }
}