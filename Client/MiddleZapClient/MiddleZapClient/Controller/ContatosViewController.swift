//
//  ContatosViewController.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.

//
import UIKit

class ContatosViewController: UICollectionViewController, ServerDelegate {
    
    var usuario: Contato?
    var contatos = [Contato]()
    var chatController: ChatViewController?
    let switchButton = UISwitch()
    
    
    override func viewDidLoad() {
        switchButton.isOn = true
        switchButton.addTarget(self, action: #selector(statusChange), for: .valueChanged)
        super.viewDidLoad()
        ServerManager.shared.delegate = self
        self.collectionView.register(ContatoCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.backgroundColor = #colorLiteral(red: 0.1957894266, green: 0.1946322322, blue: 0.196683228, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContato))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: switchButton)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Contatos do \(usuario?.nome ?? "")"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func received(message: Mensagem) {
        let contato = self.contatos.filter({ $0.nome == message.sender }).first
        if let contato = contato {
            contato.mensagens.append(message)
        } else {
            let contato = Contato(nome: message.sender, mensagens: [message])
            contato.status = true
            self.contatos.insert(contato, at: 0)
        }
        self.chatController?.table.reloadData()
        if let mensagens = contato?.mensagens.count {
            self.chatController?.table.scrollToRow(at: IndexPath(row: mensagens - 1, section: 0), at: .top, animated: true)
        }
        self.collectionView.reloadData()
    }
    
    func setStatus(status: Bool, contato: String) {
        let contato = self.contatos.filter({ $0.nome == contato }).first
        if let contato = contato {
            contato.status = status
        }
        self.collectionView.reloadData()
    }
    
    func errorHappens() {
        let alert = UIAlertController(title: "Sem conexão", message: "Ocorreu um erro, tente novamente.", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelar)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func addContato() {
        let alert = UIAlertController(title: "Adicione um Contato", message: "", preferredStyle: .alert)
        alert.addTextField { (text) in
            text.placeholder = "Nome do Contato"
        }
        
        let action = UIAlertAction(title: "Confirmar", style: .default) { (_) in
            let alertTextField = alert.textFields?[0]
            if alertTextField?.text != self.usuario?.nome {
                let contato = Contato(nome: (alertTextField?.text)!, mensagens: [])
                contato.status = true
                self.contatos.insert(contato, at: 0)
                self.collectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "Erro", message: "Você não pode se adicionar.", preferredStyle: .alert)
                let cancelar = UIAlertAction(title: "Ok", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelar)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        cancelar.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(action)
        alert.addAction(cancelar)
        
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func statusChange(_ toggle: UISwitch) {
        if toggle.isOn {
            ServerManager.shared.setupNetworkCommunication()
            ServerManager.shared.joinChat(username: (usuario?.nome)!)
        } else {
            ServerManager.shared.stopChatSession()
        }
    }
    
    // MARK: - Table view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contatos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ContatoCell else {return UICollectionViewCell()}
        cell.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        cell.nome.text = contatos[indexPath.item].nome
        cell.mensagem.text = contatos[indexPath.item].mensagens.count == 0 ? "Sem mensagens" : contatos[indexPath.row].mensagens.last?.content
        cell.status.backgroundColor = contatos[indexPath.item].status == true ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) : #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatViewController()
        self.chatController = vc
        vc.contato = contatos[indexPath.item]
        vc.myself = usuario
        vc.controller = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ContatosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
