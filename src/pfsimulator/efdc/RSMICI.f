      SUBROUTINE RSMICI(ISMTICI)  
C  
C CHANGE RECORD  
C READ IN SPATIALLY AND/OR TEMPORALLY VARYING ICS (UNIT INSMICI).  
C  
      USE GLOBAL  

      CHARACTER TITLE(3)*79,ICICONT*3  
      REAL,SAVE,ALLOCATABLE,DIMENSION(:)::XSMPOC  
      REAL,SAVE,ALLOCATABLE,DIMENSION(:)::XSMPON  
      REAL,SAVE,ALLOCATABLE,DIMENSION(:)::XSMPOP  

      IF(.NOT.ALLOCATED(XSMPOC))THEN
		ALLOCATE(XSMPOC(NSMGM))
		ALLOCATE(XSMPON(NSMGM))
		ALLOCATE(XSMPOP(NSMGM))
	    XSMPOC=0.0 
	    XSMPON=0.0 
	    XSMPOP=0.0 
	ENDIF
C
      PRINT *,'WQ: SD READING WQSDICI.INP'
      OPEN(1,FILE='WQSDICI.INP',STATUS='OLD')  
      OPEN(2,FILE='WQ3D'//ans(partid2)//'.OUT',STATUS='UNKNOWN',POSITION='APPEND')  
      IF(ISMTICI.EQ.0)THEN  
        READ(1,50) (TITLE(M),M=1,3)  
        WRITE(2,999)  
        WRITE(2,50) (TITLE(M),M=1,3)  
      ENDIF  
      WRITE(2,60)'* INITIAL CONDITIONS AT ', ISMTICI,  
     &    ' TH DAY FROM MODEL START'  
      READ(1,999)  
      READ(1,50) TITLE(1)  
      WRITE(2,50) TITLE(1)  
      DO M=2,LA  
        READ(1,*) I,J,(XSMPON(NW),NW=1,NSMG),  
     &      (XSMPOP(NW),NW=1,NSMG),(XSMPOC(NW),NW=1,NSMG),XSM1NH4,  
     &      XSM2NH4,XSM2NO3,XSM2PO4,XSM2H2S,XSMPSI,XSM2SI,XSMBST,XSMT  
        WRITE(2,90) I,J,(XSMPON(NW),NW=1,NSMG),  
     &      (XSMPOP(NW),NW=1,NSMG),(XSMPOC(NW),NW=1,NSMG),XSM1NH4,  
     &      XSM2NH4,XSM2NO3,XSM2PO4,XSM2H2S,XSMPSI,XSM2SI,XSMBST,XSMT  
        IF(IJCT(I,J).LT.1 .OR. IJCT(I,J).GT.8)THEN  
          PRINT*, 'I, J, LINE# = ', I,J,M-1  
          STOP 'ERROR!! INVALID (I,J) IN FILE WQSDICI.INP'  
        ENDIF  
        L=LIJ(I,J)  
        DO MM=1,NSMG  
          SMPON(L,MM)=XSMPON(MM)  
          SMPOP(L,MM)=XSMPOP(MM)  
          SMPOC(L,MM)=XSMPOC(MM)  
        ENDDO  
        SM1NH4(L)=XSM1NH4  
        SM2NH4(L)=XSM2NH4  
        SM2NO3(L)=XSM2NO3  
        SM2PO4(L)=XSM2PO4  
        SM2H2S(L)=XSM2H2S  
        SMPSI(L) =XSMPSI  
        SM2SI(L) =XSM2SI  
        SMBST(L) =XSMBST  
        SMT(L)   =XSMT  
      ENDDO  
      READ(1,52) ISMTICI, ICICONT  
      WRITE(2,52) ISMTICI, ICICONT  
      IF(ICICONT.EQ.'END')THEN  
        CLOSE(1)  
        ISMICI = 0  
      ENDIF  
      CLOSE(2)  
  999 FORMAT(1X)  
   50 FORMAT(A79)  
   52 FORMAT(I7, 1X, A3)  
   60 FORMAT(/, A24, I5, A24)  
   84 FORMAT(3I5, 20F8.4, F8.2)  
   90 FORMAT(2I5, 18E12.4)  
      RETURN  
      END  
