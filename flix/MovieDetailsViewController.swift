//
//  MovieDetailsViewController.swift
//  flix
//
//  Created by Kenneth Pu on 9/20/15.
//  Copyright © 2015 Kenneth Pu. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate {

    var movie : NSDictionary?

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieTitle = self.movie!["title"] as? String
        let movieYear = self.movie!["year"] as? Int
        let movieRating = self.movie!["mpaa_rating"] as? String
        let movieCriticsScore = self.movie!.valueForKeyPath("ratings.critics_score") as? Int
        let movieAudienceScore = self.movie!.valueForKeyPath("ratings.audience_score") as? Int
        let movieSynopsis = self.movie!["synopsis"] as? String
        
        self.navigationItem.title = movieTitle
        
        var urlString = self.movie!.valueForKeyPath("posters.thumbnail") as! String
        if let range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch) {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let url = NSURL(string: urlString)
        self.posterImageView .setImageWithURL(url!)
        
        let offset = 350 as CGFloat
        let contentView = UIView(frame: CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height - self.navigationController!.navigationBar.frame.size.height))
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.alpha = 0.85;
        self.scrollView.addSubview(contentView)
        
        let scrollHeight = offset + contentView.frame.size.height - 16
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight)
        
        let titleLabel = UILabel(frame: CGRectMake(8, 8, self.view.frame.size.width - 16, 28))
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        titleLabel.text = String(format: "%@ (%d)", movieTitle!, movieYear!)
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        
        let scoreLabel = UILabel(frame: CGRectMake(8, titleLabel.frame.maxY+4, self.view.frame.size.width - 16, 28))
        scoreLabel.text = String(format: "Critics Score: %d%%, Audience Score: %d%%", movieCriticsScore!, movieAudienceScore!)
        scoreLabel.sizeToFit()
        contentView.addSubview(scoreLabel)
        
        let ratingLabel = UILabel(frame: CGRectMake(8, scoreLabel.frame.maxY+4, self.view.frame.size.width - 16, 28))
        ratingLabel.text = String(format: "Rated %@", movieRating!)
        ratingLabel.sizeToFit()
        contentView.addSubview(ratingLabel)
        
        let synopsisLabel = UILabel(frame: CGRectMake(8, ratingLabel.frame.maxY+4, self.view.frame.size.width - 16, self.view.frame.size.height - titleLabel.frame.size.height - scoreLabel.frame.size.height - ratingLabel.frame.size.height))
        synopsisLabel.text = movieSynopsis
        synopsisLabel.numberOfLines = 0 as Int
        synopsisLabel.sizeToFit()
        contentView.addSubview(synopsisLabel)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Only let scrollView bounce when scrolling down
        scrollView.bounces = (scrollView.contentOffset.y < 50)
    }
}
