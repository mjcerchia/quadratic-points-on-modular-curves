/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.192.5.c.1.
We compute the automorphism group over Q and find there is one genus one quotient by an involution. It is an elliptic curve of rank 0.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*w - y*t - 2*w*t, 2*x^2 + y*z, y*w + y*t + 2*z^2 + w^2 - t^2]);
/*****************************Optional code to verify that model taken from LMFDB matches with that obtained from Zywina's code

for tuple in data211 do;
          if tuple[1] eq "32.192.5.c.1" then
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
C := Curve(P,[y*w - y*t - 2*w*t, 2*x^2 + y*z, y*w + y*t + 2*z^2 + w^2 - t^2]);
assert IsIsomorphic(C,D);

*************************************************/
Pt:=PointSearch(C,100)[1];
S := AutomorphismGroup(C); 

auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There is one genus one quotient by an involution which is an elliptic curve of rank 0

for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C,[g]);
CG,prj := CurveQuotient(AG);
if Genus(CG) eq 1 then
E:=EllipticCurve(CG,prj(Pt));
assert Rank(E) eq 0;

end if;

end if;

end for;

