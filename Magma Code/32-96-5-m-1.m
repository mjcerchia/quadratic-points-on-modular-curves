/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.5.m.1
We find there are three genus one quotients by an involution. 
We are able to find a point on one of the curves by intersecting with a hyperplane. From this, we are able to construct an elliptic curve, 
which we find to have rank 1. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[x^2 - y*z, x^2 + y*z + w*t, 8*y^2 + 2*z^2 + 4*w^2 - t^2]);

S := AutomorphismGroup(C); 
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//There are three genus one quotients by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C,[g]);
CG,prj := CurveQuotient(AG);
if Genus(CG) eq 1 then
try
l := Append(l,CG);
catch e
m := Append(m,CG);
end try;
end if;

end if;

end for;


assert #l eq 3;

P<[x]> := ProjectiveSpace(Rationals(),7);
C1 := l[3];

//We can't immediately find a point, so we intersect with a hyperplane
//This produces a point
pts := Points(C1 meet Scheme(AmbientSpace(C1),x[1]));
assert #pts gt 0;
pt := pts[1];
E := EllipticCurve(C1,pt);
assert Rank(E) eq 1;
