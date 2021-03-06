//
//  InitialViewController.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
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
        let vc = ContatosViewController(style: .plain)
        vc.usuario = Contato(nome: preencheNome.text!, mensagens: [])
        let backItem = UIBarButtonItem()
        backItem.title = "Sair"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViews() {
        self.view.addSubviews(views: [initialBG])
        initialBG.addSubviews(views: [preencheNome, confirmar])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            initialBG.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            initialBG.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            initialBG.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            initialBG.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            
            preencheNome.centerYAnchor.constraint(equalTo: initialBG.centerYAnchor, constant: -16),
            preencheNome.centerXAnchor.constraint(equalTo: initialBG.centerXAnchor),
            preencheNome.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.5),
            preencheNome.heightAnchor.constraint(equalToConstant: 40),
            
            confirmar.topAnchor.constraint(equalTo: preencheNome.bottomAnchor, constant: 8),
            confirmar.centerXAnchor.constraint(equalTo: initialBG.centerXAnchor),
            confirmar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4),
            confirmar.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}
