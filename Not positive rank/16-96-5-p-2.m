/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.p.2
We compute the automorphism group over F3 and find there is one genus one quotient by an involution. It has 4 points.
The single rank one elliptic curve factor of the Jacobian has 6 points over F3.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[2*y^2 + 2*y*z + t^2, 2*y*z - 2*z^2 + w^2, 4*x^2 - w*t]);
/*****************************Optional code to verify that model taken from LMFDB matches with that obtained from Zywina's code

for tuple in data211 do;
          if tuple[1] eq "16.96.5.p.2" then
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
C := Curve(P,[2*y^2 + 2*y*z + t^2, 2*y*z - 2*z^2 + w^2, 4*x^2 - w*t]);
assert IsIsomorphic(C,D);

************************************************************/
C3 := Curve(Reduction(C,3)); 
S := AutomorphismGroup(C3); 

auts := [];
Stemp := Automorphisms(C3);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There is one genus one quotient by an involution
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

#l;//1

assert #EllipticCurve(Curve(l[1])) eq 4;

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);
assert #EllipticCurve(Curve(Reduction(E,3))) eq 6;
