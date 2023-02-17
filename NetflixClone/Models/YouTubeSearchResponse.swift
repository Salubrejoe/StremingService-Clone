//
//  YouTubeSearchResponse.swift
//  NetflixClone
//
//  Created by Lore P on 14/02/2023.
//

import Foundation


struct YouTubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementId
}

struct VideoElementId: Codable {
    let kind: String
    let videoId: String
}





/*
 items =     (
 {
 etag = "_Pp52bNxYA8poQGFe3M15fmHNL0";
 id =             {
 kind = "youtube#video";
 videoId = TQpwONzpcy4;
 };
 kind = "youtube#searchResult";
 },
 
*/
