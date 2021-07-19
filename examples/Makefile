LIBFYAML_INTEL=/home/Thomas.Robinson/libfyaml/build_intel
CC=icc
FC=ifort
FFLAGS_INTEL=-no-wrap-margin -traceback -stand f18 -warn all -g
CFLAGS_INTEL=-traceback -warn -g

LIBFYAML=$(LIBFYAML_INTEL)
CPPDEFS=-I$(LIBFYAML)/include -L$(LIBFYAML)/lib -lfyaml-0.7
FFLAGS= $(FFLAGS_INTEL)
CFLAGS=$(CFLAGS_INTEL)

fortran_example: fms_libfyaml_parser
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(FC) $(CPPDEFS) $(FFLAGS) $^.o fms_libfyaml_c_wrappers.o fms_c_to_fortran.o $@.F90 -o $@.x
	./$@.x 
	make clean

fms_libfyaml_parser: fms_libfyaml_c_wrappers fms_c_to_fortran
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(FC) $(CPPDEFS) $(FFLAGS) ../$@.F90 -c
fms_libfyaml_c_wrappers:
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(CC) $(CPPDEFS) $(CFLAGS) ../$@.c -c
fms_c_to_fortran:
	$(FC) $(CPPDEFS) $(FFLAGS) ../$@.F90 -c
myexample:
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(CC) $(CPPDEFS) $@.c -o $@.x
	./$@.x 
	make clean

inprogram:
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(CC) $(CPPDEFS) $@.c -o $@.x
	./$@.x 
	make clean

display_version:
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(LIBFYAML)/lib
	export LIBRARY_PATH=${LIBRARY_PATH}:$(LIBFYAML)/lib
	$(CC) $(CPPDEFS) $@.c -o $@.x
	./$@.x
	make clean
clean:
	rm -rf *.o *.mod *.x *.out 
