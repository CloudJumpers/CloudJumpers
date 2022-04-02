//
//  RESTConstants.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

enum RESTConstants {
    // request types
    static let postRequest = "POST"
    static let getRequest = "GET"

    // status codes
    static let httpOK = 200
}

enum HTTPError: Error {
    case unexpectedStatusCode
}
