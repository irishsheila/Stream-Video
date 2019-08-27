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
        
        let folgersVideo = Video(name: "Folgers", urlString: "http://cdnbakmi.kaltura.com/p/243342/sp/24334200/playManifest/entryId/0_uka1msg4/flavorIds/1_vqhfu6uy,1_80sohj7p/format/applehttp/protocol/http/a.m3u8)", description: "A commercial from the 50s")
        videoArray.append(folgersVideo)
        
        let appleStream = Video(name: "Apple", urlString: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8", description: "Apple announces new features")
        videoArray.append(appleStream)
        
        let oceansAES = Video(name: "Oceans", urlString: "http://playertest.longtailvideo.com/adaptive/oceans_aes/oceans_aes.m3u8", description: "Disney presents its new nature film")
        videoArray.append(oceansAES)
        
        let frenchMetal = Video(name: "French Metal", urlString: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8", description: "The French music scene" )
        videoArray.append(frenchMetal)
        
        
        return videoArray
    }
}
