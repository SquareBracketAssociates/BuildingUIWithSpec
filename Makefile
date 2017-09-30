OUTPUTDIRECTORY = ./book-result

PDFCHAPTERS =           book-result/AdvancedWidgets/AdvancedWidgets.pdf \
			book-result/DynamicSpec/DynamicSpec.pdf \
			book-result/FirstContact/FirstContact.pdf \
			book-result/Intro/Intro.pdf \
			book-result/LayoutsContruction/LayoutsContruction.pdf \
			book-result/ManagingWindow/ManagingWindow.pdf \
			book-result/Reuse/Reuse.pdf \
			book-result/ThreePillarsOfSpec/ThreePillarsOfSpec.pdf \
			book-result/TipsAndTricks/TipsAndTricks.pdf \
			book-result/Patterns/Patterns.pdf \

HTMLCHAPTERS =           book-result/AdvancedWidgets/AdvancedWidgets.html \
			book-result/DynamicSpec/DynamicSpec.html \
			book-result/FirstContact/FirstContact.html \
			book-result/Intro/Intro.html \
			book-result/LayoutsContruction/LayoutsContruction.html \
			book-result/ManagingWindow/ManagingWindow.html \
			book-result/Reuse/Reuse.html \
			book-result/ThreePillarsOfSpec/ThreePillarsOfSpec.html \
			book-result/TipsAndTricks/TipsAndTricks.html \

CHAPTERLATEXTEMPLATE = ./support/templates/chapter.latex.template
HTMLTEMPLATE = ./support/templates/chapter.html.template
BOOKLATEXTEMPLATE = ./support/templates/book.latex.template
PILLARTEMPLATE = ./support/templates/chapter.pillar.template

include copySupport.mk

initDir:
	mkdir -p $(OUTPUTDIRECTORY)

book: sbabook ./book-result/SpecBooklet.pdf

chapters: sbabook $(PDFCHAPTERS)

htmlChapters: sbabook $(HTMLCHAPTERS)

.SECONDARY:

sbabook:
	git submodule update --init

#Tex compilation
$(OUTPUTDIRECTORY)/%.pillar.json: %.pillar copySupport
	./pillar export --to="Pillar by chapter" --outputFile=$* $<

$(OUTPUTDIRECTORY)/%.pillar: $(OUTPUTDIRECTORY)/%.pillar.json
	./mustache --data=$< --template=${PILLARTEMPLATE} > $@

$(OUTPUTDIRECTORY)/SpecBooklet.tex.json: SpecBooklet.pillar copySupport
	./pillar export --to="latex:sbabook" --outputFile=SpecBooklet $<

$(OUTPUTDIRECTORY)/%.tex.json: %.pillar copySupport
	./pillar export --to="latex:sbabook" --outputFile=$* $<

$(OUTPUTDIRECTORY)/SpecBooklet.tex: $(OUTPUTDIRECTORY)/SpecBooklet.tex.json
	./mustache --data=$< --template=${BOOKLATEXTEMPLATE} > $@

$(OUTPUTDIRECTORY)/%.tex: $(OUTPUTDIRECTORY)/%.tex.json
	./mustache --data=$< --template=${CHAPTERLATEXTEMPLATE} > $@

$(OUTPUTDIRECTORY)/%.pdf: $(OUTPUTDIRECTORY)/%.tex
	latexmk -f -cd -use-make -pdf $<
	make cleanBookResult

#HTML compilation
$(OUTPUTDIRECTORY)/%.html.json: %.pillar copySupport
	./pillar export --to="html" --outputFile=$* $<

$(OUTPUTDIRECTORY)/%.html: $(OUTPUTDIRECTORY)/%.html.json
	./mustache --data=$< --template=${HTMLTEMPLATE} > $@

#cleaning
cleanWorkspace: clean
	rm -r ${OUTPUTDIRECTORY} || true
	rm -f *.pdf

clean:
	rm -f *.aux *.log *.fls *.fdb_latexmk *.lof EnterprisePharo.out *.toc *.listing

cleanBookResult:
	rm ${OUTPUTDIRECTORY}/*.aux ${OUTPUTDIRECTORY}/*.fls ${OUTPUTDIRECTORY}/*.log ${OUTPUTDIRECTORY}/*.fdb_latexmk || true
