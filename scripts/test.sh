#!/bin/bash

cd protobufs
protoc --go_out=../backend/protobufs/ --dart_out=../frontend/lib/protobufs/ *.proto
pbjs -t static-module -w commonjs -o ../ui/src/protobufs/index.js *.proto
pbts -o ../ui/src/protobufs/index.d.ts ../ui/src/protobufs/index.js
echo -e "import * as Long from \"long\"; \n$(cat ../ui/src/protobufs/index.d.ts)" > ../ui/src/protobufs/index.d.ts
cd ..

cd backend
golint ./
mkdir -p coverage
go test -coverprofile=coverage/coverage.out
go tool cover -html=coverage/coverage.out -o coverage/coverage.html
cd ..

cd ui
ng lint
ng test --browsers ChromeHeadless --watch=false --code-coverage
cd ..

cd frontend
flutter analyze
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
cd ..