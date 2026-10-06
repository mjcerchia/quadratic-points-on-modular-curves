/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.l.1.
We compute the automorphism group over Q and find there are three genus one quotient by an involution. The first and third have 8 and 4 points mod 7,
respectively, while the single rank one elliptic curve factor of the Jacobian has 12 points mod 7. The second curve has 14 points mod 11 while the
while the single rank one elliptic curve factor of the Jacobian has 10 points mod 11.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*z + w*t, 2*y*w + z^2 + t^2, 4*x^2 + y*t + z*w]);

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

#EllipticCurve(Curve(Reduction(l[1],7))); //8
#EllipticCurve(Curve(Reduction(l[3],7))); //4

#EllipticCurve(Curve(Reduction(l[2],11))); //14

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);
#EllipticCurve(Curve(Reduction(E,7))); //12
#EllipticCurve(Curve(Reduction(E,11))); //10
