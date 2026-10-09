/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.3.dw.1. 
We find there are five genus one quotients by an involution. We construct a simpler model
on one of these quotients and find that it is a rank 1 elliptic curve. 
******************************************************************************/
P<x,y,z,u,t,w>:=ProjectiveSpace(Rationals(),5);
 C := Curve(P,[x^2 - y*z, 2*y*w + 2*w^2 - t*u + u^2, 2*y*w - 2*w^2 - t^2 - t*u, y*w + 4*z*w - t*u, -y*u + 4*z*t - w*t + w*u, y*t + 4*z*u + w*t + w*u, y^2 + 16*z^2 - 2*w^2]);

S := AutomorphismGroup(C); 
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//There are five genus one quotients by an involution
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

C1 := l[1];

//Search for degree 2 divisors
P<[X]> := AmbientSpace(C1);
deg := 2;
tups := {};
d := Dimension(P);
ideals := {@@};
tupsOld := tups;
coeffs := [ 0, 1 ];
    tups   :=
        [ P![ tup[i] : i in [1..#tup] ] :
          tup in CartesianPower(coeffs, d+1) |
          not tup eq < 0 : i in [1..d+1] >  
          and not P![tup[i] : i in [1..#tup]] in tupsOld
        ];
    for c in tups  do  
            L := Scheme(P,&+[c[i]*X[i] : i in [1..Dimension(AmbientSpace(C1)) + 1]]);
              irr := IrreducibleComponents(L meet C1);
              degs := [Degree(ReducedSubscheme(i)) : i in irr];
              if  deg in degs then
        for cpt in irr do  
         if  Degree(ReducedSubscheme(cpt)) eq deg
             and not Basis(Ideal(ReducedSubscheme(cpt))) in ideals then      
               ideals := ideals join {@Basis(Ideal(ReducedSubscheme(cpt)))@}; 
        end if;
    end for;
    end if;
    end for;
    ideals;

ideals;
/*
{@
    [
        X[3]^2 - 1/7*X[4]^2,
        X[1],
        X[2]
    ],
    [
        X[3]^2 - 1/7*X[4]^2,
        X[1] - X[3],
        X[2] + X[3]
    ]
@}
*/

gens := ideals[1];

//building a new model
P7 := AmbientSpace(C1);
R  := CoordinateRing(P7);
I := ideal< R | gens >;
Pl := Place(C1, I);
D  := Divisor(Pl);
a,b := RiemannRochSpace(D);
x1 := b(a.1); 
x2 := b(a.2); 
a,b := RiemannRochSpace(2*D);
y := b(a.1);
F := BaseField(C1);
P := PolynomialRing( F, [2,1,1], "grevlexw", [2,1,1] );
vars := ["yv","x1v", "x2v"]; //(calling them yv and xv so magma doesn't confuse the functions with x and y)
P := ProjectiveSpace(P);
AssignNames(~P, vars);
phi := map<C1 -> P | [y,x1,x2]>;
C2:=Image(phi); 

C2;
/*
Curve over Rational Field defined by
yv^2 - 16*x1v^4 - 32*x1v^3*x2v - 40*x1v^2*x2v^2 - 24*x1v*x2v^3 - 7*x2v^4
*/

P<x> := PolynomialRing(Rationals());
f := -(-16*x^4 - 32*x^3 - 40*x^2 - 24*x - 7);
H := HyperellipticCurve(f);
RationalPoints(H : Bound := 10000);
/*
{@ (1 : -4 : 0), (1 : 4 : 0), (0 : 0 : 1), (9 : -723 : 7), (9 : 723 : 7), (-31 :
-868 : 24), (-31 : 868 : 24) @}
*/
pt := H!RationalPoints(H : Bound := 10000)[1]; 
E := EllipticCurve(H,pt);
assert Rank(E) eq 1; 
