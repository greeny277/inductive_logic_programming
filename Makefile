OUTFILE=out.pdf

.PHONY: doc

doc: $(OUTFILE)

$(OUTFILE): doc/notizen.md
	pandoc $^ -o doc/doc.pdf
