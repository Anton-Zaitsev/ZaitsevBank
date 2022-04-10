//
//  RequestResult.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 09.04.2022.
//

import Foundation
import CommonCrypto
public enum RequestResult:Int {
    case OK = 200
    case NotFound = 404
    case EthernalServer = 500
    case NotCreate = 412
    case BadRequest = 401
    
}

