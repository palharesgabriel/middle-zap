//
//  ChatViewController.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contato?.mensagens.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        cell.mensagem.text = contato?.mensagens[indexPath.row].content
        cell.sender.text = contato?.mensagens[indexPath.row].sender
        cell.isMeSending = cell.sender.text == myself?.nome
        cell.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        return cell
    }
    
    var contato: Contato?
    var myself: Contato?
    var controller: ContatosViewController?
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let text: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        text.backgroundColor = #colorLiteral(red: 0.9271296003, green: 0.9271296003, blue: 0.9271296003, alpha: 1)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 10
        return text
    }()
    
    let send: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = contato?.nome
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        table.register(MessageCell.self, forCellReuseIdentifier: "cell")
        setupViews()
        setupConstraints()
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func sendMessage() {
        if text.text != "" {
            let mensagem = Mensagem(sender: myself!.nome, receiver: contato!.nome, content: text.text ?? "")
            let data = "SEND:\(mensagem.sender):\(mensagem.receiver):\(mensagem.content)".data(using: .utf8)
            ServerManager.shared.send(data: data!)
            contato?.mensagens.append(mensagem)
            myself?.mensagens.append(mensagem)
            table.reloadData()
            controller?.collectionView.reloadData()
            let index = IndexPath(row: (contato?.mensagens.count)! - 1, section: 0)
            table.scrollToRow(at: index, at: .top, animated: true)
            text.text = ""
        }
    }
    
    func setupViews() {
        view.addSubviews(views: [table,footerView])
        footerView.addSubviews(views: [text,send])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: self.view.topAnchor),
            table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50),
            
            send.heightAnchor.constraint(equalToConstant: 30),
            send.widthAnchor.constraint(equalToConstant: 30),
            send.bottomAnchor.constraint(equalTo: self.footerView.bottomAnchor, constant: -8),
            send.trailingAnchor.constraint(equalTo: self.footerView.trailingAnchor, constant: -5),
            
            text.heightAnchor.constraint(equalToConstant: 30),
            text.bottomAnchor.constraint(equalTo: self.footerView.bottomAnchor, constant: -8),
            text.leadingAnchor.constraint(equalTo: self.footerView.leadingAnchor, constant: 8),
            text.trailingAnchor.constraint(equalTo: send.leadingAnchor, constant: -8)
        ])
    }
    
}
