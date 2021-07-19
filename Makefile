LIBFYAML_INTEL=/home/Thomas.Robinson/libfyaml/build_intel
LIBYAML_INTEL=/home/Thomas.Robinson/libyaml/build
CC=icc
FC=ifort
FFLAGS_INTEL=-no-wrap-margin -traceback -stand f18 -warn all

LIBFYAML=$(LIBFYAML_INTEL)
CPPDEFS=-I$(LIBFYAML)/include -L$(LIBFYAML)/lib -lfyaml-0.7
FFLAGS= $(FFLAGS_INTEL)

fms_libfyaml_parser: fms_libfyaml_c_wrappers
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(FC) $(CPPDEFS) $(FFLAGS) $^.o $@.F90 -c

fms_libfyaml_c_wrappers:
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(CC) $(CPPDEFS) $@.c -c
clean:
	rm -rf *.o *.mod *.x *.out 
