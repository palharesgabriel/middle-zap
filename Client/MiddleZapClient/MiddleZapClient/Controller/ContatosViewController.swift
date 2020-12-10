//
//  ContatosViewController.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.

//
import UIKit

class ContatosViewController: UITableViewController, ServerDelegate {
    
    var usuario: Contato?
    var contatos = [Contato]()
    var grupos = [Grupo]()
    var chatController: ChatViewController?
    let switchButton = UISwitch()
    
    override func viewDidLoad() {
        switchButton.isOn = true
        switchButton.addTarget(self, action: #selector(statusChange), for: .valueChanged)
        super.viewDidLoad()
        ServerManager.shared.delegate = self
        self.tableView.register(ContatoCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = #colorLiteral(red: 0.1957894266, green: 0.1946322322, blue: 0.196683228, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChat))
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "\(usuario?.nome ?? "")"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func received(message: Mensagem) {
        
        if message.sender == "SENDTP" {
            let group = self.grupos.filter({ $0.name == message.receiver }).first
            if let group = group {
                group.messages.append(message)
            } else {
                let group = Grupo(name: message.receiver, messages: [message], members: [])
                self.grupos.insert(group, at: 0)
            }
            
            self.chatController?.table.reloadData()
            if let mensagens = group?.messages.count {
                self.chatController?.table.scrollToRow(at: IndexPath(row: mensagens - 1, section: 0), at: .top, animated: true)
            }
            self.tableView.reloadData()
            
        } else {
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
            self.tableView.reloadData()
            
        }
    }
    
    func setStatus(status: Bool, contato: String) {
        let contato = self.contatos.filter({ $0.nome == contato }).first
        if let contato = contato {
            contato.status = status
        }
        self.tableView.reloadData()
    }
    
    func errorHappens() {
        let alert = UIAlertController(title: "Sem conexão", message: "Ocorreu um erro, tente novamente.", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelar)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func addChat() {
        let mainAlert = UIAlertController(title: "Que tipo de chat deseja adicionar?", message: "", preferredStyle: .alert)
        
        let individual = UIAlertAction(title: "Individual", style: .default) { (_) in
            let alert = self.createAddContactAlert()
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        
        let group = UIAlertAction(title: "Grupo", style: .default) { (_) in
            let alert = self.createAddGroupAlert()
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        mainAlert.addAction(individual)
        mainAlert.addAction(group)
        self.navigationController?.present(mainAlert, animated: true, completion: nil)
    }
    
    @objc func statusChange(_ toggle: UISwitch) {
        if toggle.isOn {
            ServerManager.shared.setupNetworkCommunication()
            ServerManager.shared.joinChat(username: (usuario?.nome)!)
        } else {
            ServerManager.shared.stopChatSession()
        }
    }
    
    private func createAddGroupAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Adicione um Grupo", message: "", preferredStyle: .alert)
        alert.addTextField { (text) in
            text.placeholder = "Nome do Grupo"
        }
        
        let action = UIAlertAction(title: "Confirmar", style: .default) { (_) in
            let alertTextField = alert.textFields?[0]
            let groupName = (alertTextField?.text)!
            let group = Grupo(name: groupName, messages: [], members: [])
            self.grupos.insert(group, at: 0)
            ServerManager.shared.subscribe(in: groupName, username: self.usuario!.nome)
            self.tableView.reloadData()
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        cancelar.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(action)
        alert.addAction(cancelar)
        
        return alert
    }
    
    private func createAddContactAlert() -> UIAlertController {
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
                self.tableView.reloadData()
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
        
        return alert
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contatos.count
        } else {
            return grupos.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContatoCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            cell.nome.text = contatos[indexPath.row].nome
            cell.mensagem.text = contatos[indexPath.row].mensagens.count == 0 ? "Sem mensagens" : contatos[indexPath.row].mensagens.last?.content
            cell.status.backgroundColor = contatos[indexPath.row].status == true ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) : #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            cell.nome.text = grupos[indexPath.row].name
            cell.mensagem.text = grupos[indexPath.row].messages.count == 0 ? "Sem mensagens" : grupos[indexPath.row].messages.last?.content
            cell.status.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        self.chatController = vc
        vc.myself = usuario
        vc.controller = self
        if indexPath.section == 0 {
            vc.contato = contatos[indexPath.row]
        } else {
            vc.group = grupos[indexPath.item]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 30
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return switchButton
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = TitleView()
        
        switch section {
        case 0:
            titleView.set(text: "Contatos")
        case 1:
            titleView.set(text: "Grupos")
        default:
            titleView.set(text: "Grupos")
        }
        
        return titleView
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                contatos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                grupos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
}
