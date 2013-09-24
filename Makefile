SHELL = /bin/bash
tomita = tomita/*.gzt tomita/*.cxx tomita/*.txt
sources = 1920s/arzhenikov.1924.txt 1920s/glazenap.3.1924.txt 1930s/berezanskaya.1933.txt 1940s/popova.4.1941.txt 1960s/larichev.1964.txt 1970s/vilenkin.1970.txt 1980s/vilenkin.1984.txt
extensions = .csv u.csv .entities.txt .entlist.txt .pairs.csv

.PRECIOUS: %.csv %u.csv %.entities.txt %.entlist.txt
.PHONY: stat stats/freq.all.csv

all:
	$(MAKE) $(foreach src,$(sources),$(foreach ext,$(extensions),$(basename $(src))$(ext)))

%.csv: %.txt $(tomita)
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py > ../$@ ; popd

%u.csv: %.txt $(tomita)
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py -u > ../$@ ; popd

%.pairs.csv: %.txt $(tomita)
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py -c | grep . | awk '{printf "%s;$(@F)\n", $$0}' > ../$@ ; popd

%.entities.txt: %.csv %u.csv
	awk -F";" '{print $$3}' $< | grep . | sort | uniq -c | sort -nr > $@

%.entlist.txt: %.entities.txt
	awk '{print $$2}' $< | sort > $@

stats/pairs.all.csv: $(foreach src,$(sources),$(basename $(src)).pairs.csv)
	cat $^ | sort | uniq -c | awk '{printf "%s;%s\n", $$2, $$1 }' > $@

stats/freq.net.csv: stats/pairs.all.csv
	Rscript companions.R

stats/freq.all.csv:
	python maketable.py -o stats/ $(foreach src,$(sources),$(basename $(src))u.csv)

stats/geo/geo.all.csv:
	python maketable.py -e geo -o stats/geo $(foreach src,$(sources),$(basename $(src))u.csv)

stats/subject/subject.all.csv:
	python maketable.py -e subject -o stats/subject $(foreach src,$(sources),$(basename $(src))u.csv)

stats/basic.txt: $(foreach src,$(sources),$(basename $(src)).csv)
	rm -vf $@
	for i in $^; do \
	echo "$$i," `awk -F";" '{if (!($$1 == a)) {a=$$1;c++}} END{print c}' $$i` >> $@ ; done

stat: stats/basic.txt stats/freq.all.csv stats/geo/geo.all.csv stats/subject/subject.all.csv stats/freq.net.csv
	Rscript stats.R stats freq
	Rscript stats.R stats/geo geo
	Rscript stats.R stats/subject subject


issues.pdf: issues.csv
	R CMD BATCH issues.R

clean:
	rm -vf $(foreach src,$(sources),$(foreach ext,$(extensions),$(basename $(src))$(ext)))
	rm -vf stats/*.csv
