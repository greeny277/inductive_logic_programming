OUTFILE=out.pdf

.PHONY: doc

doc: $(OUTFILE)
	pandoc notizen.md -o out.pdf
