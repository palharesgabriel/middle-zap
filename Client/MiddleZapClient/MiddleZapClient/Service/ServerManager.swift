//
//  ServerManager.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
//

import Foundation

protocol ServerDelegate: class {
    func received(message: Mensagem)
    func setStatus(status: Bool, contato: String)
    func errorHappens()
}

class ServerManager: NSObject {
    
    static let shared = ServerManager()
    
    weak var delegate: ServerDelegate?
    
    private override init() {
        super.init()
    }
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    var ipHost = "localhost"
    var porta = UInt32(3000)
    let maxReadLenght = 2048
    
    @discardableResult
    func setupNetworkCommunication() -> Bool {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           ipHost as CFString,
                                           porta,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
        
        return true
    }
    
    func subscribe(in topic: String, username: String) {
        let data = "SUB:\(username):\(topic)".data(using: .utf8)!
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func joinChat(username: String) {
        let data = "JOIN:\(username)".data(using: .utf8)!
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func send(data: Data) {
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
    
}

extension ServerManager: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            stopChatSession()
        case .errorOccurred:
            delegate?.errorHappens()
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLenght)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLenght)
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                delegate?.received(message: message)
            }
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> Mensagem? {
        guard let stringArray = String(
            bytesNoCopy: buffer,
            length: length,
            encoding: .utf8,
            freeWhenDone: true)?.components(separatedBy: ":")
            else { return nil }
        
        guard stringArray.count > 2 else {
            if stringArray.first == "ON" {
                delegate?.setStatus(status: true, contato: stringArray[1])
            } else if stringArray.first == "OFF" {
                delegate?.setStatus(status: false, contato: stringArray[1])
            } else {
                delegate?.errorHappens()
            }
            return nil
        }
        
        if stringArray.contains("SENDTP") {
            return Mensagem(sender: stringArray[1], receiver: stringArray[2], content: stringArray[3], code: stringArray[0])
        } else {
            return Mensagem(sender: stringArray[0], receiver: stringArray[1], content: stringArray[2])
        }
    }
}
