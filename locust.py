from locust import User, task, between
import socket

class TcpUser(User):
    wait_time = between(1, 5)  # Add your desired wait time

    @task
    def tcp_request(self):
        try:
            # Replace with the IP address and port of your EKS service
            host = "your-app.internal-service.namespace.svc.cluster.local"
            port = 12345

            # Create a TCP socket and establish a connection
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((host, port))
                # Customize the data you send here
                s.sendall(b"Hello, TCP server!")
                response = s.recv(1024)
        except Exception as e:
            self.environment.runner.quit()

