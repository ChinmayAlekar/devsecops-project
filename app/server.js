const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Home page
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>DevSecOps Assignment</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          max-width: 800px;
          margin: 50px auto;
          padding: 20px;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
        }
        .container {
          background: rgba(255,255,255,0.1);
          padding: 30px;
          border-radius: 10px;
          backdrop-filter: blur(10px);
        }
        h1 { margin-top: 0; }
        .info { background: rgba(0,0,0,0.2); padding: 15px; border-radius: 5px; margin-top: 20px; }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>🚀 DevSecOps Assignment - GET 2026</h1>
        <p>This application demonstrates:</p>
        <ul>
          <li>Containerization with Docker</li>
          <li>Infrastructure as Code with Terraform</li>
          <li>CI/CD Pipeline with Jenkins</li>
          <li>Security Scanning with Trivy</li>
          <li>AI-Driven Remediation</li>
        </ul>
        <div class="info">
          <strong>Deployment Info:</strong><br>
          Node.js Version: ${process.version}<br>
          Environment: ${process.env.NODE_ENV || 'production'}<br>
          Server Time: ${new Date().toLocaleString()}
        </div>
      </div>
    </body>
    </html>
  `);
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
  console.log(`Health check: http://0.0.0.0:${PORT}/health`);
});

