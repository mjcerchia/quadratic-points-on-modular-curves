/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.eh.1.
We compute the automorphism group using singular model and find there are two genus one quotients by involutions. Both of them are pointless and their Jacobian is isomorphic to 256.2.a.a.
NOT bielliptic. 
******************************************************************************/
P<x,y,z>:=ProjectiveSpace(Rationals(),2);
C := Curve(P,[2*x^4*y^4 + 4*x^4*y^2*z^2 + x^4*z^4 + 8*x^2*y^6 + 16*x^2*y^4*z^2 + 4*x^2*y^2*z^4 + 8*y^8 + 8*y^6*z^2 + 2*y^4*z^4]);
S:=AutomorphismGroup(C);
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There are two genus one quotients by an involution
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

assert #l eq 2;
C1:=l[1];

//constructing a simple model for C1

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
/*Curve over Rational Field defined by
yv^2 + 5/512*x1v^4 + 11/32*x1v^3*x2v + 37/8*x1v^2*x2v^2 + 29*x1v*x2v^3 + 74*x2v^4*/
P<x> := PolynomialRing(Rationals());
f := -(5/512*x^4 + 11/32*x^3 + 37/8*x^2 + 29*x + 74);



H := HyperellipticCurve(f);
assert not IsLocallySolvable(H,2);
J := Jacobian(GenusOneModel(H));
Eref := EllipticCurve([0,1,0,-13,-21]); // LMFDB isogeny class 256.a, modular form 256.2.a.a
assert IsIsogenous(J,Eref);


C1:=l[2];

//constructing a simple model for C1

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
/*Curve over Rational Field defined by
yv^2 + 5/512*x1v^4 - 11/32*x1v^3*x2v + 37/8*x1v^2*x2v^2 - 29*x1v*x2v^3 + 74*x2v^4*/
P<x> := PolynomialRing(Rationals());
f := -(5/512*x^4 - 11/32*x^3 + 37/8*x^2 - 29*x + 74);

H := HyperellipticCurve(f);
assert not IsLocallySolvable(H,2);
J := Jacobian(GenusOneModel(H));
Eref := EllipticCurve([0,1,0,-13,-21]); // LMFDB isogeny class 256.a, modular form 256.2.a.a
assert IsIsogenous(J,Eref);
