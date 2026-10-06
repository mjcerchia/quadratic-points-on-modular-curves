/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.co.1.
Working over F7, there is one genus one quotient by an involution. It has 8 points.
The single rank one elliptic curve factor of the Jacobian has 12 points over F7.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*w - y*t + z*w + z*t, 2*x^2 + y*w + z*t, 2*x^2 + y^2 - 2*y*z - 2*y*w - y*t - z^2 + z*w - 2*z*t - w^2 - 2*w*t + t^2]);
C7 := Curve(Reduction(C,7)); 

S := AutomorphismGroup(C7); 
auts := [];
Stemp := Automorphisms(C7);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//There is one genus one quotient by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C7,[g]);
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

#l;


assert #EllipticCurve(Curve(l[1])) eq 8;


//The rank 1 jacobian factor
Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);

assert #EllipticCurve(Curve(Reduction(E,7))) eq 12;
