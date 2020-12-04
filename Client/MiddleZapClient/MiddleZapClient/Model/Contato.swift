//
//  Contato.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
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
