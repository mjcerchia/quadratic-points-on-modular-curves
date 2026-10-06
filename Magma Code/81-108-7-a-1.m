/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 81.108.7.a.1. 
The automorphism group of C is Z/2Z, and the quotient of C by the automorphsm 
group is a rank 1 elliptic curve. 
******************************************************************************/
//The following model comes from code on David Zywina's Github

P<[x]> := ProjectiveSpace(Rationals(),6);
C := Curve(P,[
-x[2]*x[3] + x[2]*x[4] + x[7]^2,
x[3]*x[5] + x[4]*x[5] - x[4]*x[6],
x[1]*x[2] + x[3]*x[7] + x[5]*x[7] + x[6]*x[7],
x[1]^2 - x[1]*x[2] + x[2]^2 - x[3]*x[7] + x[4]*x[7],
-x[2]^2 + x[5]*x[7] - 2*x[6]*x[7],
x[1]*x[7] + x[3]^2 - x[3]*x[4] + x[3]*x[5] + x[3]*x[6] - x[4]*x[5] - x[4]*x[6],
x[2]*x[7] - 2*x[3]*x[5] + 2*x[3]*x[6] - x[4]*x[6],
x[1]*x[5] - 2*x[1]*x[6] + x[2]*x[3] + x[2]*x[5] + x[2]*x[6],
-x[1]*x[3] - x[1]*x[5] - x[1]*x[6] + x[2]*x[4] + 2*x[2]*x[5] - x[2]*x[6],
-x[1]*x[7] + x[3]*x[4] + x[3]*x[6] + x[4]*x[5] + 3*x[5]^2 - 3*x[5]*x[6] + 3*x[6]^2
]);

G:= AutomorphismGroup(C); 
assert #G eq 2;
Pts:=PointSearch(C,10000);
CG,prj:=CurveQuotient(G);
E:=EllipticCurve(CG,prj(Pts[1]));
assert Rank(E) eq 1; 
