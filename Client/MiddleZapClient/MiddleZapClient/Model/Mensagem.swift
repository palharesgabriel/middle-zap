//
//  Mensagem.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
//

import Foundation

class Mensagem {
    let code: String?
    let sender: String
    let receiver: String
    let content: String
    
    init(sender: String, receiver: String, content: String, code: String? = nil) {
        self.sender = sender
        self.receiver = receiver
        self.content = content
        self.code = code
    }
}
