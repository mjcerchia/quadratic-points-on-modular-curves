
/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.48.3.l.1. 
We compute the automorphism group over Q, we find there are three genus one quotients by an involution. All are pointless.

******************************************************************************/
P<x,y,z,w,t,u>:=ProjectiveSpace(Rationals(),5);
C:=Curve(P,[2*x*t + z^2 + w*u, -2*x*w - x*u + y*z, -2*x*t + 2*y^2 + w*u, 4*w^2 + 2*t^2 + u^2, 4*x^2 - x*t + y^2, 4*x*z + 2*y*w + y*u - z*t, 8*x*y + 2*y*t + 2*z*w + z*u]);

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
// Certify pointlessness by a local obstruction for each genus-one quotient.
for C1 in l do
    assert not IsLocallySoluble(GenusOneModel(C1));
end for;


