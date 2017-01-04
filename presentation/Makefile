PDF = presentation

all: $(PDF) 

continuous: $(PDF).continuous 

%.continuous: %.pdf
	latexmk -jobname=$(@:%.continuous=%) -pvc -pdf $(@:%.continuous=%).tex

$(PDF): $(PDF).pdf

%.pdf: %.tex
	latexmk -jobname=$(@:%.pdf=%) -pdf $<

clean:
	latexmk -c -f $(PDF).tex

distclean: 
	latexmk -C -f $(PDF).tex
	rm -f $(PDF).pdf 

.PHONY: all clean distclean $(PDF) continuous
