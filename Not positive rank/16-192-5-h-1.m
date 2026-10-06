/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.192.5.h.1
We compute the automorphism group over Q and find there is one genus one quotient by an involution. Over F13, it has 20 points.
But the single rank one elliptic curve factor of the Jacobian has 14 points over F13.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[x*y + x*z - y*z + z^2, 2*x*y - 2*x*z - 2*y^2 + 2*y*z + t^2, x*t + z*t + 4*w^2]);

S := AutomorphismGroup(C); 

auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There is one genus one quotient by an involution
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

assert #l eq 1;


#EllipticCurve(Curve(Reduction(l[1],13))); //20

//The rank 1 jacobian factor
Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2-13*x-21); 

#EllipticCurve(Curve(Reduction(E,13))); //14
