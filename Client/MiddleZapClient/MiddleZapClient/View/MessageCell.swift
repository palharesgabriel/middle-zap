//
//  MessageCell.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let bubbleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sender: UILabel = {
        let label = UILabel()
        label.text = "Matheus"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mensagem: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let horario: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        label.text = dateFormatter.string(from: Date())
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(bubbleBackground)
        bubbleBackground.addSubviews(views: [sender,mensagem,horario])
    }
    
    lazy var leftConstraint =  bubbleBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
    lazy var rightConstraint = bubbleBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    
    var isMeSending = true {
        didSet {
            if isMeSending {
                rightConstraint.isActive = true
                leftConstraint.isActive = false
                bubbleBackground.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            } else {
                rightConstraint.isActive = false
                leftConstraint.isActive = true
                bubbleBackground.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bubbleBackground.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            bubbleBackground.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.8),
            bubbleBackground.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            
            sender.topAnchor.constraint(equalTo: bubbleBackground.topAnchor, constant: 3),
            sender.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -3),
            sender.leadingAnchor.constraint(equalTo: bubbleBackground.leadingAnchor, constant: 8),
            
            mensagem.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: 3),
            mensagem.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -8),
            mensagem.leadingAnchor.constraint(equalTo:  bubbleBackground.leadingAnchor, constant: 8),
            mensagem.bottomAnchor.constraint(equalTo: horario.topAnchor, constant: -3),
            
            horario.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -3),
            horario.widthAnchor.constraint(equalToConstant: 30),
            horario.bottomAnchor.constraint(equalTo: bubbleBackground.bottomAnchor, constant: -3)
              
        
        ])
    }
}
