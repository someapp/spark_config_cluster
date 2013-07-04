PACKAGE_NAME = beehive
PACKAGE_VERSION = 0.1
VERBOSE = -vvv

.PHONY: deps compile rel test

all: compile

compile: deps
	@./rebar ${VERBOSE} compile

deps:
	@echo "Getting Dependencies"
	@./rebar ${VERBOSE} ${VERBOSE} get-deps

check:
	@echo "Checking Dependencies"
	@./rebar ${VERBOSE} check-deps

clean:
	@echo "Cleaning Built Files"
	@./rebar ${VERBOSE} clean
	@rm -rf ./rel/files/etc

rel: all
	@(cp -Rf ./etc ./rel/files/etc)
	@(make rel_erlang)
#	@(chmod u+x ./rel/${PACKAGE_NAME}/bin/${PACKAGE_NAME})
	@(make rel_message)

rel_erlang:
	@./rebar ${VERBOSE} generate force=1

rel_message:
	@echo "\
Beehive code generated in `pwd`/rel/${PACKAGE_NAME}\n\
*----------------------------------------------------------*\n\
* IMPORTANT                                                *\n\
*----------------------------------------------------------*\n\
To use git commit hooks properly, set the following value.\n\n\
code_root: `pwd`/rel/beehive\n\
\n\
This should be set in a beehive config file, found at\n\
~/.beehive.conf or /etc/beehive.conf.  See docs for more info.\
\n\n\
This value will need to always reflect the current root of\n\
your beehive release.  Otherwise git commit hooks won't know\n\
where to find scripts to trigger app actions.\n\
*----------------------------------------------------------*"

GIT_REPOS_DIR=~/repositories
gitolite_setup:
	@git clone ${GIT_REPOS_DIR}/git_admin rel/beehive/gitolite
	@cp priv/git/templates/post-receive ~/.git/hooks/post-receive

doc:
	@echo "Generating Documentation"
	@./rebar ${VERBOSE} doc skip_deps=true

package:
	@echo "Making Package"
	@(mkdir -p ./builds)
	@(tar -C rel -c beehive | gzip > ./builds/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz)

test:	compile
	@echo "Running Test" 
	@./test/bootstrap.sh
    ifdef suite
	@./rebar ${VERBOSE} skip_deps=true eunit suite=$(suite)
    else
	@./rebar ${VERBOSE} skip_deps=true eunit
    endif
