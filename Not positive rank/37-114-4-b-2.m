/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 37.114.4.b.2
We compute the automorphism group over F5 and find there is one genus one quotient by an involution. It has 6 points.
The single rank one elliptic curve factor of the Jacobian has 8 points over F5.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w>:=ProjectiveSpace(Rationals(),3);
// Model taken from Zywina's code
C := Curve(P,[-12*x^2 - 13*x*y - 12*y^2 + x*z - y*z + z^2 - x*w + y*w - z*w + w^2,
-396*x^3 - 1513*x^2*y - 1225*x*y^2 - 973*y^3 + 337*x^2*z + 399*x*y*z + 337*y^2*z - 51*x*z^2 + 51*y*z^2 - 40*z^3 - 132*x^2*w - 143*x*y*w - 132*y^2*w + 22*x*z*w - 22*y*z*w + 33*z^2*w]);



C5 := Curve(Reduction(C,5)); 
S := AutomorphismGroup(C5); 

auts := [];
Stemp := Automorphisms(C5);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There is one genus one quotient by an involution
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

#l; //1

assert #EllipticCurve(Curve(l[1])) eq 6;

E := EllipticCurve([0,0,1,-1,0]);
#EllipticCurve(Curve(Reduction(E,5))); //8
