Mesh.Optimize = 1;

// Parameters
h = 0.5;	//Mesh quality //Use -setnumber command argument to set this value
R = 1.;		//Pipe radius
L = 10.;	//Pipe length

INLET = 1;	//Inlet label
OUTLET = 2;	//Outlet label
WALL = 3;	//Wall label
VOLUME = 10;//Volume label

// Elementary
//Points
p = newp;
Point(p+0) = {0., 0., 0., h};
Point(p+1) = {R, 0., 0., h};
Point(p+2) = {0., R, 0., h};
Point(p+3) = {-R, 0., 0., h};
Point(p+4) = {0., -R, 0., h};

Point(p+5) = {0., 0., L, h};
Point(p+6) = {R, 0., L, h};
Point(p+7) = {0., R, L, h};
Point(p+8) = {-R, 0., L, h};
Point(p+9) = {0., -R, L, h};

//Lines
l = newl;
Circle(l+1) = {p+1, p+0, p+2};
Circle(l+2) = {p+2, p+0, p+3};
Circle(l+3) = {p+3, p+0, p+4};
Circle(l+4) = {p+4, p+0, p+1};

Circle(l+5) = {p+6, p+5, p+7};
Circle(l+6) = {p+7, p+5, p+8};
Circle(l+7) = {p+8, p+5, p+9};
Circle(l+8) = {p+9, p+5, p+6};

Line(l+10) = {p+1, p+6};
Line(l+11) = {p+2, p+7};
Line(l+12) = {p+3, p+8};
Line(l+13) = {p+4, p+9};

//Line loops
ll = newll;
Line Loop(ll+0) = {l+1, l+2, l+3, l+4};
Line Loop(ll+1) = {l+5, l+6, l+7, l+8};
Line Loop(ll+2) = {l+1, l+11, -(l+5), -(l+10)};
Line Loop(ll+3) = {l+2, l+12, -(l+6), -(l+11)};
Line Loop(ll+4) = {l+3, l+13, -(l+7), -(l+12)};
Line Loop(ll+5) = {l+4, l+10, -(l+8), -(l+13)};

//Surfaces
s = news;
Plane Surface(s+0) = {ll+0};
Plane Surface(s+1) = {ll+1};
Surface(s+2) = {ll+2};
Surface(s+3) = {ll+3};
Surface(s+4) = {ll+4};
Surface(s+5) = {ll+5};

//Surface loops
sl = newsl;
Surface Loop(sl+0) = {s+0, s+1, s+2, s+3, s+4, s+5};

//Volume
v = newv;
Volume(v+0) = {sl+0};

// Physical
//Surfaces
Physical Surface("INLET", INLET) = {s+0};
Physical Surface("OUTLET", OUTLET) = {s+1};
Physical Surface("WALL", WALL) = {s+2, s+3, s+4, s+5};

//Volumes
Physical Volume("VOLUME", VOLUME) = {v+0};

SetFactory("OpenCASCADE");
