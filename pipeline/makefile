#
# Flowmotion
# Pipeline
# Makefile
#

BLACK:=black
ISORT:=isort
RUFF:=ruff

.PHONY: all fmt lint test
	

all: fmt lint test

fmt:
	$(BLACK) .
	$(ISORT) .
	
lint:
	$(BLACK) --check .
	$(ISORT) --check .
	$(RUFF) check .

test:
	pytest
