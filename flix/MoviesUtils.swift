//
//  MoviesUtils.swift
//  flix
//
//  Created by Kenneth Pu on 9/20/15.
//  Copyright © 2015 Kenneth Pu. All rights reserved.
//

import UIKit

class MoviesUtils: NSObject {
    class func getImageForRating(rating: NSString) -> UIImage? {
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
    
    class func getActorsString(cast: NSArray) -> NSString {
        let firstThreeCast = cast.prefix(3)
        var firstThreeActors = [String]()
        for castMember in firstThreeCast {
            let actor = castMember["name"] as? String
            firstThreeActors.append(actor!)
        }
        return firstThreeActors.joinWithSeparator(", ")
    }
    
    class func minutesToRuntimeString(minutes: Int) -> NSString {
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
}
