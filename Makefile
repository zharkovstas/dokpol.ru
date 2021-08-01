DEBUG:=

BASE_URL := https://dokpol.ru

OUTPUT := out
SOURCE := src
CONTENT := $(SOURCE)/content
FILTERS := $(SOURCE)/filters

DIRS := $(subst $(CONTENT),$(OUTPUT),$(shell find $(CONTENT) -type d))
MARKDOWN_PAGES := $(shell find $(CONTENT) -type f -name "*.md")
STATIC_FILES := $(subst $(CONTENT),$(OUTPUT),$(shell find $(CONTENT) -type f ! -name "*.md"))
HTML_PAGES := $(patsubst $(CONTENT)/%.md, $(OUTPUT)/%.html, $(MARKDOWN_PAGES))
SITEMAP := $(OUTPUT)/sitemap.txt

PANDOC_FLAGS := \
			--standalone \
			--from markdown \
			--to html5 \
			--template $(SOURCE)/template.html \
			--lua-filter=$(FILTERS)/set-header.lua \
			--lua-filter=$(FILTERS)/modify-links.lua

default: all

debug: DEBUG := true
debug: all

all: $(DIRS) $(HTML_PAGES) $(STATIC_FILES) $(SITEMAP)

$(DIRS):
	mkdir -p $@

$(HTML_PAGES): $(SOURCE)/template.html

$(OUTPUT)/%.html: $(CONTENT)/%.md
	pandoc $(PANDOC_FLAGS) --output $@ $< --variable debug=$(DEBUG)

$(STATIC_FILES): $(shell find $(CONTENT) -type f ! -name "*.md")
	cp $(subst $(OUTPUT),$(CONTENT),$@) $@

$(SITEMAP): $(HTML_PAGES)
	echo $(BASE_URL)/ > $@
	find $(OUTPUT)/ \
		-name "*.html" \
		! -name "404.html" \
		! -name "index.html" \
		-type f \
		-printf "$(BASE_URL)/%P\n" >> $@

clean:
	rm -rf $(OUTPUT)/*

.PHONY: all clean debug