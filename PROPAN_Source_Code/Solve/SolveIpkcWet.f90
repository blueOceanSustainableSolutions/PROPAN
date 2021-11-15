!-----------------------------------------------------------------------------------------------!
!    Solve Iterative Pressure Kutta Condition                                                   !
!    Copyright (C) 2021  J. Baltazar                                                            !
!                                                                                               !
!    This program is free software: you can redistribute it and/or modify it under the terms of !
!    the GNU Affero General Public License as published by the Free Software Foundation, either !
!    version 3 of the License, or (at your option) any later version.                           !
!                                                                                               !
!    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  !
!    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  !
!    See the GNU Affero General Public License for more details.                                !
!                                                                                               !
!    You should have received a copy of the GNU Affero General Public License                   !
!    along with this program.  If not, see <https://www.gnu.org/licenses/>.                     !
!-----------------------------------------------------------------------------------------------!
SUBROUTINE SOLVEIPKCWET(JJ,TT)
!-----------------------------------------------------------------------------------------------!
!    Created by: J. Baltazar, IST                                                               !
!    Modified  : 26112013, J. Baltazar, version 1.0                                             !
!    Modified  : 28102014, J. Baltazar, Interpolation scheme at nozzle t.e.                     !
!    Modified  : 06112014, J. Baltazar, VELH and PRESH only for IH=1                            !
!    Modified  : 27112014, J. Baltazar, version 3.3, Super-Cavitation Model                     !
!    Modified  : 26052016, J. Baltazar, 2016 version 1.2                                        !
!    Modified  : 02062016, J. Baltazar, 2016 version 1.3                                        !
!    Modified  : 25102016, J. Baltazar, 2016 version 1.4, Broyden's Method for IPKC             !
!-----------------------------------------------------------------------------------------------!
USE PROPAN_MOD
IMPLICIT NONE
INTEGER :: I,J,K,KB,KK,JJ,TT
INTEGER :: INFO,IPVTK(NRT)
DOUBLE PRECISION :: ERRK,ERRK0,BETA1,PDET(2),DDOT
DOUBLE PRECISION :: PJACOB(NRT,NRT),PJACOBINV(NRT,NRT),DELPOTW(NRT),DELPOT(NPAN1)
DOUBLE PRECISION :: WORKB2(NRT),WORKB3(NRT)
!-----------------------------------------------------------------------------------------------!
ALLOCATE(WORKA1(NRT),WORKA2(NRT),WORKA3(NRT),WORKM1(NRT,NRT),WORKM2(NRT,NRT))
WORKA1=0.D0
WORKA2=0.D0
WORKA3=0.D0
WORKM1=0.D0
WORKM2=0.D0
!-----------------------------------------------------------------------------------------------!
!    Recover the Original Influence Matrix                                                      !
!-----------------------------------------------------------------------------------------------!
!    Steady Case                                                                                !
!-----------------------------------------------------------------------------------------------!
IF (TT == 0) THEN
   IF (ISOLVER == 0) THEN
      REWIND(22)
      READ  (22) ((DIJ(I,J,1),I=1,NPAN),J=1,NPAN )
   ELSE !(ISOLVER == 0)
      REWIND(21)
      READ  (21) ((DIJ(I,J,1),I=1,NPAN),J=1,NPAN )
      DO KB=2,NB
         DIJ(:,:,1)=DIJ(:,:,1)+DIJ(:,:,KB)
      END DO !KB=2,NB
   END IF !(ISOLVER == 0)
END IF !(TT == 0)
!-----------------------------------------------------------------------------------------------!
!    Unsteady Case                                                                              !
!-----------------------------------------------------------------------------------------------!
IF (TT /= 0) THEN
   IF (ISOLVER == 0) THEN
      REWIND(25)
      READ  (25) ((DIJ(I,J,1),I=1,NPAN),J=1,NPAN)
   ELSE !(ISOLVER == 0)
      REWIND(21)
      READ  (21) ((DIJ(I,J,1),I=1,NPAN),J=1,NPAN)
   END IF !(ISOLVER == 0)
END IF !(TT /= 0)
!-----------------------------------------------------------------------------------------------!
!    Save Basic Solution of the Linear Kutta Condition                                          !
!-----------------------------------------------------------------------------------------------!
RHS(1:NPAN)=SI(1:NPAN)
!-----------------------------------------------------------------------------------------------!
!    Calculate Error in Pressure of Linear Kutta Condition at t.e. (Max Norm)                   !
!-----------------------------------------------------------------------------------------------!
ERRK0=0.D0
WORKA1(    1:NRW)=DABS(DCP(1:NRW ))
WORKA1(NRW+1:NRT)=DABS(DCN(1:NNTP))
CALL DSORT(WORKA1,WORKA2,NRT,-1)
ERRK0=WORKA1(1)
ERRK =0.D0
!-----------------------------------------------------------------------------------------------!
!    Compute Numerically the Jacobian Matrix                                                    !
!-----------------------------------------------------------------------------------------------!
!    Disturb the Basic Solution                                                                 !
!-----------------------------------------------------------------------------------------------!
BETA1=BETA
PJACOB=0.D0
CALL JACOBIANWET(JJ,TT,BETA1,PJACOB)
!-----------------------------------------------------------------------------------------------!
!    Factorize Jacobian Matrix                                                                  !
!-----------------------------------------------------------------------------------------------!
INFO=0
CALL DGEFA(PJACOB,NRT,NRT,IPVTK,INFO)
IF (INFO /= 0) THEN
   WRITE(6,*) 'JacobianWet',INFO
   STOP
END IF !(INFO /= 0)
!-----------------------------------------------------------------------------------------------!
!    Invert Jacobian Matrix                                                                     !
!-----------------------------------------------------------------------------------------------!
IF (MKIT == 1) THEN
   PJACOBINV=PJACOB
   CALL DGEDI(PJACOBINV,NRT,NRT,IPVTK,PDET,WORKA3,01)
END IF !(MKIT == 1)
!-----------------------------------------------------------------------------------------------!
!    Start Iteration                                                                            !
!-----------------------------------------------------------------------------------------------!
DO KK=1,NKIT
!-----------------------------------------------------------------------------------------------!
!    Update Jacobian Matrix                                                                     !
!-----------------------------------------------------------------------------------------------!
!    Newton-Raphson Method                                                                      !
!-----------------------------------------------------------------------------------------------!
   IF ((MKIT == 0).AND.(KK > 2).AND.(ERRK > ERRK0)) THEN
!-----------------------------------------------------------------------------------------------!
!    Disturb the Previous Solution                                                              !
!-----------------------------------------------------------------------------------------------!
      BETA1=BETA1/5.D0 !Fine perturbation parameter Beta
      CALL JACOBIANWET(JJ,TT,BETA1,PJACOB)
!-----------------------------------------------------------------------------------------------!
!    Factorize Jacobian Matrix                                                                  !
!-----------------------------------------------------------------------------------------------!
      INFO=0
      CALL DGEFA(PJACOB,NRT,NRT,IPVTK,INFO)
      IF (INFO /= 0) THEN
         WRITE(6,*) 'JacobianWet',INFO
         STOP
      END IF !(INFO /= 0)
   END IF !((MKIT == 0).AND.(KK > 2).AND.(ERRK > ERRK0))
!-----------------------------------------------------------------------------------------------!
!    Broyden's Method                                                                           !
!-----------------------------------------------------------------------------------------------!
   IF ((MKIT == 1).AND.(KK > 1)) THEN
      WORKA3(1    :NRW)=DCP(1:NRW )
      WORKA3(NRW+1:NRT)=DCN(1:NNTP)
      CALL DGEMM('N','N',NRT,1,NRT,1.D0,PJACOBINV,NRT,WORKA3,NRT,0.D0,WORKB2,NRT)
      WORKB3=DELPOTW+WORKB2
      WORK1 =-1.D0/DDOT(NRT,DELPOTW,1,WORKB3,1)
      CALL DGEMM('N','T',NRT,NRT,1,1.D0,WORKB2,NRT,DELPOTW,NRT,0.D0,WORKM1,NRT)
      WORKM2=PJACOBINV
      CALL DGEMM('N','N',NRT,NRT,NRT,WORK1,WORKM1,NRT,WORKM2,NRT,1.D0,PJACOBINV,NRT)
   END IF !((MKIT == 1).AND.(KK > 1))
!-----------------------------------------------------------------------------------------------!
!    Newton-Raphson Method System of Equations                                                  !
!-----------------------------------------------------------------------------------------------!
   IF (MKIT == 0) THEN
!-----------------------------------------------------------------------------------------------!
!    Right-Hand-Side                                                                            !
!-----------------------------------------------------------------------------------------------!
      DELPOTW(1    :NRW)=-DCP(1:NRW )
      DELPOTW(NRW+1:NRT)=-DCN(1:NNTP)
!-----------------------------------------------------------------------------------------------!
!    Solution of System of Equations                                                            !
!-----------------------------------------------------------------------------------------------!
      CALL DGESL(PJACOB,NRT,NRT,IPVTK,DELPOTW,0)
   END IF !(MKIT == 0)
!-----------------------------------------------------------------------------------------------!
!    Broyden's Method System of Equations                                                       !
!-----------------------------------------------------------------------------------------------!
   IF (MKIT == 1) THEN
!-----------------------------------------------------------------------------------------------!
!    Right-Hand-Side                                                                            !
!-----------------------------------------------------------------------------------------------!
      WORKA3(1    :NRW)=-DCP(1:NRW )
      WORKA3(NRW+1:NRT)=-DCN(1:NNTP)
!-----------------------------------------------------------------------------------------------!
!    Solution of System of Equations                                                            !
!-----------------------------------------------------------------------------------------------!
      DELPOTW=0.D0
      CALL DGEMM('N','N',NRT,1,NRT,1.D0,PJACOBINV,NRT,WORKA3,NRT,0.D0,DELPOTW,NRT)
   END IF !(MKIT == 1)
!-----------------------------------------------------------------------------------------------!
   IF (NT == 0) THEN
      DO I=1,NPAN
         DELPOT(I)=0.D0
         DO KB=1,NB
            DO J=1,NRW
               DELPOT(I)=DELPOT(I)+WIJ(I,J,KB)*DELPOTW(J)
            END DO !J=1,NRW
            DO J=1,NNTP
               DELPOT(I)=DELPOT(I)+WIJ(I,NRW+J,KB)*DELPOTW(NRW+J)
            END DO !J=1,NNTP
         END DO !KB=1,NB
      END DO !I=1,NPAN
   ELSEIF (TT == 0) THEN
      DO I=1,NPAN
         DELPOT(I)=0.D0
         DO KB=1,NB
            DO J=1,NRW
               DO K=((J-1)*NPW+1),(J*NPW)
                  DELPOT(I)=DELPOT(I)+WIJ(I,K,KB)*DELPOTW(J)
               END DO !K=((J-1)*NPW+1),(J*NPW)
            END DO !J=1,NRW
            DO J=1,NNTP
               DO K=((J-1)*NNW+1),(J*NNW)
                  DELPOT(I)=DELPOT(I)+WIJ(I,NPWPAN+K,KB)*DELPOTW(NRW+J)
               END DO !K=((J-1)*NNW+1),(J*NNW)
            END DO !J=1,NNTP
         END DO !KB=1,NB
      END DO !I=1,NPAN
   ELSE !(TT)
      DO I=1,NPAN
         DELPOT(I)=0.D0
         DO J=1,NRW
            DELPOT(I)=DELPOT(I)+KIJ(I,J,1)*DELPOTW(J)
         END DO !J=1,NRW
         DO J=1,NNTP
            DELPOT(I)=DELPOT(I)+KIJ(I,NRW+J,1)*DELPOTW(NRW+J)
         END DO !J=1,NNTP
      END DO !I=1,NPAN
   END IF !(TT)
!-----------------------------------------------------------------------------------------------!
!    Solution of System of Equations                                                            !
!-----------------------------------------------------------------------------------------------!
   IF ((TT == 0).AND.(ISOLVER == 0)) CALL DGESL(DIJ(:,:,1),NPAN1,NPAN,IPVT1,DELPOT,0)
   IF ((TT /= 0).AND.(ISOLVER == 0)) CALL DGESL(DIJ(:,:,1),NPAN1,NPAN,IPVT3,DELPOT,0)
!-----------------------------------------------------------------------------------------------!
!    Iterative Solver                                                                           !
!-----------------------------------------------------------------------------------------------!
   IF (ISOLVER == 1) CALL BISOF(DIJ(:,:,1),NPAN1,NPAN,DELPOT)
!-----------------------------------------------------------------------------------------------!
!    Update Total Perturbation Wake Potential                                                   !
!-----------------------------------------------------------------------------------------------!
   DO J=1,NRW
      DPOTP(J)=DPOTP(J)+DELPOTW(J)
   END DO !J=1,NRW
!-----------------------------------------------------------------------------------------------!
   DO J=1,NNTP
      DPOTN(J)=DPOTN(J)+DELPOTW(NRW+J)
   END DO !J=1,NNTP
!-----------------------------------------------------------------------------------------------!
!    Update the Solution                                                                        !
!-----------------------------------------------------------------------------------------------!
   SI (1:NPAN)=SI(1:NPAN)+DELPOT(1:NPAN)
   RHS(1:NPAN)=SI(1:NPAN)
!-----------------------------------------------------------------------------------------------!
!    Structure the Potential Solution                                                           !
!-----------------------------------------------------------------------------------------------!
!    Blade                                                                                      !
!-----------------------------------------------------------------------------------------------!
   POTP(:,:,TT)=RESHAPE(SI(NHPAN+1:NHPAN+NPPAN),(/NCP,NRP/))
!-----------------------------------------------------------------------------------------------!
!    Blade Wake                                                                                 !
!-----------------------------------------------------------------------------------------------!
   IF (NCPW < 0) POTPWP(:,:,TT)=RESHAPE(SI(NHPAN+NPPAN+NNPAN+1:NPAN),(/IABS(NCPW),NRW/))
   IF (NCPW > 0) POTPWS(:,:,TT)=RESHAPE(SI(NHPAN+NPPAN+NNPAN+1:NPAN),(/IABS(NCPW),NRW/))
!-----------------------------------------------------------------------------------------------!
!    Nozzle                                                                                     !
!-----------------------------------------------------------------------------------------------!
   POTN(:,:,TT)=RESHAPE(SI(NHPAN+NPPAN+1:NHPAN+NPPAN+NNPAN),(/NNXT1,NNTP/))
!-----------------------------------------------------------------------------------------------!
!    Hub                                                                                        !
!-----------------------------------------------------------------------------------------------!
   POTH(:,:,TT)=RESHAPE(SI(1:NHPAN),(/NHX,NHTP/))
!-----------------------------------------------------------------------------------------------!
!    Blade Velocities and Pressure                                                              !
!-----------------------------------------------------------------------------------------------!
   IF (IP == 1) THEN
      CALL VELP(TT)
      CALL PRESP(JJ,TT)
   END IF !(IP == 1)
!-----------------------------------------------------------------------------------------------!
!    Blade Wake Velocities                                                                      !
!-----------------------------------------------------------------------------------------------!
   IF (IP == 1) THEN
      CALL VELPW(TT)
   END IF !(IP == 1)
!-----------------------------------------------------------------------------------------------!
!    Nozzle Velocities and Pressure                                                             !
!-----------------------------------------------------------------------------------------------!
   IF (IN == 1) THEN
      CALL VELN(TT)
      CALL PRESN(JJ,TT)
   END IF !(IN == 1)
!-----------------------------------------------------------------------------------------------!
!    Hub Velocities and Pressure                                                                !
!-----------------------------------------------------------------------------------------------!
   IF (IH == 1) THEN
      CALL VELH(TT)
      CALL PRESH(JJ,TT)
   END IF !(IH == 1)
!-----------------------------------------------------------------------------------------------!
!    Pressure Jump at the Blade Trailing Edge                                                   !
!-----------------------------------------------------------------------------------------------!
   DCP(:)=CPP(NCP,JI:JF,TT)-CPP(1,JI:JF,TT)
!-----------------------------------------------------------------------------------------------!
!    Pressure Jump at the Nozzle Trailing Edge                                                  !
!-----------------------------------------------------------------------------------------------!
   CALL PRESNTE(TT,DCN)
!-----------------------------------------------------------------------------------------------!
!    Dipole Strength in the Blade Wake                                                          !
!-----------------------------------------------------------------------------------------------!
   IF (TT == 0) THEN
      DO J=1,NRW
         POTPW(:,J, 0)=DPOTP(J)
      END DO !J=1,NRW
   ELSE !(TT == 0)
      DO J=1,NRW
         POTPW(1,J,TT)=DPOTP(J)
      END DO !J=1,NRW
   END IF !(TT == 0)
!-----------------------------------------------------------------------------------------------!
!    Dipole Strength in the Nozzle Wake                                                         !
!-----------------------------------------------------------------------------------------------!
   IF (TT == 0) THEN
      DO J=1,NNTP
         POTNW(:,J, 0)=DPOTN(J)
      END DO !J=1,NNTP
   ELSE !(TT == 0)
      DO J=1,NNTP
         POTNW(1,J,TT)=DPOTN(J)
      END DO !J=1,NNTP
   END IF !(TT == 0)
!-----------------------------------------------------------------------------------------------!
!    Convergence Criterion of Kutta Condition                                                   !
!-----------------------------------------------------------------------------------------------!
   IF (ERRK /= 0.D0) ERRK0=ERRK
!-----------------------------------------------------------------------------------------------!
   ERRK=0.D0
   WORKA1(    1:NRW)=DABS(DCP(1:NRW ))
   WORKA1(NRW+1:NRT)=DABS(DCN(1:NNTP))
   CALL DSORT(WORKA1,WORKA2,NRT,-1)
   ERRK=WORKA1(IK)
!-----------------------------------------------------------------------------------------------!
!    Write Convergence of Kutta Condition                                                       !
!-----------------------------------------------------------------------------------------------!
   WRITE(20,*) 'Kutta Condition Iter=',KK,' ERRK=',ERRK
!-----------------------------------------------------------------------------------------------!
   IF (ERRK < TOLK) GOTO 1000
!-----------------------------------------------------------------------------------------------!
END DO !KK=1,NKIT
1000 CONTINUE
!-----------------------------------------------------------------------------------------------!
!    Deallocate                                                                                 !
!-----------------------------------------------------------------------------------------------!
DEALLOCATE(WORKA1,WORKA2,WORKA3,WORKM1,WORKM2)
!-----------------------------------------------------------------------------------------------!
END SUBROUTINE SOLVEIPKCWET
!-----------------------------------------------------------------------------------------------!
