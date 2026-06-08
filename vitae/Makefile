# Build the curriculum vitæ.
#
# Content comes from the shared ../data.yaml, so the project root is set to the
# repository (one level up) — that lets `yaml("/data.yaml")` resolve. Fonts
# (TeX Gyre Pagella + Latin Modern Mono) are vendored under ./fonts so the
# build is self-contained and does not depend on a system TeX installation.

TYPST   ?= typst
SRC      = cv.typ
OUT      = cv.pdf
FONTS    = fonts
ROOT     = ..
DATA     = ../data.yaml

.PHONY: all watch clean

all: $(OUT)

$(OUT): $(SRC) template.typ render.typ $(DATA) $(wildcard $(FONTS)/*.otf)
	$(TYPST) compile --root $(ROOT) --font-path $(FONTS) $(SRC) $(OUT)

watch:
	$(TYPST) watch --root $(ROOT) --font-path $(FONTS) $(SRC) $(OUT)

clean:
	rm -f $(OUT)
