PWD:=$(shell pwd -L)

IMAGE_BUILD=node:alpine
DOCKER_RUN:=docker run --rm -it -v ${PWD}:/usr/app -w /usr/app ${IMAGE_BUILD}
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

build:
	- ${DOCKER_RUN} npm run build

configure: 
	- ${DOCKER_RUN} npm install

add:
	- ${DOCKER_RUN} npm install ${call args}

add-dev:
	- ${DOCKER_RUN} npm install -D ${call args}

code-review:
	- ${DOCKER_RUN} npm run code-review	

test:
	- ${DOCKER_RUN} npm test