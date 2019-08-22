//
//  Service.swift
//  Stream
//
//  Created by Sheila Doherty on 8/22/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import Foundation

class Service: NSObject {
    static let shared = Service()
    
    func makeVideoArray() -> [Video] {
        var videoArray = [Video]()
        
        let folgersVideo = Video(name: "Folgers", urlString: "http://cdnbakmi.kaltura.com/p/243342/sp/24334200/playManifest/entryId/0_uka1msg4/flavorIds/1_vqhfu6uy,1_80sohj7p/format/applehttp/protocol/http/a.m3u8)")
        videoArray.append(folgersVideo)
        
        let appleStream = Video(name: "Apple Stream", urlString: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
        videoArray.append(appleStream)
        
        let oceansAES = Video(name: "Oceans AES", urlString: "http://playertest.longtailvideo.com/adaptive/oceans_aes/oceans_aes.m3u8")
        videoArray.append(oceansAES)
        
        
        return videoArray
    }
}
