#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <libfyaml.h>

int main(int argc, char *argv[])
{
        static const char *yaml =
                "basedate: 1979\n"
                "experiment   : c96L33\n"
                "files: \n"
                "    filename  : atmos8x\n"
                "    freq : 24\n"
                "    something:\n"
                "        else: Suite #292\n";
        struct fy_document *fyd = NULL;
        int rc, count, ret = EXIT_FAILURE;
        int freq;
        int basedate;
        char filename[10 + 1];

        /* parse the document in one go */
        fyd = fy_document_build_from_string(NULL, yaml, (size_t)-1);
        count = fy_document_scanf(fyd,
                        "/basedate %d "
                        "/files/freq %d "
                        "/files/filename %10s",
                        &basedate, &freq, filename);
        if (count != 2) {
                fprintf(stderr, "Failed to retreive the two items\n");
        }

        /* print them as comments in the emitted YAML */
        printf("Frequency is  %d\n", freq);
        printf("FIle name is %s\n", filename);
        printf("Basedate is  %d\n", basedate);
} 
