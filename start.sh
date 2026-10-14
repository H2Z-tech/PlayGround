#!/usr/bin/env bash
set -euo pipefail
time -p cd "$(dirname "$0")"
time -p mkdir -p dist
if time -p test -f package.json; then
  time -p npm install --no-audit --no-fund
  time -p npm run --silent build --if-present
fi
time -p test -f dist/index.html
PROJECT_ROOT="$PWD"
time -p printf '%s' "$PROJECT_ROOT"
time -p printf '\n'
DIST_DIR="$PROJECT_ROOT/dist"
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
time -p mkdir -p "$WEB_DIR"
time -p node -e 'require("fs").writeFileSync(process.argv[1], JSON.stringify({project: process.argv[2], directory: process.argv[3]}))' "$WEB_DIR/deployment-output.json" "$PROJECT_ROOT" "$DIST_DIR"
time -p cat "$WEB_DIR/deployment-output.json"
time -p printf '\n'
PORT="${PORT:-3000}"
export PORT DIST_DIR
time -p node -e 'const http=require("http"),fs=require("fs"),path=require("path");const root=process.env.DIST_DIR,port=Number(process.env.PORT||3000);const mime={".html":"text/html",".js":"application/javascript",".css":"text/css",".json":"application/json",".svg":"image/svg+xml",".png":"image/png",".jpg":"image/jpeg",".webp":"image/webp"};http.createServer((req,res)=>{try{const u=new URL(req.url,"http://localhost");let p=path.resolve(root,"."+decodeURIComponent(u.pathname));if(p!==path.resolve(root)&&!p.startsWith(path.resolve(root)+"/")){res.writeHead(404);res.end();return}try{if(fs.statSync(p).isDirectory())p=path.join(p,"index.html")}catch{p=path.join(root,"index.html")}res.setHeader("Content-Type",mime[path.extname(p)]||"application/octet-stream");res.setHeader("Cache-Control","no-cache");res.end(fs.readFileSync(p))}catch{res.writeHead(404);res.end("Not found")}}).listen(port,"0.0.0.0",()=>console.log("Serving "+root+" on "+port))'
