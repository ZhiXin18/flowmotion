#
# Flowmotion
# Project Makefile
#

.PHONY: schema

# programs
DART := dart
NPX := npx

# paths
OPENAPI := schema/flowmotion_api.yaml
API_CLIENT := packages/flowmotion_api
API_BACKEND := backend/api.d.ts


schema: $(API_CLIENT) $(API_BACKEND)

$(API_CLIENT): $(OPENAPI)
	$(DART) run build_runner build --delete-conflicting-outputs


$(API_BACKEND): $(OPENAPI)
	cd $(dir $@) && $(NPX) openapi-typescript ../$(OPENAPI) -o $(notdir $(API_BACKEND))
