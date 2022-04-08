//
//  PreGameRestDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation

class PreGameRestDelegate: PreGameRequestDelegate {
    var preGameManager: PreGameManager?

    func fetchRankingsOnce(_ endpoint: String, _ callback: @escaping (Data) -> Void) {
        let url = RequestMaker.stringToURL(endpoint)
        RequestMaker.get(url, callback)
    }
}
