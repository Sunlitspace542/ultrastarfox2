/****************************************************************/
/*																*/
/*	SCAD *.OBJ to ASM converter									*/
/*																*/
/****************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*--------------------------------------------------------------*/

#define OBJ_DATA_SIZE 0x3500

/****************************************************************/
/*	OAM data RECORD		*/
/****************************************************************/
typedef struct {
    int count;
    int pointerHV;
    int pointerCA;
} DataOAM;
/*--------------------------------------------------------------*/
typedef struct {
    int count;
    int oamH[64];
    int oamV[64];
} DataHV;
/*--------------------------------------------------------------*/
typedef struct {
    int count;
    int oamC[64];
    int oamA[64];
} DataCA;
/*--------------------------------------------------------------*/
typedef struct {
    int count;
    int SEQframe[32];
    int SEQchar[32];
} DataSEQ;
/*--------------------------------------------------------------*/

/****************************************************************/
/*	Types and Function Prototypes		*/
/****************************************************************/

static unsigned char OBJdata[OBJ_DATA_SIZE];
static DataOAM dataoam[32];
static DataHV datahv[32];
static DataCA dataca[32];
static DataSEQ dataseq[16];
char filename[256];
char labelname[256];

void outputData(const char *labelname, int seqTotal, int dataTotal, int hvTotal, int caTotal);
int makeSEQData(unsigned char *buf);
void makeOBJData(unsigned char *buf, int *dataPointer, int *hvPointer, int *caPointer);
int HVsameCheck(const DataHV *hvArray, const DataHV *hv, int total);
int CAsameCheck(const DataCA *caArray, const DataCA *ca, int total);
void HVcopy(DataHV *dest, const DataHV *src);
void CAcopy(DataCA *dest, const DataCA *src);

/****************************************************************/
/*	Main routine		*/
/****************************************************************/

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Nintendo Super CG-CAD OBJ to ASM Converter\n");
        fprintf(stderr, "------------------------------------------\n\n");
        fprintf(stderr, "Usage: makeobj <file1> <file2> <and so on...>\n");
        fprintf(stderr, "Omit the \".obj\" in the filenames.\n");
        fprintf(stderr, "e.g. For \"makeobj w0_1 w0_2\", The output would be w0_1.asm and w0_2.asm. \n\n");
        fprintf(stderr, "1994.6.29 Programmed by H. Yajima\n");
        fprintf(stderr, "2024.11.27 Modified by Sunlit\n");
        return EXIT_FAILURE;
    }

	int filecount = argc-1;
	int dataTotal = 0;	/* Total number of OBJ-DATA */
	int hvTotal = 0, caTotal = 0;
	int seqTotal = 0;	/* Total number of SEQ-DATA*/

    for ( int i = 1; i < argc; i++) {
        snprintf(filename, sizeof(filename), "%s.OBJ", argv[i]);

        FILE *fp = fopen(filename, "rb");
        if (!fp) {
            fprintf(stderr, "### ERROR ### Cannot open %s\n", filename);
            return EXIT_FAILURE;
        }

        if (fread(OBJdata, sizeof(char), OBJ_DATA_SIZE, fp) != OBJ_DATA_SIZE) {
            fprintf(stderr, "### ERROR ### Filesize Error %s\n", filename);
            fclose(fp);
            return EXIT_FAILURE;
        }

        printf("Converting %s to ASM...\n", filename);
        fclose(fp);

        strcpy(labelname, argv[i]);

        makeOBJData(OBJdata, &dataTotal, &hvTotal, &caTotal); // Convert OBJ data
        seqTotal = makeSEQData(OBJdata); // Convert SEQ data

        outputData(labelname, seqTotal, dataTotal, hvTotal, caTotal); // Output data

    }

    printf("Successfully converted %d OBJ file(s).\n", filecount);

    return EXIT_SUCCESS;
}

/****************************************************************/
/*	OBJECT DATA output		*/
/****************************************************************/

void outputData(const char *labelname, int seqTotal, int dataTotal, int hvTotal, int caTotal) {

	int datacount,seqcount;
	int programcode = 0;
	int i,j;
	int ctSEQ,ctOBJ,ctHV,ctCA;

    char outFilename[256];
    sprintf(outFilename, "%s.asm", labelname);

	FILE *outFile = fopen(outFilename, "w");

	if (!outFile) {
		fprintf(stderr, "### ERROR ### Can't open output file %s\n", outFilename);
		exit(1);
	}


	fprintf(outFile, ";;**** Read %16s *****\n", filename);
	fprintf(outFile, ";***********************************************************************\n");
	fprintf(outFile, ";	<< %s >> OBJECT DATA\n",labelname);
	fprintf(outFile, ";***********************************************************************\n");
	fprintf(outFile, "	glb	SEQ_%s\n",labelname);

	/*===== Byte Count Information Data Creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");

	ctSEQ = seqTotal*2+2;
	for (seqcount=0;seqcount<seqTotal;seqcount++){
		ctSEQ += (dataseq[seqcount].count)*2+1;
	}
	ctOBJ = dataTotal*8;
	ctHV  = 0;
	for(i=0;i<hvTotal;i++)	ctHV += datahv[i].count*2;
	ctCA  = 0;
	for(i=0;i<caTotal;i++)	ctCA += dataca[i].count*2;

	fprintf(outFile, ";;	OBJ-SEQ   data total %6d bytes\n",ctSEQ);
	fprintf(outFile, ";;	OBJ-BLOCK data total %6d bytes\n",ctOBJ);
	fprintf(outFile, ";;	OBJ-HV    data total %6d bytes\n",ctHV);
	fprintf(outFile, ";;	OBJ-CA    data total %6d bytes\n",ctCA);
	fprintf(outFile, ";;- - - - - - - - - - - - - - - - - - - - - - - - - \n");
	fprintf(outFile, ";;	DATA TOTAL           %6d bytes (%XH) \n",ctSEQ+ctOBJ+ctHV+ctCA
							,ctSEQ+ctOBJ+ctHV+ctCA);



	/*===== SEQ Information Table Creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "; SEQ object table\n");
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "SEQ_%s\n",labelname);
	fprintf(outFile, "	dw	OBJ_%s\n",labelname);
	for (seqcount=0;seqcount<seqTotal;seqcount++){
		fprintf(outFile, "	dw	%s_S_%d\n",labelname,seqcount);
	}



	/*===== SEQ Information Data Creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "; SEQ object data\n");
	fprintf(outFile, ";-----------------------------------------------------------------------\n");

	for (seqcount=0;seqcount<seqTotal;seqcount++){

		fprintf(outFile, "%s_S_%d\n",labelname,seqcount);

		for(j=0;j<dataseq[seqcount].count;j++){
			fprintf(outFile, "	db	%d,%d\n"
						,dataseq[seqcount].SEQframe[j]
						,dataseq[seqcount].SEQchar[j]);			
		}
		
		fprintf(outFile, "	db	080h\n");

	}


	/*===== block object table creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "; block object table\n");
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "OBJ_%s\n",labelname);
	for(datacount=0;datacount<dataTotal;datacount++){
		fprintf(outFile, "	dw	%s_%d\n",labelname,datacount);
	}


	/*===== block object data creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "; block object data\n");
	fprintf(outFile, ";-----------------------------------------------------------------------\n");

	for(datacount=0;datacount<dataTotal;datacount++){

		fprintf(outFile, "%s_%d\n",labelname,datacount);
		fprintf(outFile, "	db	%d,%d\n"
					,programcode
					,dataoam[datacount].count);
		fprintf(outFile, "	dw	%s_HV_%d,%s_CA_%d\n"
					,labelname,dataoam[datacount].pointerHV
					,labelname,dataoam[datacount].pointerCA);

	}

	/*===== H/V Position Data Creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "; HV position data\n");
	fprintf(outFile, ";-----------------------------------------------------------------------\n");

	for(i=0;i<hvTotal;i++){
		fprintf(outFile, "%s_HV_%d\n",labelname,i);
		for(j=0;j<datahv[i].count;j++){
			fprintf(outFile, "	db %03xh,%03xh\n",datahv[i].oamH[j],datahv[i].oamV[j]);
		}
	}

	/*===== C/A Character Number Data Creation =====*/
	fprintf(outFile, ";-----------------------------------------------------------------------\n");
	fprintf(outFile, "; CA charcterNO data\n");
	fprintf(outFile, ";-----------------------------------------------------------------------\n");

	for(i=0;i<caTotal;i++){
		fprintf(outFile, "%s_CA_%d\n",labelname,i);
		for(j=0;j<dataca[i].count;j++){
			fprintf(outFile, "	db %03xh,%03xh\n",dataca[i].oamC[j],dataca[i].oamA[j]);
		}
	}


	fprintf(outFile, "\n");
	fprintf(outFile, ";=======================================================================\n");

}

/****************************************************************/
/*	SEQ DATA Import												*/
/****************************************************************/

int makeSEQData(unsigned char *buf) {
    int SEQpointer = 0;

    for (int i = 0; i < 16; i++) {
        int offset = i * 0x40 + 0x3100;	// 1SEQ = 40h bytes
        int SEQpattern = 0;	// Number of 1 SEQ patterns

        for (int j = 0; j < 32; j++) {
            if (buf[offset + j * 2] != 0)
                SEQpattern++;
        }
        if (SEQpattern == 0)
            continue;

        dataseq[SEQpointer].count = SEQpattern;
        int frameCount = 0;

        for (int j = 0; j < 32; j++) {
            if (buf[offset + j * 2] != 0) {
                dataseq[SEQpointer].SEQframe[frameCount] = buf[offset + j * 2];
                dataseq[SEQpointer].SEQchar[frameCount] = buf[offset + j * 2 + 1];
                frameCount++;
            }
        }
        SEQpointer++;
    }
    return SEQpointer;
}

/****************************************************************/
/*	Read object data from file		*/
/****************************************************************/

void makeOBJData(unsigned char *buf, int *dataPointer, int *hvPointer, int *caPointer) {
    int dataCount = 0, hvCount = 0, caCount = 0;

    /* char*64(max) OBJ-BLOCK */
    for (int block = 0; block < 32; block++) {
        int offset = block * 0x180;
        int objTotal = 0;	// Number of OBJs in the block

        /*-----------Check if this block is valid -----------*/
        for (int charCount = 0; charCount < 64; charCount++) {
            if ((buf[offset + charCount * 6] & 0x80) != 0)
                objTotal++;
        }
        if (objTotal == 0)
            continue; // If not, return!

        dataoam[dataCount].count = objTotal;
        /*---------- create data ---------------------------------*/
        DataHV currentHV = { .count = objTotal };
        DataCA currentCA = { .count = objTotal };

        int objCount = 0;
        for (int charCount = 0; charCount < 64; charCount++) {
            if ((buf[offset + charCount * 6] & 0x80) != 0) {
                currentHV.oamH[objCount] = buf[offset + charCount * 6 + 3];
                currentHV.oamV[objCount] = buf[offset + charCount * 6 + 2];
                currentCA.oamA[objCount] = buf[offset + charCount * 6 + 4];
                currentCA.oamC[objCount] = buf[offset + charCount * 6 + 5];
                objCount++;
            }
        }

        /* check if there is the same data */

        int sameHV = HVsameCheck(datahv, &currentHV, hvCount);
        int sameCA = CAsameCheck(dataca, &currentCA, caCount);

        if (sameHV == -1) {
            HVcopy(&datahv[hvCount], &currentHV);
            dataoam[dataCount].pointerHV = hvCount++;
        } else {
            dataoam[dataCount].pointerHV = sameHV;
        }

        if (sameCA == -1) {
            CAcopy(&dataca[caCount], &currentCA);
            dataoam[dataCount].pointerCA = caCount++;
        } else {
            dataoam[dataCount].pointerCA = sameCA;
        }

        dataCount++;	// to next block of data
    }

    *dataPointer = dataCount;
    *hvPointer = hvCount;
    *caPointer = caCount;
}

/****************************************************************/
/*	structure comparison		*/
/****************************************************************/
/*	No common data when -1		*/
/*--------------------------------------------------------------*/

int HVsameCheck(const DataHV *hvArray, const DataHV *hv, int total) {
    for (int i = 0; i < total; i++) {
        if (hvArray[i].count == hv->count &&
            memcmp(hvArray[i].oamH, hv->oamH, hv->count * sizeof(int)) == 0 &&
            memcmp(hvArray[i].oamV, hv->oamV, hv->count * sizeof(int)) == 0) {
            return i;
        }
    }
    return -1;
}

/*--------------------------------------------------------------*/

int CAsameCheck(const DataCA *caArray, const DataCA *ca, int total) {
    for (int i = 0; i < total; i++) {
        if (caArray[i].count == ca->count &&
            memcmp(caArray[i].oamC, ca->oamC, ca->count * sizeof(int)) == 0 &&
            memcmp(caArray[i].oamA, ca->oamA, ca->count * sizeof(int)) == 0) {
            return i;
        }
    }
    return -1;
}

/*--------------------------------------------------------------*/

/****************************************************************/
/*	Copy of structure		*/
/****************************************************************/

/*--------------------------------------------------------------*/

void HVcopy(DataHV *dest, const DataHV *src) {
    memcpy(dest, src, sizeof(DataHV));
}

/*--------------------------------------------------------------*/

void CAcopy(DataCA *dest, const DataCA *src) {
    memcpy(dest, src, sizeof(DataCA));
}

/*--------------------------------------------------------------*/

