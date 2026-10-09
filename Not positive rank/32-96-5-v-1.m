/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.5.v.1.
We compute the automorphism group over Q and find there is one genus one quotient by an involution. Over F7, it has 8 points, 
while the single rank one elliptic curve factor of the Jacobian has 12 points over F7.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[2*x^2 - y*t - 2*z*t, y^2 + 2*y*z - 2*y*w + 2*z^2, y*w + 4*w^2 - t^2]);

/*****************************Optional code to verify that model taken from LMFDB matches with that obtained from Zywina's code

for tuple in data211 do;
          if tuple[1] eq "32.96.5.v.1" then
                      level:=Split(tuple[1],".")[1];
                      level:=StringToInteger(level);
                      GL2:=GL(2,Integers(level));
                      G:=sub<GL2|tuple[4]>;
                      Gt:=sub<GL2|[Transpose(GL2!g):g in Generators(G)]>;
                      assert not IsConjugate(GL2,G,Gt);
                      X:=CreateModularCurveRec(Gt);
                      XG:=FindModelOfXG(X);
                      D := Curve(ProjectiveSpace(Rationals(), Rank(Parent((XG`psi)[1]))-1),XG`psi);
           end if;
end for;

P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[2*x^2 - y*t - 2*z*t, y^2 + 2*y*z - 2*y*w + 2*z^2, y*w + 4*w^2 - t^2]);


assert IsIsomorphic(C,D);

***************************************************************************************/
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

assert #EllipticCurve(Curve(Reduction((l[1]),7))) eq 8;

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);
assert #EllipticCurve(Curve(Reduction(E,7))) eq 12;
