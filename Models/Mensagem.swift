//
//  Mensagem.swift
//  Middlezap
//
//  Created by Matheus Damasceno.
//  Copyright © 2020 Matheus Damasceno. All rights reserved.
//

import Foundation

class Mensagem {
    let sender: String
    let receiver: String
    let content: String
    
    init(sender: String, receiver: String, content: String) {
        self.sender = sender
        self.receiver = receiver
        self.content = content
    }
}
