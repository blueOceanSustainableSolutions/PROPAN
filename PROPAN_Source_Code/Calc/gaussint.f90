!-----------------------------------------------------------------------------------------------!
!    Subroutine GAUSS2M computes the abcissas and weigths for the Gaussian integration of       !
!    orders powers of 2.                                                                        !
!    Copyright (C) 2021  J.A.C. Falcão de Campos and J. Baltazar                                !
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
SUBROUTINE GAUSS2M(N,X,W)
!-----------------------------------------------------------------------------------------------!
IMPLICIT NONE
INTEGER :: N
DOUBLE PRECISION :: X(N),W(N)
!-----------------------------------------------------------------------------------------------!
IF (N == 2) THEN
   X(1)=-0.577350269189626D0
   X(2)= 0.577350269189626D0
   W(1)= 1.0D0
   W(2)= 1.0D0
END IF !(N == 2)
!-----------------------------------------------------------------------------------------------!
IF (N == 4) THEN
   X(1)=-0.861136311594053D0
   X(2)=-0.339981043584856D0
   X(3)= 0.339981043584856D0
   X(4)= 0.861136311594053D0
   W(1)= 0.347854845137454D0
   W(2)= 0.652145154862546D0
   W(3)= 0.652145154862546D0
   W(4)= 0.347854845137454D0
END IF !(N == 4)
!-----------------------------------------------------------------------------------------------!
IF (N == 8) THEN
   X(1)=-0.960289856497536D0
   X(2)=-0.796666477413627D0
   X(3)=-0.525532409916329D0
   X(4)=-0.183434642495650D0
   X(5)= 0.183434642495650D0
   X(6)= 0.525532409916329D0
   X(7)= 0.796666477413627D0
   X(8)= 0.960289856497536D0
   W(1)= 0.101228536290376D0
   W(2)= 0.222381034453374D0
   W(3)= 0.313706645877887D0
   W(4)= 0.362683783378362D0
   W(5)= 0.362683783378362D0
   W(6)= 0.313706645877887D0
   W(7)= 0.222381034453374D0
   W(8)= 0.101228536290376D0
END IF !(N == 8)
!-----------------------------------------------------------------------------------------------!
IF (N == 16) THEN
   X(1) =-0.989400934991649D0
   X(2) =-0.944575023073232D0
   X(3) =-0.865631202387831D0
   X(4) =-0.755404408355003D0
   X(5) =-0.617876244402643D0
   X(6) =-0.458016777657227D0
   X(7) =-0.281603550779258D0
   X(8) =-0.095012509837637D0
   X(9) = 0.095012509837637D0
   X(10)= 0.281603550779258D0
   X(11)= 0.458016777657227D0
   X(12)= 0.617876244402643D0
   X(13)= 0.755404408355003D0
   X(14)= 0.865631202387831D0
   X(15)= 0.944575023073232D0
   X(16)= 0.989400934991649D0
   W(1) = 0.027152459411754D0
   W(2) = 0.062253523938647D0
   W(3) = 0.095158511682492D0
   W(4) = 0.124628971255533D0
   W(5) = 0.149595988816576D0
   W(6) = 0.169156519395002D0
   W(7) = 0.182603415044923D0
   W(8) = 0.189450610455068D0
   W(9) = 0.189450610455068D0
   W(10)= 0.182603415044923D0
   W(11)= 0.169156519395002D0
   W(12)= 0.149595988816576D0
   W(13)= 0.124628971255533D0
   W(14)= 0.095158511682492D0
   W(15)= 0.062253523938647D0
   W(16)= 0.027152459411754D0
END IF !(N == 16)
!-----------------------------------------------------------------------------------------------!
IF (N == 32) THEN
   X(1) =-0.997263861849481D0
   X(2) =-0.985611511545268D0
   X(3) =-0.964762255587506D0
   X(4) =-0.934906075937739D0
   X(5) =-0.896321155766052D0
   X(6) =-0.849367613732569D0
   X(7) =-0.794483795967942D0
   X(8) =-0.732182118740289D0
   X(9) =-0.663044266930215D0
   X(10)=-0.587715757240762D0
   X(11)=-0.506899908932229D0
   X(12)=-0.421351276130635D0
   X(13)=-0.331868602282127D0
   X(14)=-0.239287362252137D0
   X(15)=-0.144471961582796D0
   X(16)=-0.048307665687738D0
   X(17)= 0.048307665687738D0
   X(18)= 0.144471961582796D0
   X(19)= 0.239287362252137D0
   X(20)= 0.331868602282127D0
   X(21)= 0.421351276130635D0
   X(22)= 0.506899908932229D0
   X(23)= 0.587715757240762D0
   X(24)= 0.663044266930215D0
   X(25)= 0.732182118740289D0
   X(26)= 0.794483795967942D0
   X(27)= 0.849367613732569D0
   X(28)= 0.896321155766052D0
   X(29)= 0.934906075937739D0
   X(30)= 0.964762255587506D0
   X(31)= 0.985611511545268D0
   X(32)= 0.997263861849481D0
   W(1) = 0.007018610009470D0
   W(2) = 0.016274394730905D0
   W(3) = 0.025392065309262D0
   W(4) = 0.034273862913021D0
   W(5) = 0.042835898022226D0
   W(6) = 0.050998059262376D0
   W(7) = 0.058684093478535D0
   W(8) = 0.065822222776361D0
   W(9) = 0.072345794108848D0
   W(10)= 0.078193895787070D0
   W(11)= 0.083311924226946D0
   W(12)= 0.087652093004403D0
   W(13)= 0.091173878695763D0
   W(14)= 0.093844399080804D0
   W(15)= 0.095638720079274D0
   W(16)= 0.096540088514727D0
   W(17)= 0.096540088514727D0
   W(18)= 0.095638720079274D0
   W(19)= 0.093844399080804D0
   W(20)= 0.091173878695763D0
   W(21)= 0.087652093004403D0
   W(22)= 0.083311924226946D0
   W(23)= 0.078193895787070D0
   W(24)= 0.072345794108848D0
   W(25)= 0.065822222776361D0
   W(26)= 0.058684093478535D0
   W(27)= 0.050998059262376D0
   W(28)= 0.042835898022226D0
   W(29)= 0.034273862913021D0
   W(30)= 0.025392065309262D0
   W(31)= 0.016274394730905D0
   W(32)= 0.007018610009470D0
END IF !(N == 32)
!-----------------------------------------------------------------------------------------------!
END SUBROUTINE GAUSS2M
!===============================================================================================!
SUBROUTINE GAUSS2M3(N,X,Y,Z,W)
!-----------------------------------------------------------------------------------------------!
!    Subroutine GAUSS2M3 computes the abcissas and weigths for the Gaussian integration on      !
!    triangles up to the 3rd order.                                                             !
!-----------------------------------------------------------------------------------------------!
IMPLICIT NONE
INTEGER :: N
DOUBLE PRECISION :: X(N),Y(N),Z(N),W(N)
!-----------------------------------------------------------------------------------------------!
IF (N == 1) THEN
   X(1)=1.D0/3.D0
   Y(1)=1.D0/3.D0
   Z(1)=1.D0/3.D0
   W(1)=0.5D0
END IF !(N == 1)
!-----------------------------------------------------------------------------------------------!
IF (N == 3) THEN
   X(1)=0.5D0
   X(2)=0.5D0
   X(3)=0.D0
   Y(1)=0.D0
   Y(2)=0.5D0
   Y(3)=0.5D0
   Z(1)=0.5D0
   Z(2)=0.D0
   Z(3)=0.5D0
   W(1)=1.D0/6.D0
   W(2)=1.D0/6.D0
   W(3)=1.D0/6.D0
END IF !(N == 3)
!-----------------------------------------------------------------------------------------------!
IF (N == 4) THEN
   X(1)=  1.D0/ 3.D0
   X(2)=  2.D0/15.D0
   X(3)= 11.D0/15.D0
   X(4)=  2.D0/15.D0
   Y(1)=  1.D0/ 3.D0
   Y(2)=  2.D0/15.D0
   Y(3)=  2.D0/15.D0
   Y(4)= 11.D0/15.D0
   Z(1)=  1.D0/ 3.D0
   Z(2)= 11.D0/15.D0
   Z(3)=  2.D0/15.D0
   Z(4)=  2.D0/15.D0
   W(1)=-27.D0/96.D0
   W(2)= 25.D0/96.D0
   W(3)= 25.D0/96.D0
   W(4)= 25.D0/96.D0
END IF !(N == 4)
!-----------------------------------------------------------------------------------------------!
END SUBROUTINE GAUSS2M3
!-----------------------------------------------------------------------------------------------!
