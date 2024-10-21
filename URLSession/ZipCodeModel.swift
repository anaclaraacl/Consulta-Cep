//
//  ZipCodeModel.swift
//  URLSession
//
//  Created by COTEMIG on 23/09/24.
//

import Foundation

struct ZipCodeModel: Codable {
    let zipCode: String
    let publicPlace: String
    let locality: String
    let neighborhood: String
    let uf: String
    let ddd: String
    
    enum CodingKeys: String, CodingKey {
        case zipCode = "cep"
        case publicPlace = "logradouro"
        case neighborhood = "bairro"
        case locality = "localidade"
        case uf
        case ddd
    }
}
