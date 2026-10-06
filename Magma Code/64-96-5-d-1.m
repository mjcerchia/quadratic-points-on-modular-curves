
/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 64.96.5.d.1.
We find there are three genus one quotients by an involution. 
We are able to find a point on one of the curves by intersecting with a hyperplane. From this, we are able to construct an elliptic curve, 
which we find to have rank 1. 
******************************************************************************/

P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[x*z - y*w, -4*x*w + y*z + t^2, 4*x^2 + y^2 + z*w]);

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

//One of these quotients has rank 1:
P<[x]> := ProjectiveSpace(Rationals(),7);
C1 := l[3];

//We can't immediately find a point, so we intersect with a hyperplane
pt := C1!Points(C1 meet Scheme(AmbientSpace(C1),x[4]))[1];

E := EllipticCurve(C1,pt);
assert Rank(E) eq 1;
