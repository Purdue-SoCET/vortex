//Taken from https://github.com/AhmedYousriSobhi/Hex-To-array-txt/edit/main/hextoarray.c
//Converts hex file to C array
#include<stdio.h>
#include<stdint.h>
#define PAGESIZE 128
#define FILLBYTES 16
int main(int argc, char *argv[])
{
	uint8_t tempc, datasize, recordDataSize, loopindex=0, flagfirsttime=1, eof=0, stored=0;
	uint16_t byteCount_1, byteCount_2, NoOfPage=1;
	uint16_t arrayByteCounter = 0;
	FILE *cfptr_hex;
	FILE *cfptr_txt;
	printf("*C_DEBUG: Program STARTED*\n");
	if((cfptr_hex = fopen(argv[1],"r")) == NULL)
	{
		printf("*C_DEBUG: .TXT FILE COULD NOT BE OPENNED|Created*\n");
	}
	else 
	{
		printf("*C_DEBUG: HEX FILE IS OPENNED!!*\n");
		if((cfptr_txt = fopen("OutputArray.txt","w")) == NULL)
			{
				printf("*C_DEBUG: Could not Create Txt file*\n");
				fclose(cfptr_hex);
				printf("*C_DEBUG: HEX FILE IS CLOSED SUCCESSFULY!!!*\n");
			}
		else
		{	
			printf("*C_DEBUG: OutputArray.txt IS CREATED*\n");
			printf("*C_DEBUG: STARTING READ BYTES FROM Hex FILE*\n");	
			printf("*C_DEBUG: CHECKING HEX FILE*\n");
			fprintf(cfptr_txt,"%s", "{"); /*Starting of the output array*/
			fputc('\n',cfptr_txt); /*new line*/
			/*read bytes of each signle Line from Hex file*/
			while( (fgetc(cfptr_hex) == ':') && (eof == 0) ) 
			{
				/*
				printf("*C_DEBUG: Hex record is Correct number = ");
				printf("%d *\n", recordindex);
				*/
				/*Check Byte Count in Intel Hex Format:*/
				byteCount_1 = fgetc(cfptr_hex);
				if(byteCount_1 >= 'A') byteCount_1 = (byteCount_1 - 'A' + 10)*16;
				else byteCount_1 = (byteCount_1 - '0')*16;
				
				byteCount_2 = fgetc(cfptr_hex);
				if(byteCount_2 >= 'A') byteCount_2 = byteCount_2 - 'A' +10;
				else byteCount_2 = byteCount_2 - '0';
				
				recordDataSize = byteCount_1 + byteCount_2;
				arrayByteCounter += recordDataSize;	
				//printf("C_DEBUG: DataSize in line = %d\n", recordDataSize);
				if(recordDataSize != 0)
				{	
					/*Igonre the coming 6 address and record type bytes*/
					for(loopindex =0; loopindex<6; loopindex++) tempc=fgetc(cfptr_hex);
					/*Reading the data bytes*/
					for(loopindex=0; loopindex<recordDataSize; loopindex++)
					{
						fprintf(cfptr_txt,"%s", " 0x");
						fputc(fgetc(cfptr_hex),cfptr_txt);
						fputc(fgetc(cfptr_hex),cfptr_txt);
						fputc(',', cfptr_txt);
					}
					/*ignore checksum*/
					do{
						tempc = fgetc(cfptr_hex);
					}while(tempc!='\n');
					fputc('\n',cfptr_txt); /*new line*/
					flagfirsttime = 1; /*reset flag*/
				}
				else eof = 1;	
			}
			while(arrayByteCounter > PAGESIZE*NoOfPage)
			{	
				NoOfPage++;
			}
			uint16_t NoFillBytes = PAGESIZE*NoOfPage - arrayByteCounter;
			/*Fill Bytes are placed 16 bytes line length*/			
			for(loopindex = 1; loopindex<=(NoFillBytes); loopindex++)
				{					
					if(NoFillBytes - loopindex == 0) fprintf(cfptr_txt,"%s", " 0xFF");
					else fprintf(cfptr_txt,"%s", " 0xFF,");
					//printf("%d\n", loopindex%FILLBYTES);
					if(loopindex%FILLBYTES == 0) fputc('\n',cfptr_txt); /*new line*/
				}				
			fprintf(cfptr_txt,"%s","\n};\n\n");
			fprintf(cfptr_txt,"%s","#define CODE_SIZE ");
			fprintf(cfptr_txt,"%d\n",PAGESIZE*NoOfPage);
			fprintf(cfptr_txt,"%s","#define NO_OF_PAGES ");
			fprintf(cfptr_txt,"%d\n",NoOfPage);
			fclose(cfptr_txt);	
			fclose(cfptr_hex);
			printf("*C_DEBUG: .TXT FILE IS CREATED SUCCESSFULY!!!*\n");
		}
	}
	return 0;
}
