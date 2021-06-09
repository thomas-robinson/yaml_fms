# yaml_fms
Development of yaml parser for FMS

## Build and Run
To run the fortran_example test on the skylake devbox:
```csh
module load oneapi compiler
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/home/Thomas.Robinson/libfyaml/build_intel/lib
cd examples
make
```

## Obtaining values
The YAML stores infromation in a hierarchical manner which can be directly
accessed through this routine.  Here is an example of how to use this routine
with the following YAML
```yaml
first: 1
hello: "world"
top:
     sub: true
     tree:
          subtree: 3

```
To get the value of first, you would pass the YAML string, a string looking
for first, and an integer to hold the value of first like this
```fortran
call fms_yaml_key_value (input_yaml,"/first %d", firstValue)
```
To get the value for subtree, it would look like this:
```fortran
call fms_yaml_key_value (input_yaml,"/top/tree/subtree %d", firstValue)
```
Use %d for integers, %s for string, and %f for reals


# Disclaimer

The United States Department of Commerce (DOC) GitHub project code is provided
on an 'as is' basis and the user assumes responsibility for its use. DOC has
relinquished control of the information and no longer has responsibility to
protect the integrity, confidentiality, or availability of the information. Any
claims against the Department of Commerce stemming from the use of its GitHub
project will be governed by all applicable Federal law. Any reference to
specific commercial products, processes, or services by service mark,
trademark, manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce. The
Department of Commerce seal and logo, or the seal and logo of a DOC bureau,
shall not be used in any manner to imply endorsement of any commercial product
or activity by DOC or the United States Government.

