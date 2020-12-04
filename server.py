import socket
import select
import threading
import stomp
import time

class User:
    def __init__(self, name, connection):
        self.name = name
        self.connection = connection


server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

users = []
connections = []
ip = ''
porta = 3000
server.bind((ip,porta))
server.listen()
conn = stomp.Connection()
conn.connect('admin', 'password', wait=True)

class Listener(stomp.ConnectionListener):
    def on_error(self, headers, body):
      print('Erro: "%s"' % body)
    def on_message(self, headers, body):
      print('Mensagem: "%s"' % body)
      try:
          content = body.split(':')
          receiver = list(filter(lambda user: user.name == content[1],users))
          data = body.encode()
          receiver[0].connection.send(data)
          time.sleep(2)
      except Exception as msg:
          print(msg)


conn.set_listener('listen',Listener())

def connection_handler():
    print('Servidor Aguardando Conexões')
    while True:
        inputs,_,_ = select.select(connections,[],[],2)
        for con in inputs:
            try:
                data = con.recv(2048) 
                if data:
                    data_decode = data.decode('utf-8')
                    data_handler(data_decode, con)
                else:
                    try:
                        userOff = list(filter(lambda user: user.connection == con,users))
                        for user in users:
                            user.connection.send(f'OFF:{userOff[0].name}'.encode()) 
                        connections.remove(con)
                        users.remove(userOff[0])
                        conn.unsubscribe(userOff[0].name)
                        print(f'{userOff[0].name} desconectado')
                    except Exception as msg:
                        print(msg) 

            except:
                continue

def data_handler(data: str, connection):
    content = data.split(':')
    print(content)
    if content[0] == 'JOIN':
        userOn = create_user(content[1], connection)
        try:
            conn.subscribe(destination=f'/queue/{userOn.name}',id=userOn.name,ack='auto')
        except Exception as msg:
            print(msg)
        for user in users:
            user.connection.send(f'ON:{userOn.name}'.encode())
        users.append(userOn)
        print(userOn.name + ' conectado')
    elif content[0] == 'SEND':
        try:
            filtro = list(filter(lambda user: user.name == content[2],users))
            if filtro:
                user = User(filtro[0].name,filtro[0].connection)
                send_handler(content, user)
            else:
                brokerContent = ':'.join(content[1:])
                conn.send(body=f'{brokerContent}', destination=f'/queue/{content[2]}')
                pass
            #middleware
        except Exception as msg:
            print(msg)


def create_user(name, connection):
    user = User(name,connection)
    return user 

def send_handler(content,user):
    data = ':'.join(content[1:]).encode()
    user.connection.send(data)
    print('enviou dados')
        

thr1 = threading.Thread(target=connection_handler)
thr1.start()

while True:
    connection,address = server.accept()
    connections.append(connection)
    
server.close()
conn.disconnect()

#join JOIN:NOME
#send SEND:NOME_ENVIO:NOME_RECEBE:CONTEUDO

