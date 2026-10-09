/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 27.36.3.a.1. 
We find there is one genus one quotient by an involution. 
We are able to find a point. From this, we are able to construct an elliptic curve, 
which we find to have rank 1. 
******************************************************************************/
P<x,y,z>:=ProjectiveSpace(Rationals(),2);
 C := Curve(P,[x^3*y + x^2*y^2 + x*y^3 + 3*x*z^3 - 3*y*z^3]);

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

//One of these quotients has the following model:
P<[x]> := ProjectiveSpace(Rationals(),3);
C1 := l[1];

  rationalPoints := function(D : Bound := 1)
    return {@D![t :t in tup]
              : tup in CartesianPower([-Bound..Bound],Dimension(AmbientSpace(D)\
)+1)
              | not {i : i in tup} eq {0}
                and {Evaluate(eqns,[t : t in tup]) : eqns in
DefiningEquations(D)} eq {0}
            @};
  end function;
  
pt :=   rationalPoints(C1:Bound := 1)[1];

E:=EllipticCurve(C1,pt);
assert Rank(E) eq 1;
