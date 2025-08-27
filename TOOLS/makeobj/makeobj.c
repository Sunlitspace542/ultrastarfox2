/*****************************************************************/
/*																					*/
/*	CAD *.OBJ data convert program										*/
/*																					*/
/*****************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*--------------------------------------------------------------*/

#define	OBJdatasize	0x3500

static	unsigned char OBJdata[OBJdatasize];

/****************************************************************/
/*	OAMデータRECORD						*/
/****************************************************************/
typedef	struct {
	int	count;
	int	pointerHV;
	int	pointerCA;
} DataOAM;
/*--------------------------------------------------------------*/
typedef struct {
	int	count;
	int	oamH[64];
	int	oamV[64];
} DataHV;
/*--------------------------------------------------------------*/
typedef struct {
	int	count;
	int	oamC[64];
	int	oamA[64];
} DataCA;
/*--------------------------------------------------------------*/
typedef struct {
	int	count;
	int	SEQframe[32];
	int	SEQchar[32];
} DataSEQ;
/*--------------------------------------------------------------*/

int OutputData(char	*labelname, int seqtotal, int datatotal, int hvtotal, int catotal);
int	MakeSEQData(unsigned char	*buf);
int	MakeOBJData(unsigned char	*buf, int	*datapointer, int	*hvpointer, int *capointer);
int HVsamechack(DataHV	*hv2, DataHV	*hv1, int total);
int CAsamechack(DataCA	*ca2, DataCA	*ca1, int total);
int HVcopy(DataHV	*hv2, DataHV	*hv1);
int CAcopy(DataCA	*ca2, DataCA	*ca1);

/****************************************************************/
/*	メインルーチン						*/
/****************************************************************/

int main(int	argc, char	**argv)
{

	FILE	*fp;
	char	filename[256];
	char	labelname[256];
	int	filecount;
	int	datatotal;	/* OBJ-DATA の総数 */
	int	hvtotal,catotal;
	int	seqtotal;	/* SEQ-DATA の総数 */

	if ( argc < 2 ) {
		fputs ("***************************************************\n", stderr );
		fputs ("*                                                 *\n", stderr );
		fputs ("*       Convert ObjectAnimation(=.OBJ) Data       *\n", stderr );
		fputs ("*                                                 *\n", stderr );
		fputs ("*       Usgae makeobj <file1> <file2> ...         *\n", stderr );
		fputs ("*                                                 *\n", stderr );
		fputs ("*         	1994.6.29 Programed by H.Yajima      *\n", stderr );
		fputs ("*                                                 *\n", stderr );
		fputs ("***************************************************\n", stderr );
		exit(1);
	}


	filecount=1;
	while(--argc){

		strcpy (filename,argv[filecount]);
		strcat (filename,".OBJ");

		if((fp = fopen(filename, "rb")) == NULL){
			fprintf(stderr, "### ERROR ###	Can't open %s\n", filename);
			exit(1);
		}

		if (fread(OBJdata, sizeof(char), OBJdatasize,fp) != OBJdatasize){
			fprintf(stderr, "### ERROR ###	Filesize Error %s\n", filename);
			exit(1);
		}

		printf ( ";;**** Read %16s *****\n",filename );

		fclose(fp);
		filecount++;

	}

	strcpy (labelname,argv[1]);

	MakeOBJData(OBJdata,&datatotal,&hvtotal,&catotal);		
							/* OBJ データの変換	*/

	seqtotal  = MakeSEQData(OBJdata);		/* SEQ データの変換	*/

	OutputData(labelname,seqtotal,datatotal,hvtotal,catotal);  
							/* データの出力	*/

}

static	DataOAM	dataoam[32];
static	DataHV	datahv[32];
static	DataCA	dataca[32];
static	DataSEQ	dataseq[16];


/****************************************************************/
/*	OBJECT DATA の出力					*/
/****************************************************************/

int OutputData(char	*labelname, int seqtotal, int datatotal, int hvtotal, int catotal)
{

	int datacount,seqcount;
	int programcode = 0;
	int i,j;
	int ctSEQ,ctOBJ,ctHV,ctCA;

	printf (";***********************************************************************\n");
	printf (";	<< %s >> OBJECT DATA\n",labelname);
	printf (";***********************************************************************\n");
	printf ("	glb	SEQ_%s\n",labelname);

	/*===== バイト数情報データ作成 =====*/
	printf (";-----------------------------------------------------------------------\n");

	ctSEQ = seqtotal*2+2;
	for (seqcount=0;seqcount<seqtotal;seqcount++){
		ctSEQ += (dataseq[seqcount].count)*2+1;
	}
	ctOBJ = datatotal*8;
	ctHV  = 0;
	for(i=0;i<hvtotal;i++)	ctHV += datahv[i].count*2;
	ctCA  = 0;
	for(i=0;i<catotal;i++)	ctCA += dataca[i].count*2;

	printf (";;	OBJ-SEQ   data total %6d bytes\n",ctSEQ);
	printf (";;	OBJ-BLOCK data total %6d bytes\n",ctOBJ);
	printf (";;	OBJ-HV    data total %6d bytes\n",ctHV);
	printf (";;	OBJ-CA    data total %6d bytes\n",ctCA);
	printf (";;- - - - - - - - - - - - - - - - - - - - - - - - - \n");
	printf (";;	DATA TOTAL           %6d bytes (%XH) \n",ctSEQ+ctOBJ+ctHV+ctCA
							,ctSEQ+ctOBJ+ctHV+ctCA);



	/*===== ＳＥＱ情報テーブル作成 =====*/
	printf (";-----------------------------------------------------------------------\n");
	printf ("; SEQ object table\n");
	printf (";-----------------------------------------------------------------------\n");
	printf	("SEQ_%s\n",labelname);
	printf	("	dw	OBJ_%s\n",labelname);
	for (seqcount=0;seqcount<seqtotal;seqcount++){
		printf	("	dw	%s_S_%d\n",labelname,seqcount);
	}



	/*===== ＳＥＱ情報データ作成 =====*/
	printf (";-----------------------------------------------------------------------\n");
	printf ("; SEQ object data\n");
	printf (";-----------------------------------------------------------------------\n");

	for (seqcount=0;seqcount<seqtotal;seqcount++){

		printf	("%s_S_%d\n",labelname,seqcount);

		for(j=0;j<dataseq[seqcount].count;j++){
			printf	("	db	%d,%d\n"
						,dataseq[seqcount].SEQframe[j]
						,dataseq[seqcount].SEQchar[j]);			
		}
		
		printf ("	db	080h\n");

	}


	/*===== ブロックオブジェクトテーブル作成 =====*/
	printf (";-----------------------------------------------------------------------\n");
	printf ("; block object table\n");
	printf (";-----------------------------------------------------------------------\n");
	printf	("OBJ_%s\n",labelname);
	for(datacount=0;datacount<datatotal;datacount++){
		printf	("	dw	%s_%d\n",labelname,datacount);
	}


	/*===== ブロックオブジェクトデータ作成 =====*/
	printf (";-----------------------------------------------------------------------\n");
	printf ("; block object data\n");
	printf (";-----------------------------------------------------------------------\n");

	for(datacount=0;datacount<datatotal;datacount++){

		printf	("%s_%d\n",labelname,datacount);
		printf	("	db	%d,%d\n"
					,programcode
					,dataoam[datacount].count);
		printf	("	dw	%s_HV_%d,%s_CA_%d\n"
					,labelname,dataoam[datacount].pointerHV
					,labelname,dataoam[datacount].pointerCA);

	}

	/*===== Ｈ/Ｖポジションデータ作成 =====*/
	printf (";-----------------------------------------------------------------------\n");
	printf ("; HV position data\n");
	printf (";-----------------------------------------------------------------------\n");

	for(i=0;i<hvtotal;i++){
		printf ("%s_HV_%d\n",labelname,i);
		for(j=0;j<datahv[i].count;j++){
			printf	("	db %03xh,%03xh\n",datahv[i].oamH[j],datahv[i].oamV[j]);
		}
	}

	/*===== Ｃ/Ａキャラクター番号データ作成 =====*/
	printf (";-----------------------------------------------------------------------\n");
	printf ("; CA charcterNO data\n");
	printf (";-----------------------------------------------------------------------\n");

	for(i=0;i<catotal;i++){
		printf ("%s_CA_%d\n",labelname,i);
		for(j=0;j<dataca[i].count;j++){
			printf	("	db %03xh,%03xh\n",dataca[i].oamC[j],dataca[i].oamA[j]);
		}
	}


	printf ("\n");
	printf (";=======================================================================\n");

}



/****************************************************************/
/*	SEQ DATA の取り込み					*/
/****************************************************************/

int	MakeSEQData(unsigned char	*buf)
{
	int	SEQpointer;
	int	i,j;	
	int	SEQpattern;	/* １ＳＥＱパターン数　 */
	int	offset;
	int	framecount;

	SEQpointer = 0;	
	for (i=0;i<16;i++){

		offset = i*0x40+0x3100;	/* 1SEQ = 40h byte */

		SEQpattern = 0;
		for (j=0;j<32;j++){
			if ( *(buf+offset+j*2) != 0 )	SEQpattern++;
		}
		if ( SEQpattern == 0 ) continue;

		dataseq[SEQpointer].count = SEQpattern;

		framecount = 0;
		for (j=0;j<32;j++){
			if ( *(buf+offset+j*2) != 0 ){
				dataseq[SEQpointer].SEQframe[framecount] = *(buf+offset+j*2);
				dataseq[SEQpointer].SEQchar[framecount]  = *(buf+offset+j*2+1);
				framecount++;
			}
		}

		SEQpointer++;
	}


	return(SEQpointer);

}

/****************************************************************/
/*	OBJECT DATA の取り込み					*/
/****************************************************************/

int	MakeOBJData(unsigned char	*buf, int	*datapointer, int	*hvpointer, int *capointer)
{

	int	datacount;
	int	hvcount,cacount;

	int	block;		/* char*64(max) の OBJ-BLOCK 		*/
	int	charcount;
	int	offset;		/* = block*0x180 			*/

	int	objtotal;	/* ブロック内 OBJの 個数 		*/
	int	objcount;	

	int	sameNO;		/* 同じデータがあるかどうかチェック 	*/

	DataCA	nowca;		/* 現在のＨＶＣＡのデータ		*/
	DataHV	nowhv;

	datacount = 0;
	hvcount	  = 0;
	cacount   = 0;


	for (block=0;block<32;block++){
		offset = block*0x180;


		/*-----------このブロックが有効かどうかチェックする -----------*/
		objtotal = 0;
		for (charcount=0;charcount<64;charcount++){
			if ( ( *(buf+offset+charcount*6) & 0x80 ) != 0 ) objtotal++;
		}
		if (objtotal == 0)	continue;	/* なければもどる！	*/

		dataoam[datacount].count  = objtotal;


		/*---------- データを作成する ---------------------------------*/
		nowhv.count 	  = objtotal;
		nowca.count 	  = objtotal;
		objcount = 0;
		for (charcount=0;charcount<64;charcount++){
			if ( ( *(buf+offset+charcount*6) & 0x80 ) != 0 ){
				nowhv.oamV[objcount] = *(buf+offset+charcount*6+2);
				nowhv.oamH[objcount] = *(buf+offset+charcount*6+3);
				nowca.oamA[objcount] = *(buf+offset+charcount*6+4);
				nowca.oamC[objcount] = *(buf+offset+charcount*6+5);
				objcount++;
			}
		}

		/*---------- 同じデータがあれば比較してチェックする-------------*/
		if (datacount == 0){
			dataoam[datacount].pointerHV	= hvcount;
			dataoam[datacount].pointerCA	= cacount;
			HVcopy (&datahv[hvcount],&nowhv);
			CAcopy (&dataca[cacount],&nowca);
			hvcount++;
			cacount++;

		} else {

			if ( (sameNO = HVsamechack(datahv,&nowhv,hvcount) ) == -1 ){
				dataoam[datacount].pointerHV	= hvcount;
				HVcopy (&datahv[hvcount],&nowhv);
				hvcount++;
			}else {
				dataoam[datacount].pointerHV = sameNO;
			}

			if ( (sameNO = CAsamechack(dataca,&nowca,cacount) ) == -1 ){
				dataoam[datacount].pointerCA	= cacount;
				CAcopy (&dataca[cacount],&nowca);
				cacount++;
			} else {
				dataoam[datacount].pointerCA = sameNO;
			}

		}

		datacount++;	/* 次のブロックデータへ */

	}

	*datapointer = datacount;
	*hvpointer   = hvcount;
	*capointer   = cacount;

}




/****************************************************************/
/*	構造体の比較						*/
/****************************************************************/
/*	<< -1 >> の時は共通データ無し				*/
/*--------------------------------------------------------------*/

int HVsamechack(DataHV	*hv2, DataHV	*hv1, int total)
{
/*--------------------------------------------------------------*/
	int	i,j;
	int	checkcount = hv1->count;
	
	for (i=0;i<total;i++){

		for (j=0;j<checkcount;j++){
			if ( (hv1->oamH[j]) != (hv2->oamH[j]) ) break;
			if ( (hv1->oamV[j]) != (hv2->oamV[j]) ) break;
		}
		if (j == checkcount)	return(i);
		hv2++;
	}

	return(-1);

}

/*--------------------------------------------------------------*/

int CAsamechack(DataCA	*ca2, DataCA	*ca1, int total)
{
/*--------------------------------------------------------------*/
	int	i,j;
	int	checkcount = ca1->count;

	for (i=0;i<1;i++){

		for (j=0;j<checkcount;j++){
			if ( (ca1->oamC[j]) != (ca2->oamC[j]) ) break;
			if ( (ca1->oamA[j]) != (ca2->oamA[j]) ) break;
		}
		if (j == checkcount)	return(i);
		ca2++;

	}

	return(-1);

}

/*--------------------------------------------------------------*/


/****************************************************************/
/*	構造体のコピー						*/
/****************************************************************/

/*--------------------------------------------------------------*/
int HVcopy(DataHV	*hv2, DataHV	*hv1)
{
	int	i,total;
	total = hv2->count = hv1->count;
	for (i=0;i<total;i++){
		hv2->oamH[i] = hv1->oamH[i];
		hv2->oamV[i] = hv1->oamV[i];
	}

}
/*--------------------------------------------------------------*/
int CAcopy(DataCA	*ca2, DataCA	*ca1)
{
	int	i,total;
	total = ca2->count = ca1->count;
	for (i=0;i<total;i++){
		ca2->oamC[i] = ca1->oamC[i];
		ca2->oamA[i] = ca1->oamA[i];
	}

}
/*--------------------------------------------------------------*/


