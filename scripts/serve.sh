#!/bin/bash

cd protobufs
protoc --go_out=../backend/protobufs/ *.proto
pbjs -t static-module -w commonjs -o ../ui/src/protobufs/index.js *.proto
pbts -o ../ui/src/protobufs/index.d.ts ../ui/src/protobufs/index.js
echo -e "import * as Long from \"long\"; \n$(cat ../ui/src/protobufs/index.d.ts)" > ../ui/src/protobufs/index.d.ts
cd ..

cd backend
gin --port 4201 --appPort 4001 --path . --build . --i --all &
cd ..

cd ui
ng serve --base-href="/app/" --deploy-url="/app/"
cd ..

cd frontend
cd ..

wait
