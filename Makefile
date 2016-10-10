OUTFILE=out.pdf

.PHONY: doc

doc: $(OUTFILE)

PANDOC_TEMPLATE=doc/template/default.tex
BIBLIOGRAPHY=doc/ref.bib

$(OUTFILE): doc/notizen.md
	pandoc --template=$(PANDOC_TEMPLATE) --filter=pandoc-citeproc --bibliography=$(BIBLIOGRAPHY) $^ -o doc/doc.pdf
