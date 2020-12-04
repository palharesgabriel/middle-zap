//
//  Contato.swift
//  Middlezap
//
//  Created by Matheus Damasceno.
//  Copyright © 2020 Matheus Damasceno. All rights reserved.
//

import Foundation

class Contato {
    let nome: String
    var mensagens: [Mensagem]
    var status: Bool?
    
    init(nome: String, mensagens: [Mensagem]) {
        self.nome = nome
        self.mensagens = mensagens
    }
}
