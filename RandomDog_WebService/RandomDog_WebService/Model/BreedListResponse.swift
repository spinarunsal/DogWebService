//
//  BreedListResponse.swift
//  RandomDog_WebService
//
//  Created by Pinar Unsal on 2021-05-07.
//

import Foundation

struct BreedListResponse: Codable {
    let status: String
    let message: [String:[String]]
}
