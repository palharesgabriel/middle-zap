//
//  InitialViewController.swift
//  Middlezap
//
//  Created by Matheus Damasceno.
//  Copyright © 2020 Matheus Damasceno. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, ServerDelegate {
    func received(message: Mensagem) {}
    
    func setStatus(status: Bool, contato: String) {}
    
    var statusConnection: Bool = true {
        didSet {
            self.confirmar.isEnabled = self.statusConnection
            self.confirmar.backgroundColor = self.statusConnection ? #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    func errorHappens() {
        let alert = UIAlertController(title: "Sem conexão", message: "Ocorreu um erro, tente novamente.", preferredStyle: .alert)
        let retry = UIAlertAction(title: "Tente novamente", style: .default) { (_) in
            if ServerManager.shared.setupNetworkCommunication() {
                self.statusConnection = true
            }
        }
        alert.addAction(retry)
        self.navigationController?.present(alert, animated: true, completion: nil)
        statusConnection = false
    }
    
    let imagem: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "friends"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let initialBG: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let preencheNome: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 3
        text.tintColor = .lightGray
        text.textColor = .lightGray
        text.backgroundColor = .darkGray
        text.placeholder = "Digite seu Nome"
        text.font = .systemFont(ofSize: 15, weight: .bold)
        text.attributedPlaceholder = NSAttributedString(string:"Digite seu nome", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return text
    }()
    
    lazy var confirmar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CONFIRMAR", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        button.addTarget(self, action: #selector(conectar), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1957894266, green: 0.1946322322, blue: 0.196683228, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .black
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ServerManager.shared.setupNetworkCommunication()
        ServerManager.shared.delegate = self
    }
    
    @objc func conectar() {
        ServerManager.shared.joinChat(username: preencheNome.text ?? "")
        let vc = ContatosViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.usuario = Contato(nome: preencheNome.text!, mensagens: [])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViews() {
        self.view.addSubviews(views: [initialBG, imagem])
        initialBG.addSubviews(views: [preencheNome, confirmar])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagem.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            imagem.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            imagem.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            imagem.bottomAnchor.constraint(equalTo: self.initialBG.topAnchor, constant: -16),
            
            initialBG.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 24),
            initialBG.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            initialBG.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.8),
            initialBG.heightAnchor.constraint(equalToConstant: 100),
            
            preencheNome.topAnchor.constraint(equalTo: initialBG.topAnchor, constant: 16),
            preencheNome.centerXAnchor.constraint(equalTo: initialBG.centerXAnchor),
            preencheNome.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5),
            preencheNome.heightAnchor.constraint(equalToConstant: 30),
            
            confirmar.topAnchor.constraint(equalTo: preencheNome.bottomAnchor, constant: 8),
            confirmar.centerXAnchor.constraint(equalTo: initialBG.centerXAnchor),
            confirmar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4),
            confirmar.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    

}
