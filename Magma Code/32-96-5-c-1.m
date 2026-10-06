/****************************************************************************** 
 Here is a summary of the argument.

Let C be the modular curve with lmfdb label  32.96.5.c.1. 
We find there are three genus one quotients by an involution. 
We don't have to consider two of these, since they have a different number of points mod p
than the single rank one Jacobian factor for various p.
On the remaining curve, we cannot find a point, so we search for degree two divisors in 
order to build a simpler model. After doing this, we find that the curve is elliptic and rank 1. 
******************************************************************************/

P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*w - z*t, x^2 - y*t + z*w, 2*y^2 + 2*z^2 + w*t]);

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

//Two of these quotients we can rule out by comparing them mod p to the rank one
// elliptic curve factor of the Jacobian. So we consider:

P<[x]> := ProjectiveSpace(Rationals(),7);
C1 := l[2]; 

//Unable to find a rational point, so we search for degree two models in hopes to produce a simpler model

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

//This was successful, so we can build a new model
gens := ideals[1];
P7 := AmbientSpace(C1);
R  := CoordinateRing(P7);
I := ideal< R | gens >;
Pl := Place(C1, I);
D  := Divisor(Pl);
a,b := RiemannRochSpace(D);
x1 := b(a.1); //(the nonconstant element, equal to 1/$.1)
x2 := b(a.2); //(the nonconstant element, equal to 1/$.1)
a,b := RiemannRochSpace(2*D);
y := b(a.1); //(equal to (512*$.1^4 + 1)/(4*$.1^4)*$.6, the other basis elements are 1, x, x^2)
F := BaseField(C1);
P := PolynomialRing( F, [2,1,1], "grevlexw", [2,1,1] );
vars := ["yv","x1v", "x2v"]; //(calling them yv and xv so magma doesn't confuse the functions with x and y)
P := ProjectiveSpace(P);
AssignNames(~P, vars);
phi := map<C1 -> P | [y,x1,x2]>;
C2:=Image(phi);

//C2 is given by yv^2 - 4*x1v^4 - 2*yv*x2v^2 - 4*x1v^2*x2v^2 + 2*x2v^4, or more familiarly, y^2-4x^4-2y-4x^2+2.
//By completing the square, we get the isomorphic model:

P<x> := PolynomialRing(Rationals());
f := 4*x^4+4*x^2-2;
g:= P!-2;
H := HyperellipticCurve(f,g);

E := EllipticCurve(H);
assert Rank(E) eq 1;
