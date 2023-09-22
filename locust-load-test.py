from locust import HttpUser, task, between
import socket

# Define your target application details (replace with actual values)
apps = [
    {"name": "App1", "host": "app1.internal-service.namespace.svc.cluster.local", "port": 12345},
    {"name": "App2", "host": "app2.internal-service.namespace.svc.cluster.local", "port": 12346},
    # Add more apps with their respective host and port information
]

class TcpUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def tcp_request(self):
        for app in apps:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((app["host"], app["port"]))
                # Customize the data you send here
                s.sendall(b"Hello, TCP server!")
                response = s.recv(1024)
                # Check the response if needed

# Additional user classes for different applications can be defined similarly
