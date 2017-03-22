OUTFILE=out.pdf

.PHONY: doc

doc: $(OUTFILE)

PANDOC_TEMPLATE=template/default.tex
BIBLIOGRAPHY=ref.bib

$(OUTFILE): notizen.md
	pandoc --template=$(PANDOC_TEMPLATE)  --filter=pandoc-citeproc --csl=foo.csl --bibliography=$(BIBLIOGRAPHY) $^ -o doc.pdf
