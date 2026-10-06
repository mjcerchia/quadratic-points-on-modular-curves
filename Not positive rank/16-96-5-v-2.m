/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.v.2.
We compute the automorphism group over Q and find there is one genus one quotient by an involution. It has 4 points over F3, while the
single rank one factor of the Jacobian has 6 points.
NOT bielliptic. 
******************************************************************************/

P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[2*y^2 - w^2 + w*t, 2*z^2 - w*t - t^2, 2*x^2 + y*z]);

/*****************************Optional code to verify that model taken from LMFDB matches with that obtained from Zywina's code
for tuple in data211 do;
          if tuple[1] eq "16.96.5.v.2" then
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
C := Curve(P,[2*y^2 - w^2 + w*t, 2*z^2 - w*t - t^2, 2*x^2 + y*z]);

assert IsIsomorphic(C,D);

*********************************************************************/

G:=AutomorphismGroup(C);
S:=Automorphisms(C);

for s in S do

s1:=G!s;

if Order(s1) eq 2 then

AG := AutomorphismGroup(C,[s1]);
CG,prj := CurveQuotient(AG);

if Genus(CG) eq 1 then


Cp:=Curve(Reduction(CG,3));
E:=EllipticCurve(Cp);
#Points(E);
end if;

end if;
print ".......";
end for;


//128.2.a.a
E := EllipticCurve([0, 1, 0, -9, 7]);
print "Points of Jacobian factor ";
#EllipticCurve(Curve(Reduction(E,3)));
