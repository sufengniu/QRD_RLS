# makefile for verification of dwt hardware implementation

IPNAME=dwt

.PHONY: ise clean-projnav clean

ise: devl/projnav/$(IPNAME).xise
	cd devl/projnav/ && ise $(IPNAME).xise

devl/projnav/$(IPNAME).xise: devl/projnav/$(IPNAME).tcl
	cd devl/projnav/ && xtclsh $(IPNAME).tcl

clean-projnav:
	cd devl/projnav/ && ls | grep -v $(IPNAME).tcl | xargs rm -rf

clean: clean-projnav
