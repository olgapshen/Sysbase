import socket
import sys

if len(sys.argv) != 3:
    print("Usage: port_test.py <IP> <PORT>")
    exit(1)

print("Check port")

ip = sys.argv[1]
port = int(sys.argv[2])

print("IP:\t" + ip)
print("PORT:\t" + str(port))

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
result = sock.connect_ex((ip, port))

if result == 0:
    print("Port is open")
else:
    print("Port is not open")

sock.close()
