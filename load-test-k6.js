import { check, sleep, group } from 'k6';
import { Trend, Rate } from 'k6/metrics';
import tcp from 'k6/net/tcp';

const responseTimeTrend = new Trend('response_time');
const errorRate = new Rate('errors');

const apps = [
  {
    name: 'App1',
    host: 'app1.internal-service.namespace.svc.cluster.local', // Replace with the correct internal DNS name
    port: 12345, // Replace with the correct port
  },
  // Add more apps with their respective host and port information
  {
    name: 'App2',
    host: 'app2.internal-service.namespace.svc.cluster.local',
    port: 12346,
  },
  // Add more apps as needed
];

export let options = {
  vus: 10, // Number of virtual users (concurrent connections)
  duration: '30s', // Duration of the test
};

export default function () {
  for (const app of apps) {
    group(app.name, () => {
      const startTime = new Date().getTime();

      const conn = tcp.connect(app.host, app.port, { tls: false });

      if (conn) {
        const endTime = new Date().getTime();
        const responseTime = endTime - startTime;
        responseTimeTrend.add(responseTime);

        // Simulate some interaction with the application (e.g., send/receive data)
        // Replace this with your application-specific logic

        conn.close();

        // Check if the interaction was successful (customize this based on your app's response)
        check(conn, {
          'TCP request successful': (r) => r,
        });
      } else {
        errorRate.add(1);
      }
    });

    // Simulate user think time (adjust as needed)
    sleep(1); // Sleep for 1 second between requests to different apps
  }
}
