//
//  Movie.swift
//  NetflixClone
//
//  Created by Lore P on 11/02/2023.
//

import Foundation

struct Response: Codable {
    
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
}


/*
 {
adult = 0;
"backdrop_path" = "/ypMTXI7IC0apKMvsy7OdhDwDHv0.jpg";
"genre_ids" =             (
 10749,
 35
);
id = 703451;
"media_type" = movie;
"original_language" = en;
"original_title" = "Your Place or Mine";
overview = "When best friends and total opposites Debbie and Peter swap homes for a week, they get a peek into each other's lives that could open the door to love.";
popularity = "99.029";
"poster_path" = "/ApkSeqfIPRCxOtfjXYYE6Ji7jVU.jpg";
"release_date" = "2023-02-10";
title = "Your Place or Mine";
video = 0;
"vote_average" = "6.607";
"vote_count" = 28;
}
 */
