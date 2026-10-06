/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.192.5.bl.1
Working over F13, there is one genus one quotient by an involution. It has 20 points.
The single rank one elliptic curve factor of the Jacobian has 14 points over F13.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y^2 - 2*y*z - w^2 + t^2, y^2 - 2*y*w + z^2 + 2*z*t + 2*w^2 + 2*w*t - t^2, 8*x^2 - y^2 + y*z + y*w + z*w - z*t - w*t + t^2]);
C13 := Curve(Reduction(C,13)); 

S := AutomorphismGroup(C13); 
auts := [];
Stemp := Automorphisms(C13);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//There is one genus one quotient by an involution
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
#l; // 1

assert #EllipticCurve(Curve(l[1])) eq 20;

//The rank 1 jacobian factor
Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2-13*x-21); 

assert #EllipticCurve(Curve(Reduction(E,13))) eq 14;
