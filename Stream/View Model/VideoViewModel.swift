//
//  VideoViewModel.swift
//  Stream
//
//  Created by Sheila Doherty on 8/22/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import Foundation

struct VideoViewModel {
    
    let name: String
    let urlString: String
    
    init(video: Video){
        self.name = video.name
        self.urlString = video.urlString
    }
    
}
