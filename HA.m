function [HA1,CA1]=HA(x1,x2)
   HA1= or(and(not(x1),x2),and(not(x2),x1));
   CA1= and(x1,x2);

end