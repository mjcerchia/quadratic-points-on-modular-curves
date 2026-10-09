/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 64.96.5.d.2
We compute the automorphism group over Q and find there are three genus one quotient by an involution. Over F7, the first and third
have 8 and 4 points, respectively, while the single rank one elliptic curve factor of the Jacobian has 12 points over F7. Over F5,
the second has 4 points, while the single rank one elliptic curve factor of the Jacobian has 8 points.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[x*z + y*w, 4*x*w + y*z - 2*t^2, 4*x^2 + y^2 - z*w]);
S := AutomorphismGroup(C); 

auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There are three genus one quotient by an involution
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


assert #EllipticCurve(Curve(Reduction((l[1]),7))) eq 8;
assert #EllipticCurve(Curve(Reduction((l[2]),5))) eq 4;
assert #EllipticCurve(Curve(Reduction((l[3]),7))) eq 4;

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);
assert #EllipticCurve(Curve(Reduction(E,7))) eq 12;
assert #EllipticCurve(Curve(Reduction(E,5))) eq 8;
