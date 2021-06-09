/***********************************************************************
 *                   GNU Lesser General Public License
 *
 * This file is part of the GFDL Flexible Modeling System (FMS).
 *
 * FMS is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * FMS is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FMS.  If not, see <http://www.gnu.org/licenses/>.
 *********************************************************************/

/**
 * \file
 * \author Tom Robinson
 * \email gfdl.climate.model.info@noaa.gov 
 *
 * \section DESCRIPTION
 *
 * C wrappers for processing YAML using libfyaml
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <libfyaml.h>
/** \brief Parses yamlString to get the integer value of variable.
 * `variable` should have give the hierarchical structure of the key requested
 * in the form "/top/sub/level/key %d" with the %d to denote an integer.
 */
int fms_yaml_parse_int (char *yamlString, int yamlLen, char *variable) {
   struct fy_document *fyd;
   int count;
   int ivar;
/* Read the YAML */
   fyd = fy_document_build_from_string (NULL, yamlString, yamlLen); 
/* Get the integer from the YAML */
   count =  fy_document_scanf(fyd, variable, &ivar);
/* Return the integer */
   return ivar;
}
/** \brief Parses yamlString to get the float value of variable.
 * `variable` should have give the hierarchical structure of the key requested
 * in the form "/top/sub/level/key %f" with the %f to denote a float.
 **/
float fms_yaml_parse_float (char *yamlString, int yamlLen, char *variable) {
   struct fy_document *fyd;
   int count;
   float fvar;
/* Read the YAML */
   fyd = fy_document_build_from_string (NULL, yamlString, yamlLen);
/* Get the integer from the YAML */
   count =  fy_document_scanf(fyd, variable, &fvar);
/* Return the integer */
   return fvar;
}

/** \brief Parses yamlString to get the string value of variable.
 * `variable` should have give the hierarchical structure of the key requested
 * in the form "/top/sub/level/key %s" with the %s to denote a string.
 **/
char * fms_yaml_parse_string (char *yamlString, int yamlLen, char *variable) {
   struct fy_document *fyd;
   int count;
   char *fvar;
/* Read the YAML */
   fyd = fy_document_build_from_string (NULL, yamlString, yamlLen);
/* Get the integer from the YAML */
   count =  fy_document_scanf(fyd, variable, fvar);
/* Return the integer */
   return fvar;
}


