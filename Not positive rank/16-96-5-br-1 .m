/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.br.1.
Using a singular model we find two pointless genus 1 quotients whose Jacobian is 256.2.a.b. This is not positive rank bielliptic. 
******************************************************************************/

P<x,y,z>:=ProjectiveSpace(Rationals(),2);

C := Curve(P,[x^4*y^4 + 2*x^4*y^2*z^2 + x^4*z^4 + 60*x^2*y^6 + 84*x^2*y^4*z^2 + 22*x^2*y^2*z^4 - 2*x^2*z^6 + 1156*y^8 + 1360*y^6*z^2 + 468*y^4*z^4 + 40*y^2*z^6 + z^8]);
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

// building a simpler model for l[1]

C1:=l[1];

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
    
//This was successful, so we can build a new model
gens := ideals[3];
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
C2;

// building a simpler model for l[2]

C1:=l[2];

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
    
//This was successful, so we can build a new model
gens := ideals[3];
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
C2;


/* Curve over Rational Field defined by
yv^2 + 2209/1595103161087639665800000000*x1v^4 - 1216/3757*yv*x1v*x2v + 369664/14115049*x1v^2*x2v^2 + 7933071522063974400000000/169*x2v^4*/

P<x> := PolynomialRing(Rationals());
f := -(2209/1595103161087639665800000000*x^4  + 369664/14115049*x^2 + 7933071522063974400000000/169);
g:= P!(- 1216/3757*x);
H := HyperellipticCurve(f,g);
SH := SimplifiedModel(H);
assert not IsLocallySoluble(GenusOneModel(SH));
J := Jacobian(GenusOneModel(H));
Eref := EllipticCurve([0,0,0,-2,0]); // LMFDB isogeny class 256.b, modular form 256.2.a.b
assert IsIsogenous(J,Eref);
