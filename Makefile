default: test

build-codemirror:
	cd ./Sources/CodeMirror/src && ./node_modules/.bin/rollup -c

open-codemirror:
	open ./Sources/CodeMirror/src/build/index.html

clean:
	swift package clean

test:
	swift test

format:
	find . -type f -name "*.swift" -not -path '*/Package.swift' -exec sed -i '' -e '1,/^import/{/^\/\/.*/d;}' -e '/./,$$!d' {} \;
	swift-format --in-place --recursive --configuration ./.swift-format.json ./

.PHONY: clean test format build-codemirror open-codemirror
