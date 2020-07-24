test:
	helm lint rapidsai

deps:
	helm dependency update rapidsai

readme:
	frigate gen rapidsai --no-credits > README.md
