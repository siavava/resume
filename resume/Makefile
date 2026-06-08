# Build the résumé.
#
# Reads the shared ../data.yaml (project root set to the repository) and uses
# the lavandula template. Fonts (Fira Sans + Font Awesome 7 Desktop) are
# vendored under ./fonts so the build is self-contained.

TYPST   ?= typst
SRC      = resume.typ
OUT      = resume.pdf
FONTS    = fonts
ROOT     = ..
DATA     = ../data.yaml

.PHONY: all watch clean

all: $(OUT)

$(OUT): $(SRC) $(DATA)
	$(TYPST) compile --root $(ROOT) --font-path $(FONTS) $(SRC) $(OUT)

watch:
	$(TYPST) watch --root $(ROOT) --font-path $(FONTS) $(SRC) $(OUT)

clean:
	rm -f $(OUT)
