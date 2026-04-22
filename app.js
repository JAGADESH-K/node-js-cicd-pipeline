const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.status(200).send('Hello World! The CI/CD Pipeline is working fine.');
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
  });
}

module.exports = app;
