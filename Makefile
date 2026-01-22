# Syllabus
PANDOC = pandoc
PDF_ENGINE = pdflatex

MAIN_FONT = TeX Gyre Pagella
MONO_FONT = Inconsolata
MARGIN = 1in
FONTSIZE = 11pt
HIGHLIGHT = tango

PANDOC_FLAGS = \
	--pdf-engine=$(PDF_ENGINE) \
	-V mainfont="$(MAIN_FONT)" \
	-V monofont="$(MONO_FONT)" \
	-V geometry:margin=$(MARGIN) \
	-V fontsize=$(FONTSIZE) \
	-V colorlinks=true \
	-V linkcolor=blue \
	--toc \
	--number-sections \
	--highlight-style=$(HIGHLIGHT)

SYL_DIR = syllabus
SYL_SRC = $(SYL_DIR)/syllabus.md
SYL_OUT = $(SYL_DIR)/syllabus.pdf

syllabus: $(SYL_OUT)

$(SYL_OUT): $(SYL_SRC)
	$(PANDOC) $(SYL_SRC) -o $(SYL_OUT) $(PANDOC_FLAGS)

clean-syllabus:
	@rm -f $(SYL_OUT)

# Books
ERROR = >&2 echo

get-latest-books:
	wget https://softwarefoundations.cis.upenn.edu/lf-current/lf.tgz -O books/lf.tgz
	wget https://softwarefoundations.cis.upenn.edu/plf-current/plf.tgz -O books/plf.tgz
	wget https://softwarefoundations.cis.upenn.edu/vc-current/vc.tgz -O books/vc.tgz
	tar -xvzf books/lf.tgz -C books
	tar -xvzf books/plf.tgz -C books
	tar -xvzf books/vc.tgz -C books

lf:
	make -C books/lf

plf:
	make -C books/plf

vc:
	$(ERROR) "VC not supported yet"

books: lf plf vc

.DEFAULT_GOAL := books

# Environment
OPAM = opam
SWITCH = rocq

setup-env:
	$(OPAM) init
	eval $($(OPAM) env)
	$(OPAM) switch create $(SWITCH) --packages rocq-prover
	eval $$($(OPAM) env --switch=$(SWITCH))
	$(OPAM) install rocqide

.PHONY: all syllabus clean-syllabus get-latest-books lf plf vc books setup-env

all: syllabus books
