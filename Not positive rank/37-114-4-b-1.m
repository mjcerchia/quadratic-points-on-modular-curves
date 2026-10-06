/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 37.114.4.b.1
We compute the automorphism group over F5 and find there is one genus one quotient by an involution. It has 6 points.
The single rank one elliptic curve factor of the Jacobian has 8 points over F5.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w>:=ProjectiveSpace(Rationals(),3);
C := Curve(P,[x^2 - x*z - x*w - y*z + z^2 + z*w, x^3 - x^2*y + x*y^2 - x*z*w - y^2*z - y^2*w + 2*y*w^2 + z^2*w - w^3]);

/*****************************Optional code to verify that model taken from LMFDB matches with that obtained from Zywina's code
for tuple in data211 do;
          if tuple[1] eq "37.114.4.b.1" then
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

P<x,y,z,w>:=ProjectiveSpace(Rationals(),3);
C := Curve(P,[x^2 - x*z - x*w - y*z + z^2 + z*w, x^3 - x^2*y + x*y^2 - x*z*w - y^2*z - y^2*w + 2*y*w^2 + z^2*w - w^3]);

assert IsIsomorphic(C,D);

*************************************************************************/
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

#l;//1

assert #EllipticCurve(Curve(l[1])) eq 6;

E := EllipticCurve([0,0,1,-1,0]);
assert #EllipticCurve(Curve(Reduction(E,5))) eq 8;
