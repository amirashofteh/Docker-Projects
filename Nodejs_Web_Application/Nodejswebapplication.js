const http = require('http');

const hostname = '0.0.0.0';
const port = 3002;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Im nodejs running inside Docker!!!');
});

server.listen(port, hostname, () => {
  console.log('Server running at http://${hostname}:${port}/');
}); 
