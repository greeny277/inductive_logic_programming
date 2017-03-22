OUTFILE=ilp.pdf

.PHONY: doc all clean

all: doc

doc: $(OUTFILE)

clean:
	rm -f $(OUTFILE)

PANDOC_TEMPLATE=template/default.tex
BIBLIOGRAPHY=ref.bib

$(OUTFILE): notizen.md
	pandoc --template=$(PANDOC_TEMPLATE)  --filter=pandoc-citeproc --csl=foo.csl --bibliography=$(BIBLIOGRAPHY) $^ -o $@
