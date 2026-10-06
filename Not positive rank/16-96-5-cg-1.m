/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.cg.1
Working over F7, there are three genus one quotient by an involution. Each has 8 points.
There are two rank one elliptic curve factors of the Jacobian that correspond to 128.2.a.a and 256.2.a.b.
The rank one elliptic curve factor that correspond to 128.2.a.a has 12 points over F7. So no quotient corresponds to that.
To rule out 256.2.a.b we find two pointless genus one quotient whose Jacobian is isomorphic to 256.2.a.b.
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t> := ProjectiveSpace(Rationals(),4);
C := Curve(P,[y*w - z*t, 2*y^2 + z^2 + w^2 + t^2, 16*x^2 + 2*y^2 - w^2]);
C7 := Curve(Reduction(C,7)); 

S := AutomorphismGroup(C7); 
auts := [];
Stemp := Automorphisms(C7);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;

//There are three genus one quotients by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C7,[g]);
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

#l;


#EllipticCurve(Curve(l[1])); //8
#EllipticCurve(Curve(l[2])); //8
#EllipticCurve(Curve(l[3])); //8

//The rank 1 jacobian factor
Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);

#EllipticCurve(Curve(Reduction(E,7))); //12



P<x,y,z> := ProjectiveSpace(Rationals(),2);
C := Curve(P,[x^4*y^4 + 2*x^4*y^2*z^2 + x^4*z^4 + 68*x^2*y^6 + 108*x^2*y^4*z^2 + 42*x^2*y^2*z^4 + 2*x^2*z^6 + 900*y^8 + 720*y^6*z^2 + 84*y^4*z^4 - 24*y^2*z^6 + z^8]);


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
gens := ideals[6];
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
C2:=Image(phi);C2;
/*Curve over Rational Field defined by
yv^2 - 8012408107/20381746235465097745920*yv*x1v^2 + 519295955312624653/12493701642312652141017750650696537289523200*x1v^4 + 876929837614050/10591640456663*yv*x1v*x2v - 1804254977329230640465/108208585466160866674583479070208*x1v^3*x2v + 54345129876457208862888960000/10591640456663*yv*x2v^2 + 629511592384903328252695125/843480056866318820910493*x1v^2*x2v^2 + 176736788595681783169662226779785856000000/843480056866318820910493*x1v*x2v^3 + 295925047001665565250824786151261348739566796800000000/44393687203490464258447*x2v^4*/
P<x> := PolynomialRing(Rationals());
f := -(519295955312624653/12493701642312652141017750650696537289523200*x^4  - 1804254977329230640465/108208585466160866674583479070208*x^3  + 629511592384903328252695125/843480056866318820910493*x^2 + 176736788595681783169662226779785856000000/843480056866318820910493*x + 295925047001665565250824786151261348739566796800000000/44393687203490464258447);
g:= P!(- 8012408107/20381746235465097745920*x^2+ 876929837614050/10591640456663*x+ 54345129876457208862888960000/10591640456663);
H := HyperellipticCurve(f,g);
SH:=SimplifiedModel(H);
assert not IsLocallySolvable(SH,2);
Jacobian(GenusOneModel(H)); // isomorphic to 256.2.a.b

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
gens := ideals[6];
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

P<x> := PolynomialRing(Rationals());
f := -(519295955312624653/12493701642312652141017750650696537289523200*x^4  + 1804254977329230640465/108208585466160866674583479070208*x^3  + 629511592384903328252695125/843480056866318820910493*x^2 - 176736788595681783169662226779785856000000/843480056866318820910493*x + 295925047001665565250824786151261348739566796800000000/44393687203490464258447);
g:= P!(8012408107/20381746235465097745920*x^2+ 876929837614050/10591640456663*x- 54345129876457208862888960000/10591640456663);
H := HyperellipticCurve(f,g);
SH:=SimplifiedModel(H);
assert not IsLocallySolvable(SH,2);
Jacobian(GenusOneModel(H)); // isomorphic to 256.2.a.b




