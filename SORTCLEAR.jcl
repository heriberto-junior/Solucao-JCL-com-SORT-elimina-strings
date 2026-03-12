//SORTCLEAR JOB CLASS=L,MSGCLASS=X,NOTIFY=&SYSUID,                  
//              REGION=2M,TIME=500                                  
//*---------------------------------------------------------------*
//COPYHDR  EXEC PGM=SORT                                           
//SYSOUT   DD SYSOUT=*                                             
//SORTIN   DD DSN=ENDERECO.DA.ENTRADA,DISP=SHR                       
//SORTOUT  DD DSN=&&COPYTMP,                                       
//            DISP=(NEW,PASS,DELETE),                              
//            UNIT=SYSDA,SPACE=(TRK,(1,1),RLSE),                   
//            DCB=(RECFM=FB,LRECL=31)                              
//SYSIN    DD *                                                    
  OPTION COPY,STOPAFT=3                                            
/*                                                                 
//*---------------------------------------------------------------*
//SORTDET  EXEC PGM=SORT                                           
//SYSOUT   DD SYSOUT=*                                             
//SORTIN   DD DSN=ENDERECO.DA.ENTRADA,DISP=SHR                       
//SORTOUT  DD DSN=&&COPYTMP,DISP=MOD                               
//SYSIN    DD *                                                    
  OPTION SKIPREC=3                                                 
                                                                   
  OMIT COND=((1,5,CH,EQ,C'READY'),                                 
              OR,                                                  
             (1,3,CH,EQ,C'END'))                                   
                                                                   
  SORT FIELDS=(28,4,CH,A,10,7,CH,A)                                
                                                                   
  SUM FIELDS=NONE                                                  
/*                                                                 
//*---------------------------------------------------------------*
//EIBSORT  EXEC PGM=IEBGENER        
//SYSPRINT DD DUMMY                 
//SYSIN    DD DUMMY                 
//SYSUT1   DD DISP=SHR,DSN=&&COPYTMP
//SYSUT2   DD DSN=ENDERECO.DO.RESULT,                                       
//            DISP=(NEW,PASS,DELETE),                              
//            UNIT=SYSDA,SPACE=(TRK,(1,1),RLSE),                   
//            DCB=(RECFM=FB,LRECL=31)            
