/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.ei.1.
We compute the automorphism group over F3 and find there are no genus one quotients by an involution. 
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);

C := Curve(P,[2*x*z - y*w - y*t, 2*x^2 + 4*y^2 + 4*z^2 + w^2 + w*t, 2*x^2 - 4*y^2 + 4*z^2 + 2*w^2 + 3*w*t - t^2]);

 
C3 := Curve(Reduction(C,3)); 
S := AutomorphismGroup(C3); 


auts := [];
Stemp := Automorphisms(C3);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There are no genus one quotients by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C3,[g]);
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
