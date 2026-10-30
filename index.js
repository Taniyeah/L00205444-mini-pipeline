const express = require('express');
const client = require('prom-client');

const app = express();
const PORT = process.env.PORT || 3000;

// Collect default metrics (memory, CPU, etc.)
client.collectDefaultMetrics();

// Custom metric: count every HTTP request
const httpRequests = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status']
});

// Record each request after the response is sent
app.use((req, res, next) => {
  res.on('finish', () => {
    httpRequests.inc({ method: req.method, route: req.path, status: res.statusCode });
  });
  next();
});

app.get('/', (req, res) => {
  res.send('Hello from my mini DevOps pipeline! v4');
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Prometheus reads this page
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

if (require.main === module) {
  app.listen(PORT, () => console.log(`Listening on port ${PORT}`));
}

module.exports = app;
