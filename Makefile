default: build

build-codemirror:
	cd ./Sources/CodeMirror/src && npm install && ./node_modules/.bin/rollup -c

open-codemirror:
	open ./Sources/CodeMirror/src/build/index.html

build-swift:
	swift build -v

clean:
	swift package clean

build: build-codemirror build-swift

format:
	swift-format --in-place --recursive --configuration ./.swift-format.json ./

.PHONY: clean test format build-codemirror open-codemirror