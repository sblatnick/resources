CONF      = $(wildcard targets/*)

#Variables use:
# = recursively expanded variable
# := simply expanded variable

# \ can continue on next line

#allow multiple customer-named targets:
TARGETS   = $(patsubst targets/%, %, $(CONF))
# % wildcard

#yq Portability:
YQ        = $(firstword $(shell which yq) chart/lib/yq)

#Use yq to fetch from yaml:
IMAGE     = $(shell $(YQ) r build/values.yaml serv.image 2>/dev/null)
TAG       = $(shell $(YQ) r build/Chart.yaml appVersion 2>/dev/null)
NAMESPACE = $(shell $(YQ) r build/values.yaml namespace 2>/dev/null)
MANAGED   = $(shell $(YQ) r build/values.yaml managed 2>/dev/null)
SC        = $(findstring openebs,$(shell $(YQ) r build/values.yaml persistence.storageClass 2>/dev/null))

#Handle helm version discrepancies
V3        = $(findstring v3,$(shell helm version --short))

#Get k8s persistent volumes:
#Just a string for use by the command:
JSONPATH  = {range.items[?(@.status.phase=="Released")]}{"pv/"}{.metadata.name}{"\n"}{end}
UB_PVS    = $(shell kubectl get pv -o jsonpath='$(JSONPATH)')
NS_PVS    = $(shell kubectl -n $(NAMESPACE) get pvc -o=name)

#Default: make serv
serv: $@
# $@ left side of : or target, so `make serv` => `make $(TARGETS)` where TARGETS == serv
# $^ right side of : or dependency list
# $< first item in dependency list

#Aliases:
img: image
template: chart
in: install
up: update
upgrade: update
rm: remove
uninstall: remove
tar: package

#Ingore:
.PHONY: chart

#Actions:

#run clean before building any customer target
$(TARGETS): clean
	mkdir -p build
	cp -rf chart/ build/
	cp -rf targets/$@/ build/
#list all customer targets
list:
#@ prefix means don't print command
	@ls -1 targets/
ready:
	@ls build/values.yaml >/dev/null 2>&1 || { \
		echo "ERROR: must build target first"; \
		echo "Targets:"; \
		make list | sed 's/^/  /'; \
		exit 1; \
	}
image: ready
	docker build -t $(IMAGE):$(TAG) -f build/Dockerfile build/
push: ready
	docker push $(IMAGE):$(TAG)

chart: ready
	mkdir -p build/yaml
ifeq ($(V3),v3)
	helm template --output-dir build/yaml serv ./build --debug --namespace $(NAMESPACE)
	mv -f build/yaml/serv/templates/*.yaml build/yaml/
	rm -Rf build/yaml/serv
else
	helm template -n serv ./build --debug --namespace $(NAMESPACE) | tee build/yaml/serv.yaml
endif

install: ready
ifeq ($(V3),v3)
#Equality conditional must NOT be indented, even when nested
ifeq ($(MANAGED),true)
	kubectl create namespace $(NAMESPACE)
endif
	helm install serv ./build --debug --namespace $(NAMESPACE)
else
	helm install -n serv ./build --debug --namespace $(NAMESPACE)
endif

update: ready
ifeq ($(V3),v3)
	helm upgrade -n $(NAMESPACE) --debug serv ./build
else
	helm upgrade --debug serv ./build
endif

remove: ready
ifeq ($(V3),v3)
#- prefix means don't stop on error
	-helm del --namespace $(NAMESPACE) serv
else
#alternatively, use || to skip error, but the output looks funny
	helm del --purge serv || echo "helm delete failed"
endif
ifeq ($(MANAGED),true)
	-kubectl delete namespace $(NAMESPACE)
endif
	@echo "Deleting PersistentVolumes..."
ifeq ($(SC),openebs)
#for loop: $(foreach var,list,text)
	@$(foreach pv,$(UB_PVS), kubectl delete $(pv);)
else
	@$(foreach pv,$(NS_PVS), kubectl -n $(NAMESPACE) delete $(pv);)
endif

package: ready
	mv build serv
	tar -czvf serv-k8s-$(TAG).tar.gz ./serv
	mv serv build

clean:
	rm -rf build


