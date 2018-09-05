
.PHONY: all forklift

all: forklift
	
forklift:
	docker build \
		-t nanobox/forklift \
		.
		
	docker push nanobox/forklift
		
