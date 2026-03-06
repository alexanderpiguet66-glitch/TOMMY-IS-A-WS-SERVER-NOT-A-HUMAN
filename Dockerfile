FROM node:18-alpine

WORKDIR /app

RUN npm install http-proxy

EXPOSE 3000

CMD ["node", "-e", "\
const http = require('http');\
const httpProxy = require('http-proxy');\
const proxy = httpProxy.createProxyServer({ ws: true, secure: false });\
const server = http.createServer((req, res) => { res.writeHead(200); res.end('Phantom WS Proxy'); });\
server.on('upgrade', (req, socket, head) => {\
  const apiKey = new URL(req.url, 'http://localhost').searchParams.get('apiKey');\
  req.headers['origin'] = 'https://google.com';\
  req.headers['user-agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';\
  proxy.ws(req, socket, head, { target: 'wss://connect.steel.dev?apiKey=' + apiKey, changeOrigin: true, headers: { origin: 'https://google.com' } });\
});\
server.listen(process.env.PORT || 3000, () => console.log('Proxy running'));\
"]
