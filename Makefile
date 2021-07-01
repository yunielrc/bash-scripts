format:
	shfmt -w .

lint:
	scripts/lint

test:
	bats -r src/
