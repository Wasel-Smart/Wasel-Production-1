const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
    if (req.url === '/' || req.url === '/index.html') {
        fs.readFile(path.join(__dirname, 'index.html'), 'utf-8', (err, data) => {
            if (err) {
                console.error('Error reading index.html:', err);
                res.writeHead(500);
                res.end('Error loading page');
                return;
            }
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            res.end(data);
        });
    } else {
        res.writeHead(404);
        res.end('Page not found');
    }
});

const PORT = process.env.PORT || 8081;

if (require.main === module) {
    server.listen(PORT, () => {
        console.log(`Wasel Production - Server running on port ${PORT}`);
    });
}

module.exports = server;