function [HA1,CA1]=FA(x1,x2,x3)
   HA1= xor(xor(x1,x2),x3);
   CA1= or(or(and(x1,x2),and(x2,x3)),and(x3,x1));

end