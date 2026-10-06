/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.4.f.1.
We find there are no genus one quotients by an involution. 
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w> := ProjectiveSpace(Rationals(),3);
C := Curve(P,[8*x^2 - 4*x*y - 8*y^2 + z^2 + 2*z*w - w^2, 2*x^3 - 4*x^2*y + 2*y^3 - y*z^2 - y*z*w]);

S := AutomorphismGroup(C); 
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//There are NO genus one quotients by an involution
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

assert #l eq 0 and #m eq 0;
