//
//  Ranking.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

struct IndividualRanking {
    /*
     primaryFields represent the gamemode dependent list of fields
     associated with this ranking entry. E.g. time taken, number of kills
     will all be stored as key value pairs.
     */
    private(set) var primaryFields: [PostGameColumnKey: String]

    /*
     supportingFields contain fields that are used for purposes other than
     text displayed to the user. For example, fields that determine order,
     fields that provides other identifying information.
     */
    private(set) var supportingFields: [String: String]

    private var keys: [PostGameColumnKey] {
        primaryFields.keys.sorted(by: { $0.order < $1.order })
    }

    var columnNames: [String] {
        keys.map { $0.description }
    }

    var values: [String] {
        keys.compactMap { primaryFields[$0]?.description }
    }

    init() {
        self.primaryFields = [:]
        self.supportingFields = [:]
    }

    mutating func setPrimaryField<T: CustomStringConvertible>(colName: String, value: T) {
        let key = PostGameColumnKey(order: primaryFields.count + 1, description: colName)
        primaryFields[key] = value.description
    }

    mutating func setSupportingField<T: CustomStringConvertible>(colName: String, value: T) {
        supportingFields[colName] = value.description
    }
}
