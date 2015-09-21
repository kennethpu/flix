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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movies"
        
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
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")
        
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
    
    func getImageForRating(rating: NSString) -> UIImage? {
        switch (rating) {
            case "Certified Fresh":
                return UIImage(named: "cert_fresh")
            case "Fresh":
                return UIImage(named: "fresh")
            case "Rotten":
                return UIImage(named: "rotten")
            case "Upright":
                return UIImage(named: "upright")
            case "Spilled":
                return UIImage(named: "spilled")
            default:
                return nil
        }
    }
    
    func getActorsString(cast: NSArray) -> NSString {
        let firstThreeCast = cast.prefix(3)
        var firstThreeActors = [String]()
        for castMember in firstThreeCast {
            let actor = castMember["name"] as? String
            firstThreeActors.append(actor!)
        }
        return firstThreeActors.joinWithSeparator(", ")
    }
    
    func minutesToRuntimeString(minutes: Int) -> NSString {
        let numHours = minutes / 60
        let numMinutes = minutes % 60
        if (numHours == 0) {
            return String(format: "%d min.", numMinutes)
        } else if (numMinutes == 0) {
            return String(format: "%d hr.", numHours)
        } else {
            return String(format: "%d hr. %d min.", numHours, numMinutes)
        }
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
            cell.criticsIcon.image = getImageForRating(movieCriticsRating!)
        }
        cell.criticsScoreLabel.text = String(format: "%d%%", movieCriticsScore!)
        
        if (movieAudienceRating != nil) {
            cell.audienceIcon.image = getImageForRating(movieAudienceRating!)
        }
        cell.audienceScoreLabel.text = String(format: "%d%%", movieAudienceScore!)
        
        cell.actorsLabel.text = getActorsString(movieCast!) as String
        
        cell.ratingLabel.text = String(format: "%@, %@", movieRating!, minutesToRuntimeString(movieRuntime!))
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 176
    }
}