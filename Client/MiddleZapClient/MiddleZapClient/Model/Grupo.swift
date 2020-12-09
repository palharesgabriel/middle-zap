//
//  Grupo.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 08/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
//

import Foundation

class Grupo {
    let name: String
    var messages: [Mensagem]
    var members: [String]
    
    init(name: String, messages: [Mensagem], members: [String]) {
        self.name = name
        self.messages = messages
        self.members = members
    }
}
