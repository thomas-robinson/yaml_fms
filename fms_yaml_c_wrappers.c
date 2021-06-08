#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <libfyaml.h>

int fms_yaml_parse_int (struct fy_document *fyd, char *variable) {
   int count;
   int ivar;
   count =  fy_document_scanf(fyd, variable, &ivar);
   return &ivar;
}
