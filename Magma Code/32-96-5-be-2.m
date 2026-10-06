
/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.5.be.2.
We find there are three genus one quotients by an involution. 
We are able to find a point on one of the curves by intersecting with a hyperplane. From this, we are able to construct an elliptic curve, 
which we find to have rank 1. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[-x*t + y^2, x*t + y^2 - z*w, 16*x^2 - 4*z^2 - w^2 + 2*t^2]);

/***************************************Optional code to verify that LMFDB model matches with one obtained from Zywina's repo******

for tuple in data211 do;
          if tuple[1] eq "32.96.5.be.2" then
                      level:=Split(tuple[1],".")[1];
                      level:=StringToInteger(level);
                      GL2:=GL(2,Integers(level));
                      G:=sub<GL2|tuple[4]>;
                      Gt:=sub<GL2|[Transpose(GL2!g):g in Generators(G)]>;
                      IsConjugate(GL2,G,Gt);//false
                      X:=CreateModularCurveRec(Gt);
                      XG:=FindModelOfXG(X);
                      D := Curve(ProjectiveSpace(Rationals(), Rank(Parent((XG`psi)[1]))-1),XG`psi);
           end if;
end for;

P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[-x*t + y^2, x*t + y^2 - z*w, 16*x^2 - 4*z^2 - w^2 + 2*t^2]);

assert IsIsomorphic(C,D);

*************************************************************************************/
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

//One of these quotients has the following model:
P<[x]> := ProjectiveSpace(Rationals(),7);
C1 := l[3];

//We can't immediately find a point, so we intersect with a hyperplane
pt := C1!Points(C1 meet Scheme(AmbientSpace(C1),x[5]))[1];

E := EllipticCurve(C1,pt);
assert Rank(E) eq 1;
