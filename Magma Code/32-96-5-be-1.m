/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.5.be.1. 
We find there are three genus one quotients by an involution. 
We are able to find a point on one of these. From this, we are able to construct an elliptic curve, 
which we find to be rank 1. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*w + z*t, 2*x^2 + y*w + y*t - z*t, y^2 + 4*y*z - 4*z^2 + w^2 + w*t]);

/************************************Optional code to verify that LMFDB model matches with that obtained from Zywina's code**************

for tuple in data211 do;
          if tuple[1] eq "32.96.5.be.1" then
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

P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*w + z*t, 2*x^2 + y*w + y*t - z*t, y^2 + 4*y*z - 4*z^2 + w^2 + w*t]);
assert IsIsomorphic(C,D);

*******************************************************************************/
pt:=PointSearch(C,1000)[1];
S := AutomorphismGroup(C); 
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;




ranks := [];
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C,[g]);
CG,prj := CurveQuotient(AG);
if Genus(CG) eq 1 then
E := EllipticCurve(CG,CG!prj(pt)); 
ranks := Append(ranks, Rank(E));
end if;

end if;

end for;
assert #ranks eq 3;
assert 1 in ranks;


