close all;
clear;
clc;
m = 8;
cin=0;
count=8;
k = 1000000;
count=0;
ed=0;
%A = randi([1, 2^m-1], k, 1);
%B = randi([1, 2^m-1], k, 1);
j=1;
WCRE=0;
stats = zeros(1000000,7); %input1|input2|actual value|approx product|error|ED|RED
iter = 0;
for i = 1:1000000
  %for   B=1:65535
      A=randi(65535,1);
      B=randi(65535,1);
      iter = iter + 1;
 
    p_actual = A*B;
    
    a=de2bi(A,16);
    b=de2bi(B,16);
    AL=bi2de(a(1:8));
    BL=bi2de(b(1:8));
    AH=bi2de(a(9:16));
    BH=bi2de(b(9:16));
    
    pp1= p_approx(AL,BL,m);
    %pp2=AL*BH;
    pp2= p_approx(AL,BH,m);
    %pp3=AH*BL;
    pp3= p_approx(AH,BL,m);
    pp4=AH*BH;
    
    %p_app = p_approx(A,B,m)
    p_app = (pp1)+(pp2*256)+(pp3*256)+(pp4*65536);
   
    err = (p_app - p_actual);
    if(err==0)
        count=count+1;
    end
    ED = abs(err);
    if(ED>ed)
            ed=ED;
            ed_max_a=A;
            ed_max_b=B;
     end
    RED = ED/p_actual;
    if (RED>WCRE)
        WCRE=RED;
    end
    stats(iter, :) = [A B p_actual p_app err ED RED];
  %end
 A;
end
Average_error = mean(stats(:,5))/10^4; %average error * 10^4
MED=mean(stats(:,6));
NMED = mean(stats(:,6))*1000/((2^16-1)*(2^16-1)); %nmed * 10^-3
MRED = mean(stats(:,7))*100; %percent
WCRE
Error_rate = sum(stats(:,5)~=0)*100/k;

clear i k iter err ED p_actual p_app

function [result1] = p_approx(A,B,m)
Papprox=zeros(4,10);
j=1;
count=8;
  p=dec2bin(A,8);
  q=dec2bin(B,8);
    A = reverse(dec2bin(A));
    B = reverse(dec2bin(B));
    lA = length(A);
    lB = length(B);
    a = zeros(1,m);
    b = zeros(1,m);
    for i = 1: lA
        a(i) = str2num(A(i));   
    end
    for i = 1: lB
        b(i) = str2num(B(i));   
    end
 
%     Decimal_A=bi2de(a);
%     Decimal_B=bi2de(b);
% 
%     for i=1:1:m
%         c(i+1)=a(i);
%     end
%     ax = [a, zeros(1,1)];
%     for i=1:1:m+1
%         d=c|ax;
%     end
%     AorB=0;
%     for i=1:1:m+1
%         AorB = AorB +d(i).*2.^(i-1);
%     end
    %Papprox=0;
    for i=1:2:m-5 %innacurate partial products
        tb = b(i).*2.^(0)+b(i+1).*2.^(1);
%         if Two_bits_selected==0
%             Papprox(i,:)= (dec2bin(0,9));
%         end
%         if Two_bits_selected==1
%             Papprox(i,:)= debam(a,b,i,tb)
%         end   
%         if Two_bits_selected==2
%             Papprox(i,:)= (dec2bin(Decimal_A.*2.^(i),9));
%         end
%         if Two_bits_selected==3
%             Papprox(i,:)= (dec2bin(AorB.*2.^(i-1),9));
%         end
        yy(10)=0;
        if(i==1)
            yy= idebam(a,b,tb);
        else
            yy= debam(a,b,tb);
        end
        %yy(10)=0;
        Papprox(j,:)=yy;
        j=j+1;
    end
    for i = m-3:2:m %accurate partial products
%         if b(i)==1
%j=3;
            z= recursive(a,b,i);
           Papprox(j,:)=z;
           count=count-2;
           j=j+1;
      %  end
    end
  Papprox;
   result=addition_multiplier(Papprox);
   result1=bi2de(result);
  end

function [z]=recursive(a,b,k)
P1 = zeros(1,8);
P2 = zeros(1,8);
for i=1:8
      P1(i)= and(a(i),b(k));
   P2(i)= and(a(i),b(k+1));
   
end
z(1)=P1(1);
[z(2),CA1] = HA(P1(2),P2(1));
[z(3),CA2] = FA(P1(3),P2(2),CA1);
[z(4),CA3] = FA(P1(4),P2(3),CA2);
[z(5),CA4] = FA(P1(5),P2(4),CA3);
[z(6),CA5] = FA(P1(6),P2(5),CA4);
[z(7),CA6] = FA(P1(7),P2(6),CA5);
[z(8),CA7] = FA(P1(8),P2(7),CA6);
[z(9),z(10)] = HA(P2(8),CA7);
end

function [result]=idebam(a,b,tb)
z1=zeros(1,10);
if(tb==0)
 z1(1)=0;
 z1(2)=0;
 z1(3)=0;
 z1(4)=0;
 z1(5)=0;
 z1(6)=0;
 z1(7)=0;
 z1(8)=0;
 z1(9)=0;
 z1(10)=0;
 result=z1;
elseif(tb==1)
       
 z1(1)=a(1);
 z1(2)=a(2);
 z1(3)=a(3);
 z1(4)=a(4);
 z1(5)=a(5);
 z1(6)=a(6);
 z1(7)=a(7);
 z1(8)=a(8);
 z1(9)=0;
 z1(10)=0;
 result=z1;
elseif (tb==2)
  z1(1)=0;
  z1(2)=a(1);
  z1(3)=a(2);
  z1(4)=a(3);
  z1(5)=a(4);
  z1(6)=a(5);
  z1(7)=a(6);
  z1(8)=a(7);
  z1(9)=a(8); 
 result=z1;%
else
  z1(1)=a(1);
  z1(2)=or(a(2),a(1));
  z1(3)=or(a(3),a(2));
  z1(4)=or(a(4),a(3));
  z1(5)=or(a(5),a(4));
  z1(6)=or(a(6),a(5));
  z1(7)=or(a(7),a(6));
  z1(8)=or(a(8),a(7));
  z1(9)=a(8);
  result=z1;%
end
end

function [result]=debam(a,b,tb)
cin=0;
z=zeros(1,10);
P1 = zeros(1,8);
P2 = zeros(1,8);
p = zeros(1,10);
pls = zeros(1,10);
pnot = zeros(1,10);
g = zeros(1,10);
c = zeros(1,10);
ov = zeros(1,10);
cond = zeros(1,10);
w1 = zeros(1,10);
w2 = zeros(1,10);
% for i=1:8
%       P1(i)= and(a(i),b(k));
%    P2(i)= and(a(i),b(k+1));
%    
% end
z(10)=0;
 shift_left=zeros(1,9);
 shift_left(1)=0;
 shift_left(2)=a(1);
 shift_left(3)=a(2);
 shift_left(4)=a(3);
 shift_left(5)=a(4);
 shift_left(6)=a(5);
 shift_left(7)=a(6);
 shift_left(8)=a(7);
 shift_left(9)=a(8); 
 
if(tb==0)
 z(1)=0;
 z(2)=0;
 z(3)=0;
 z(4)=0;
 z(5)=0;
 z(6)=0;
 z(7)=0;
 z(8)=0;
 z(9)=0;
 z(10)=0;
 result=z;
elseif(tb==1)
       
 z(1)=a(1);
 z(2)=a(2);
 z(3)=a(3);
 z(4)=a(4);
 z(5)=a(5);
 z(6)=a(6);
 z(7)=a(7);
 z(8)=a(8);
 z(9)=0;
 z(10)=0;
 result=z;
elseif (tb==2)
  z(1)=0;
  z(2)=a(1);
  z(3)=a(2);
  z(4)=a(3);
  z(5)=a(4);
  z(6)=a(5);
  z(7)=a(6);
  z(8)=a(7);
  z(9)=a(8); 
 result=z;%
else
    
 p(1)=or(shift_left(1),a(1));
 p(2)=or(a(2),shift_left(2));
 p(3)=or(a(3),shift_left(3));
 p(4)=or(shift_left(4),a(4));
 p(5)=or(a(5),shift_left(5));
 p(6)=or(shift_left(6),a(6));
 p(7)=or(a(7),shift_left(7));
 p(8)=or(shift_left(8),a(8));
 p(9)=or(shift_left(9),cin);
 p(10)=0;
 
 g(1)=and(shift_left(1),a(1));
 g(2)=and(a(2),shift_left(2));
 g(3)=and(a(3),shift_left(3));
 g(4)=and(shift_left(4),a(4));
 g(5)=and(a(5),shift_left(5));
 g(6)=and(shift_left(6),a(6));
 g(7)=and(a(7),shift_left(7));
 g(8)=and(shift_left(8),a(8));
 g(9)=and(shift_left(9),cin);
 g(10)=0;
 
 pls(1)=0;
 pls(2)=p(1);
 pls(3)=p(2);
 pls(4)=p(3);
 pls(5)=p(4);
 pls(6)=p(5);
 pls(7)=p(6);
 pls(8)=p(7);
 pls(9)=p(8);
 pls(10)=p(9);
 
 %pnot=bitcmp(p);
 pnot(1) = not(p(1));
 pnot(2) = not(p(2));
 pnot(3) = not(p(3));
 pnot(4) = not(p(4));
 pnot(5) = not(p(5));
 pnot(6) = not(p(6));
 pnot(7) = not(p(7));
 pnot(8) = not(p(8));
 pnot(9) = not(p(9));
 pnot(10) = not(p(10));
 
 %c = bitand(pnot,pls);
 c(1) = and(pnot(1),pls(1));
 c(2) = and(pnot(2),pls(2));
 c(3) = and(pnot(3),pls(3));
 c(4) = and(pnot(4),pls(4));
 c(5) = and(pnot(5),pls(5));
 c(6) = and(pnot(6),pls(6));
 c(7) = and(pnot(7),pls(7));
 c(8) = and(pnot(8),pls(8));
 c(9) = and(pnot(9),pls(9));
 c(10) = and(pnot(10),pls(10));
 
 %ov = bitor(c,g);
 ov(1) = or(c(1),g(1));
 ov(2) = or(c(2),g(2));
 ov(3) = or(c(3),g(3));
 ov(4) = or(c(4),g(4));
 ov(5) = or(c(5),g(5));
 ov(6) = or(c(6),g(6));
 ov(7) = or(c(7),g(7));
 ov(8) = or(c(8),g(8));
 ov(9) = or(c(9),g(9));
 ov(10) = or(c(10),g(10));
 
 cd1 = or(g(8),g(7));
 cd = or(cd1,g(6));
 %cd = or(g(8),g(7));
 cdnot = not(cd);
 
 cond(1) = cd;
 cond(2) = cd;
 cond(3) = cd;
 cond(4) = cd;
 cond(5) = cd;
 cond(6) = cd;
 cond(7) = cd;
 cond(8) = cd;
 cond(9) = cd;
 cond(10) = cd;
 
 condnot(1) = cdnot;
 condnot(2) = cdnot;
 condnot(3) = cdnot;
 condnot(4) = cdnot;
 condnot(5) = cdnot;
 condnot(6) = cdnot;
 condnot(7) = cdnot;
 condnot(8) = cdnot;
 condnot(9) = cdnot;
 condnot(10) = cdnot;
 
 w1(1) = and(condnot(1),p(1));
 w1(2) = and(condnot(2),p(2));
 w1(3) = and(condnot(3),p(3));
 w1(4) = and(condnot(4),p(4));
 w1(5) = and(condnot(5),p(5));
 w1(6) = and(condnot(6),p(6));
 w1(7) = and(condnot(7),p(7));
 w1(8) = and(condnot(8),p(8));
 w1(9) = and(condnot(9),p(9));
 w1(10) = and(condnot(10),p(10));
 
 w2(1) = and(cond(1),ov(1));
 w2(2) = and(cond(2),ov(2));
 w2(3) = and(cond(3),ov(3));
 w2(4) = and(cond(4),ov(4));
 w2(5) = and(cond(5),ov(5));
 w2(6) = and(cond(6),ov(6));
 w2(7) = and(cond(7),ov(7));
 w2(8) = and(cond(8),ov(8));
 w2(9) = and(cond(9),ov(9));
 w2(10) = and(cond(10),ov(10));
 
 z(1) = or(w1(1),w2(1));
 z(2) = or(w1(2),w2(2));
 z(3) = or(w1(3),w2(3));
 z(4) = or(w1(4),w2(4));
 z(5) = or(w1(5),w2(5));
 z(6) = or(w1(6),w2(6));
 z(7) = or(w1(7),w2(7));
 z(8) = or(w1(8),w2(8));
 z(9) = or(w1(9),w2(9));
 z(10) = or(w1(10),w2(10));
 
 %z(1) = ov(1);
 %z(2) = ov(2);
 %z(3) = ov(3);
 %z(4) = ov(4);
 %z(5) = ov(5);
 %z(1) = p(1);
 %z(2) = p(2);
 %z(3) = p(3);
 %z(4) = p(4);
 %z(5) = p(5);
 %z(6) = p(6);
 %z(7) = p(7);
 %z(8) = p(8);
 result=z;   
  %result=ov;
end
end

function result=addition_multiplier(Papprox)
result(1)=Papprox(1,1);
result(2)=Papprox(1,2);
%% stage1......................
%[result(3),carry(3)]=HA(Papprox(1,3),Papprox(2,1));
%[result(4),carry(4)]=FA(Papprox(1,4),Papprox(2,2),carry(3));

result(3) = or(Papprox(1,3),Papprox(2,1));
result(4) = or(Papprox(1,4),Papprox(2,2));
carry(4)=0;

[sum1,carry(5)]=FA(Papprox(1,5),Papprox(2,3),Papprox(3,1));
[sum2,carry(6)]=FA(Papprox(1,6),Papprox(2,4),Papprox(3,2));
[sum3,carry(7)]=FA(Papprox(1,7),Papprox(2,5),Papprox(3,3));
[sum4,carry(8)]=FA(Papprox(1,8),Papprox(2,6),Papprox(3,4));
[sum5,carry(9)]=FA(Papprox(1,9),Papprox(2,7),Papprox(3,5));
[sum6,carry(10)]=FA(Papprox(4,4),Papprox(2,8),Papprox(3,6));
[sum7,carry(11)]=FA(Papprox(4,5),Papprox(2,9),Papprox(3,7));
[sum8,carry(12)]=FA(Papprox(4,6),Papprox(3,8),Papprox(2,10)); %
[sum9,carry(13)]=HA(Papprox(4,7),Papprox(3,9));

%% stage2..............
[result(5),carry(14)]=HA(sum1,carry(4));
[result(6),carry(15)]=FA(sum2,carry(5),carry(14));
[sum10,carry(16)]=FA(Papprox(4,1),sum3,carry(6));
[sum11,carry(17)]=FA(Papprox(4,2),sum4,carry(7));
[sum12,carry(18)]=FA(Papprox(4,3),sum5,carry(8));
[sum13,carry(19)]=FA(sum6,carry(9),carry(18));
[sum14,carry(20)]=FA(sum7,carry(10),carry(19));
[sum15,carry(21)]=FA(sum8,carry(11),carry(20));
[sum16,carry(22)]=FA(sum9,carry(12),carry(21));
[sum17,carry(23)]=FA(Papprox(4,8),carry(13),carry(22));
[sum18,carry(24)]=HA(Papprox(4,9),carry(23));
[sum19,carry(25)]=HA(Papprox(4,10),carry(24));

%% stage 3....
[result(7),carry(26)]=HA(sum10,carry(15));
[result(8),carry(27)]=FA(sum11,carry(16),carry(26));
[result(9),carry(28)]=FA(sum12,carry(17),carry(27));
%carry(28) = and(carry(17),sum12);
[result(10),carry(29)]=FA(sum13,carry(28),Papprox(1,10));%
[result(11),carry(30)]=HA(sum14,carry(29));
[result(12),carry(31)]=HA(sum15,carry(30));
[result(13),carry(32)]=HA(sum16,carry(31));
[result(14),carry(33)]=FA(sum17,carry(32),Papprox(3,10));%
[result(15),carry(34)]=HA(sum18,carry(33));
[result(16),carry(35)]=HA(sum19,carry(34));
end