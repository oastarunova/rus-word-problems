SHELL = /bin/bash
tomita = tomita/*.gzt tomita/*.cxx tomita/*.txt
sources = 1920s/glazenap.3.1924.txt 1930s/berezanskaya.1933.txt 1940s/popova.4.1941.txt 1970s/vilenkin.1970.txt 1980s/vilenkin.1984.txt
extensions = .csv u.csv .entities.txt .entlist.txt

.PRECIOUS = %.csv %u.csv %.entities.txt %.entlist.txt
.SECONDARY = %.csv %u.csv %.entities.txt %.entlist.txt

all:
	$(MAKE) $(foreach src,$(sources),$(foreach ext,$(extensions),$(basename $(src))$(ext)))

%.csv: %.txt $(tomita)
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py 1 > ../$@ ; popd

%u.csv: %.txt $(tomita)
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py 0 > ../$@ ; popd

%.entities.txt: %.csv %u.csv
	awk -F";" '{print $$3}' $< | grep . | sort | uniq -c | sort -nr > $@

%.entlist.txt: %.entities.txt
	awk '{print $$2}' $< | sort > $@

freq.table.csv:
	python maketable.py $(foreach src,$(sources),$(basename $(src))u.csv) > $@

jaccard.csv: freq.table.csv
	R CMD BATCH stats.R

clean:
	rm -vf $(foreach src,$(sources),$(foreach ext,$(extensions),$(basename $(src))$(ext)))
	rm -vf freq.table.csv
