/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.cw.1
We compute the automorphism group over F13 and find there are two genus one quotients by an involution. They have 20 and 14 points.
The single rank one elliptic curve factor of the Jacobian has 18 points over F13.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[2*x^2 + z*w - w^2, 2*x^2 - x*z + 2*x*w - z*w + w^2 + t^2, 4*x*z + 2*y^2 + z^2 - 2*z*w]);
C13 := Curve(Reduction(C,13)); 
S := AutomorphismGroup(C13); 

auts := [];
Stemp := Automorphisms(C13);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There are two genus one quotients by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C13,[g]);
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

assert #l eq 2;

assert #EllipticCurve(Curve(l[1])) eq 20;
assert #EllipticCurve(Curve(l[2])) eq 14;

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3 - 2*x);
assert #EllipticCurve(Curve(Reduction(E,13))) eq 18;
