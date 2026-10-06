/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.5.a.2.
We find there are three genus one quotients by an involution. 
We are able to find a point on one of the curves, from which we are able to construct an elliptic curve, which
we find to have rank 1. 
******************************************************************************/

//Model obtained from the LMFDB
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[x^2 + z*w, x*z - 2*x*t - y^2, z*t + 4*w^2 - t^2]);

S := AutomorphismGroup(C); 
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//We find that there are 3 genus one quotients by involutions
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

//One of the quotients is given by
P<[x]> := ProjectiveSpace(Rationals(),7);
C1 := l[2];


//We can find a rational point on C1
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

E := EllipticCurve(C1,pt);
assert Rank(E) eq 1;
