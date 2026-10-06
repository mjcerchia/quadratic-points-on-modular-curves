/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.dl.1
We compute the automorphism group over F5 and find there are two genus one quotient by an involution. They have 6 and 4 points.
The single rank one elliptic curve factor of the Jacobian has 10 points over F5.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[y^2 - z^2 + z*w, 2*x*z + 2*x*w + t^2, 8*x^2 - z^2 + 2*w^2]);
C5 := Curve(Reduction(C,5)); 
S := AutomorphismGroup(C5); 

auts := [];
Stemp := Automorphisms(C5);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There are two genus one quotients by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C5,[g]);
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

#l;//2


assert #EllipticCurve(Curve(l[1])) eq 6;
assert #EllipticCurve(Curve(l[2])) eq 4;

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3 - 2*x);
assert #EllipticCurve(Curve(Reduction(E,5))) eq 10;
