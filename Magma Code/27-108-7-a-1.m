/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 27.108.7.a.1.
We find one rank 1 quotient by an involution. 
 
******************************************************************************/

P2<x,y,z> := ProjectiveSpace(Rationals(), 2);
C := Curve(P2, -9*x^9 - x^6*y^3 + 9*x^3*y^3*z^3 - 27*x^3*z^6 + y^6*z^3);

mp:=iso<C->C|[2/9*x^12*y*z^2 - 2/9*x^6*y^4*z^5 + 18*x^6*y*z^8 + 2*x^3*y^4*z^8 + 12*x^3*y*z^11,
2/9*x^11*y^2*z^2 - 2/9*x^5*y^5*z^5 + 18*x^5*y^2*z^8 + 2*x^2*y^5*z^8 + 12*x^2*y^2*z^11,
-2/9*x^11*y*z^3 + 20/3*x^8*y*z^6 + 8/9*x^5*y^4*z^6 + 14*x^5*y*z^9 + 4/3*x^2*y^4*z^9],[324*x^13 - 36*x^10*y^3 - 8*x^7*y^6 - 378*x^7*y^3*z^3 + 39*x^4*y^6*z^3 + 8*x*y^9*z^3 + 1944*x^7*z^6 - 270*x^4*y^3*z^6 + 45*x*y^6*z^6 - 972*x*y^3*z^9 + 2916*x*z^12,
-54*x^6*y^4*z^3 + 3*x^3*y^7*z^3 + 972*x^6*y*z^6 - 54*x^3*y^4*z^6 + 45*y^7*z^6 - 972*y^4*z^9 + 2916*y*z^12,
y^9*z^4 - 36*y^6*z^7 + 324*y^3*z^10]>;
id:=iso<C->C|[x,y,z],[x,y,z]>;
assert mp*mp eq id; 
G:=AutomorphismGroup(C,[mp]);
C1,prj:=CurveQuotient(G);

P<[x]>:=ProjectiveSpace(Rationals(),11);
//We can't immediately find a point, so we intersect with hyperplanes.
pt := C1!Points(C1 meet Scheme(AmbientSpace(C1),x[3]))[1];
E := EllipticCurve(C1,pt);
assert Rank(E) eq 1;
