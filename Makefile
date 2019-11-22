test:
	helm lint rapidsai

deps:
	helm dependency update rapidsai
