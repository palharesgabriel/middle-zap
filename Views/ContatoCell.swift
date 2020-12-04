//
//  ContatoCell.swift
//  Middlezap
//
//  Created by Matheus Damasceno.
//  Copyright © 2020 Matheus Damasceno. All rights reserved.
//

import UIKit

class ContatoCell: UICollectionViewCell {
    let avatar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nome: UILabel = {
        let label = UILabel()
        label.text = "Eddie Lobanovskiy"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mensagem: UILabel = {
        let label = UILabel()
        label.text = "Sem mensagens"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let status: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.layer.cornerRadius = 10
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubviews(views: [avatar, nome, mensagem, status])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 40),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            
            nome.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            nome.topAnchor.constraint(equalTo: self.topAnchor,constant: 16),
            nome.heightAnchor.constraint(equalToConstant: 20),
            nome.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            mensagem.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            mensagem.topAnchor.constraint(equalTo: nome.bottomAnchor,constant: 3),
            mensagem.heightAnchor.constraint(equalToConstant: 15),
            mensagem.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            status.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16),
            status.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: -8),
            status.heightAnchor.constraint(equalToConstant: 14),
            status.widthAnchor.constraint(equalToConstant: 14),
        ])
        
    }
    
}
