	SUBROUTINE REFLECTION(TT,TNT,FMOLE)
	INCLUDE 'SOLDIV.FI'
	PARAMETER (NH = 5)
	DIMENSION RN(NH,NH)
C	CALCULATES ATOMIC REFLECTION AND MOLECULAR RE-EMISSION FRACTIONS
C	FOR NEUTRAL OR ION AT TEMPERATURE TT--1-FMOLE AND FMOLE--AND TEMP
C	OF REFLECTED NEUTRAL ATOM (AFTER DISSOCIATION)--TNT 
c	atomic/molecular split on reflection
	IF(IMOL.EQ.0) GOTO 150  
	IF(TT.GE.TINT(2).AND.TD.LT.TINT(3)) IN = 2
 	IF(TT.GE.TINT(3).AND.TD.LE.TINT(4)) IN = 3
      IF(TT.GT.TINT(4)) GOTO 10
 	IF(TT.LT.TINT(2)) GOTO 15
	EMOL = 2.0
C	 NEUTRAL ATOM REFLECTION COEFICIENTS @ 1, 10 AND 100 eV
C		(POP,2,3740,1995)
C	ACTUALLY TABULATE & INTERPOLATE 1 - RN	
C		BERYLLIUM
	RN(1,2) = 0.82
	RN(1,3) = 0.82 
	RN(1,4) = 0.91
C		CARBON
	RN(2,2) = 0.67
	RN(2,3) = 0.67
	RN(2,4) = 0.82
C		TUNGSTEN
	RN(3,2) = 0.24
	RN(3,3) = 0.24
	RN(3,4) = 0.40 
	
C		TEMPERATURE INTERPOLATION

      W = LOG10(RN(IMAT,IN)) + LOG10(RN(IMAT,IN+1)/RN(IMAT,IN))*
     2    LOG10(TT/TINT(IN))/LOG10(TINT(IN+1)/TINT(IN))
	FMOLE = 10.**W 
	RNNE = 1. - FMOLE	
	GOTO 20
C	USE THE 100 eV RE-EMISSION COEF FOR T > 100 eV
10	FMOLE = RN(IMAT,4)
	RNNE = 1. - FMOLE 
 	IF(IMOL.EQ.0) GOTO 150

	GOTO 20
C	USE THE 1 eV RE-EMISSION COEF FOR T < 1 eV
15	FMOLE = RN(IMAT,2)
	RNNE = 1. - FMOLE 

20	CONTINUE 
	GOTO 200 
150	FMOLE = 0.0
	RNNE = 1. - FMOLE 

200   TNT = (0.5*(1.-FMOL)*TT + FMOL*EMOL) 

	RETURN
	END