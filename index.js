// 1) Instrumentation (Prometheus client)
const client = require('prom-client');
// Create a Registry which registers the metrics
const register = new client.Registry();

// Enable collection of default metrics (CPU/memory/etc.)
client.collectDefaultMetrics({
  register,
  // (optional) you can set a prefix, e.g. prefix: 'devops_demo_'
});

// Create a custom counter for every request
const requestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});
// Register your custom metric
register.registerMetric(requestCounter);



// 2) Express setup
const express = require('express');
const app = express();

app.set('port', process.env.PORT || 8080);
app.use(express.static(__dirname + '/public'));

// 3) Middleware to count each request
app.use((req, res, next) => {
  const end = res.end;
  res.end = function (chunk, encoding) {
    // Increment your counter when the response finishes
    requestCounter
      .labels(req.method, req.route ? req.route.path : req.path, res.statusCode)
      .inc();
    return end.call(this, chunk, encoding);
  };
  next();
});

// 4) Your existing routes
app.get('/', (req, res) => {
  res.send('Hello World!');
});
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// 5) Metrics endpoint—Prometheus will scrape this
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// 6) Start the server
app.listen(app.get('port'), () => {
  console.log(`Node app is running at localhost:${app.get('port')}`);
});
