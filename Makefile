# textbook content settings
OUTPUT_FILENAME = textbook
OUTPUT_DIRECTORY = public
# looks for :Zone.Identifier files added by https://github.com/microsoft/WSL/issues/4609
CHECK = $(shell find . -name '*:Zone.Identifier' -delete)
IMAGES = $(shell find source/images -type f)
CHAPTERS = source/chapters/*.md
CONTENT = awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $(CHAPTERS)

# output configuration files
HTML = --filter pandoc-crossref --defaults assets/defaults/html.yml
DOCX = --defaults assets/defaults/docx.yml
LATEX = --filter pandoc-crossref --defaults assets/defaults/latex.yml --no-highlight
EPUB = --filter pandoc-crossref --defaults assets/defaults/epub.yml --mathml
OAI = assets/empty.txt --defaults assets/defaults/oai.yml
HOME = --defaults assets/defaults/home.yml

# utilities
MAKEFILE = Makefile
PANDOC_COMMAND = pandoc --quiet
BASE_DEPENDENCIES = $(MAKEFILE) $(CHECK) $(CHAPTERS) $(IMAGES) 

# build commands
textbook:	html docx latex epub pdf

epub:	$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).epub

html:	$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).html

pdf:	$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).pdf

docx:	$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).docx

latex:	$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).tex

oai:
	@mkdir -p $(OUTPUT_DIRECTORY)
	@$(PANDOC_COMMAND) $(OAI) -o public/oai.xml
	@echo "🌐 The OAI-PMH record is now available in public/oai.xml"

markdown:
	@bash ./assets/scripts/preprocess.sh
	@echo "📚 Your Markdown files are ready in the /chapters/ folder"

clean:
	@rm -r $(OUTPUT_DIRECTORY)
	@echo "🧹 Let's start over."

# recipes for outputs
$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).epub:	$(BASE_DEPENDENCIES)
	@mkdir -p $(OUTPUT_DIRECTORY)
	@$(CONTENT) | $(PANDOC_COMMAND) $(EPUB) -o $@
	@echo "📚 The EPUB edition is now available in $@"

$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).html:	$(BASE_DEPENDENCIES)
	@mkdir -p $(OUTPUT_DIRECTORY)
	@$(CONTENT) | $(PANDOC_COMMAND) $(HOME) -o public/index.html
	@$(CONTENT) | $(PANDOC_COMMAND) $(HTML) -o $@
	@cp $(IMAGES) $(OUTPUT_DIRECTORY)
	@cp assets/lib/* $(OUTPUT_DIRECTORY)
	@cp assets/styles/* $(OUTPUT_DIRECTORY)
	@echo "📚 The HTML edition is now available in public/index.html"

$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).pdf:	$(BASE_DEPENDENCIES)
	@mkdir -p $(OUTPUT_DIRECTORY)
	@$(CONTENT) | $(PANDOC_COMMAND) $(LATEX) -o $@
	@echo "📚 The PDF edition is now available in $@"

$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).tex:	$(BASE_DEPENDENCIES)
	@mkdir -p $(OUTPUT_DIRECTORY)
	@$(CONTENT) | $(PANDOC_COMMAND) $(LATEX) -o $@
	@echo "📚 The LaTeX edition is now available in $@"

$(OUTPUT_DIRECTORY)/$(OUTPUT_FILENAME).docx:	$(BASE_DEPENDENCIES)
	@mkdir -p $(OUTPUT_DIRECTORY)
	@$(CONTENT) | $(PANDOC_COMMAND) $(DOCX) -o $@
	@echo "📚 The DOCX edition is now available in $@"

# lantern documentation content settings 
DOCS_OUTPUT_DIRECTORY = public/docs
DOCS_IMAGES = $(shell find docs/images -type f)
DOCS_CONTENT = awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $(DOCS_CHAPTERS)
DOCS_DEPENDENCIES = $(MAKEFILE) $(CHECK) $(DOCS_CHAPTERS) $(DOCS_IMAGES)
DOCS = --defaults assets/defaults/docs.yml
DOCS_CHAPTERS += $(addprefix ./docs/chapters/,\
 introduction.md\
 technology.md\
 manuscripts.md\
 formatting.md\
 online-workflow.md\
 desktop-workflow.md\
 metadata.md\
 content.md\
 media.md\
 bibliographies.md\
 customization.md\
 troubleshooting.md\
)

# documentation build commands
docs:	$(DOCS_OUTPUT_DIRECTORY)/index.html

# lantern documenation build recipes
$(DOCS_OUTPUT_DIRECTORY)/index.html:	$(DOCS_DEPENDENCIES)
	mkdir -p $(DOCS_OUTPUT_DIRECTORY)
	$(DOCS_CONTENT) | $(PANDOC_COMMAND) $(DOCS) -o $@
	cp $(DOCS_IMAGES) $(DOCS_OUTPUT_DIRECTORY)
	cp assets/lib/* $(DOCS_OUTPUT_DIRECTORY)
	cp assets/styles/* $(DOCS_OUTPUT_DIRECTORY)
	@echo "$@ was built"