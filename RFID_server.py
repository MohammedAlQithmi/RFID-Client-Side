import socket
import os
import subprocess
import json
import requests
import time

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

def server():
	serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	serversocket.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
	ipAddress = get_ip()
	print(ipAddress)# From here we can grt the IPv4 for the server automaticly
	serversocket.bind((ipAddress, 8089))  # bound the socket to ipAddress
	serversocket.listen(1)
	connections, address = serversocket.accept()  # Here we will wait for new connection (ip,port)
	connection = connections.recv(4096)  # how many byte we will accept
	receivedData = connection.decode()
	print(receivedData)
	firstIndex=receivedData.find("payload: ")
	print(firstIndex)
	lastIndex=receivedData.find("]",firstIndex)
	print(lastIndex)
	payload=receivedData[firstIndex+10:lastIndex]
	print(payload)
	payloadList=payload.split(',')
	Username=""
	for ascii in payloadList:
		Username+=chr(int(ascii))

	print(Username[3:])
	serversocket.close()
	rfidHandeler(Username[3:])

def rfidHandeler(Username):
	URL= "http://178.62.33.8:8888/userfile/"+Username
	r = requests.get(URL)
	a_file = open("user.ovpn", "w")
	a_file.writelines(r.text)
	a_file.close()
	#os.system("openvpn user.ovpn")
	subprocess.Popen("openvpn user.ovpn", shell=True)
	time.sleep(5)
	os.remove("user.ovpn")
	#server()

server()


