/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.s.1
We compute the automorphism group over Q and find there are three genus one quotients by an involution. Two quotients have 
4 and 2 points, respectively, mod 3 which does not match with points of rank 1 newform factor in Jacobian. For the third, we construct a new model and find that it is rank one. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[2*x^2 + y*z, 2*y*z + w*t, 2*y^2 + 2*z^2 + w^2 - t^2]);

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



assert #EllipticCurve(Curve(Reduction(l[1],3))) eq 4;
assert #EllipticCurve(Curve(Reduction(l[3],3))) eq 2;

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);
assert #EllipticCurve(Curve(Reduction(E,3))) eq 6;

/*********************************************************************************************************/

//Search for degree two divisors
C1 := l[2];
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

//Finding a nicer model    
gens := ideals[1];
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
yv^2 - 512*x1v^4 - 64*x1v^2*x2v^2 + 2*x2v^4
*/

P<x>:=PolynomialRing(Rationals());
f := -(-512*x^4 - 64*x^2 + 2);  
H := HyperellipticCurve(f);


RationalPoints(H : Bound := 10000);
/*
{@ (-3 : -224 : 4), (-3 : 224 : 4), (-1 : -32 : 4), (-1 : 32 : 4), (1 : -32 : 
4), (1 : 32 : 4), (3 : -224 : 4), (3 : 224 : 4), (-11 : -736 : 68), (-11 : 736 :
68), (11 : -736 : 68), (11 : 736 : 68), (-233 : -1276448 : 188), (-233 : 1276448
: 188), (233 : -1276448 : 188), (233 : 1276448 : 188) @}
*/

pt := H!RationalPoints(H : Bound := 10000)[1]; 
E := EllipticCurve(H,pt);
assert Rank(E) eq 1;
