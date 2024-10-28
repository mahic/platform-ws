const express = require('express');
const app = express();

app.get('/', (req, res) => { res.send('Hello platform.local!'); });

const https = require('https');
const fs = require('fs');

const httpsServer = https.createServer({
  key: fs.readFileSync('./platform.local.key'),
  cert: fs.readFileSync('./platform.local.crt'),
}, app);

httpsServer.listen(443, () => {
    console.log('HTTPS Server running on port 443');
});