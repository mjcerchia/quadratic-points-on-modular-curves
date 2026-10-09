/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 16.96.5.cf.1.
Using a singular model we find a rank 1 quotient. This is positive rank bielliptic. 
******************************************************************************/
P<x,y,z>:=ProjectiveSpace(Rationals(),2);

C := Curve(P,[x^4*y^4 - 4*x^4*y^2*z^2 + 4*x^4*z^4 - 2*x^2*y^6 - 20*x^2*y^4*z^2 + 76*x^2*y^2*z^4 - 56*x^2*z^6 + y^8 - 40*y^6*z^2 + 436*y^4*z^4 - 720*y^2*z^6 + 324*z^8]);
Pt:=PointSearch(C,100)[1];
S := AutomorphismGroup(C); 
auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


ranks := [];
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C,[g]);
CG,prj := CurveQuotient(AG);
if Genus(CG) eq 1 then
E:=EllipticCurve(CG,prj(Pt));
ranks := Append(ranks, Rank(E));
end if;

end if;
print "........";
end for;
assert #[r : r in ranks | r eq 1] eq 2;
