OUTFILE=out.pdf

.PHONY: doc

doc: $(OUTFILE)

PANDOC_TEMPLATE=template/default.tex
BIBLIOGRAPHY=ref.bib

$(OUTFILE): notizen.md
	pandoc --template=$(PANDOC_TEMPLATE) --filter=pandoc-citeproc --bibliography=$(BIBLIOGRAPHY) $^ -o doc.pdf
