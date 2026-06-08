# Build both documents from the shared data source.

.PHONY: all vitae resume watch-vitae watch-resume clean

all: vitae resume

vitae:
	$(MAKE) -C vitae

resume:
	$(MAKE) -C resume

watch-vitae:
	$(MAKE) -C vitae watch

watch-resume:
	$(MAKE) -C resume watch

clean:
	$(MAKE) -C vitae clean
	$(MAKE) -C resume clean
