SHELL = /bin/bash

%.csv: %.txt
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py 1 > ../$@ ; popd

%u.csv: %.txt
	pushd tomita ; cat ../$< | tomitaparser config.proto | python parsefacts.py 0 > ../$@ ; popd
