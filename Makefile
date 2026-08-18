.DEFAULT_GOAL := help

PROJECTS := $(sort $(patsubst %/,%,$(dir $(wildcard */.latexmkrc))))
LATEXINDENT_CONF := $(CURDIR)/.latexindent.yaml
NBCONVERT_TEMPLATE_DIR := $(CURDIR)/templates/nbconvert
JUPYTER := $(CURDIR)/.venv/bin/jupyter

.PHONY: help build watch clean clean-all new fmt fmt-all nb-pdf

help:
	@echo "Usage:"
	@echo "  make build DIR=assignment-06   Build a single project with latexmk"
	@echo "  make watch DIR=assignment-06   Build and rebuild on save (latexmk -pvc)"
	@echo "  make clean DIR=assignment-06   Remove build artifacts for one project"
	@echo "  make clean-all                 Remove build artifacts for every project"
	@echo "  make new NAME=assignment-07    Scaffold a new assignment folder from templates/"
	@echo "  make fmt DIR=assignment-06     Format one project's .tex files in place"
	@echo "  make fmt-all                   Format every project's .tex files in place"
	@echo "  make nb-pdf NB=assignment-01/code/assignment-01.ipynb"
	@echo "                                  Export a notebook to PDF styled with CEDT-Assignment-style"

build:
	@test -n "$(DIR)" || (echo "Usage: make build DIR=assignment-06" >&2 && exit 1)
	@test -d "$(DIR)" || (echo "No such directory: $(DIR)" >&2 && exit 1)
	cd "$(DIR)" && latexmk

watch:
	@test -n "$(DIR)" || (echo "Usage: make watch DIR=assignment-06" >&2 && exit 1)
	@test -d "$(DIR)" || (echo "No such directory: $(DIR)" >&2 && exit 1)
	cd "$(DIR)" && latexmk -pvc

clean:
	@test -n "$(DIR)" || (echo "Usage: make clean DIR=assignment-06" >&2 && exit 1)
	@test -d "$(DIR)" || (echo "No such directory: $(DIR)" >&2 && exit 1)
	cd "$(DIR)" && latexmk -C

clean-all:
	@for d in $(PROJECTS); do \
		echo "Cleaning $$d"; \
		(cd "$$d" && latexmk -C); \
	done

new:
	@test -n "$(NAME)" || (echo "Usage: make new NAME=assignment-07" >&2 && exit 1)
	./new-assignment.sh "$(NAME)"

fmt:
	@test -n "$(DIR)" || (echo "Usage: make fmt DIR=assignment-06" >&2 && exit 1)
	@test -d "$(DIR)" || (echo "No such directory: $(DIR)" >&2 && exit 1)
	@mkdir -p "$(DIR)/.build"
	latexindent -w -s -c "$(DIR)/.build/" -l="$(LATEXINDENT_CONF)" "$(DIR)"/*.tex

fmt-all:
	@for d in $(PROJECTS); do \
		echo "Formatting $$d"; \
		mkdir -p "$$d/.build"; \
		latexindent -w -s -c "$$d/.build/" -l="$(LATEXINDENT_CONF)" "$$d"/*.tex; \
	done
