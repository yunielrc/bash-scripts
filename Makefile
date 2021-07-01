format:
	shfmt -w .

lint:
	shfmt -d . && scripts/lint

test:
	bats -r src/

commit:
	cz commit
