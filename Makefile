#
# This is a project Makefile. It is assumed the directory this Makefile resides in is a
# project subdirectory.
#

PROJECT_NAME := hello-world

include $(IDF_PATH)/make/project.mk

bindings:
	CLANG_INCLUDES="$(patsubst %,-I%,$(COMPONENT_INCLUDES))" ./bindgen.sh
