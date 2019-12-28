#!/bin/bash

rm -r dist/templates dist/static

cd protobufs
protoc --go_out=../backend/protobufs/ *.proto
pbjs -t static-module -w commonjs -o ../ui/src/protobufs/index.js *.proto
pbts -o ../ui/src/protobufs/index.d.ts ../ui/src/protobufs/index.js
echo -e "import * as Long from \"long\"; \n$(cat ../ui/src/protobufs/index.d.ts)" > ../ui/src/protobufs/index.d.ts
cd ..

cd backend
go build -o ../dist/backend.bin github.com/prijindal/journal_app_backend
cd ..

cp -r backend/templates dist/

cd ui
ng build --output-path="../dist/static/" --prod --aot --extract-css --optimization --base-href="/app/" --deploy-url="/app/"
cd ..
