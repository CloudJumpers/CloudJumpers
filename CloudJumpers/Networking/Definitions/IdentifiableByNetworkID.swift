//
//  IdentifiableByUUID.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import Foundation

typealias NetworkID = String

protocol IdentifiableByNetworkID {
    var id: NetworkID { get }
}
